#!/usr/bin/env python3
import argparse
from os.path import commonprefix
from xml.dom.minidom import parse

indent_step = 4

def getText(node):
    rc = []
    for node in node.childNodes:
        if node.nodeType == node.TEXT_NODE:
            rc.append(node.data)
    return ''.join(rc)

def findElements(node, tagName):
    return [n for n in node.childNodes
            if n.nodeType == node.ELEMENT_NODE
            and n.tagName == tagName]


def parseField(indent, pname, rname, addr, bofs, bwidth, field):
    fname = getText(findElements(field, "name")[0])
    print(f"{addr:#010x} {pname}.{rname}.{fname} {bofs}+{bwidth}")
    fstr = f"{' '*indent}{fname}: u{bwidth} = 0,\n"
    return fstr

def parseFields(indent, pname, rname, addr, fields):
    fmap = {}
    fmask = 0
    for field in findElements(fields[0], "field"):
        bofs = int(getText(findElements(field, "bitOffset")[0]), 0)
        bwidth = int(getText(findElements(field, "bitWidth")[0]), 0)
        bmask = ((1 << bwidth) - 1) << bofs
        if fmask & bmask:
            raise RuntimeError("Overlapping field bit offset")
        fmask |= bmask
        fmap[bofs] = (bwidth, field)

    # Ordered by bit offset
    fstrs = []
    fbofs = 0
    fresv = 0
    for bofs, (bwidth, field) in [(k, fmap[k]) for k in sorted(fmap.keys())]:
        if bofs > fbofs:
            # Insert reserved fields
            rbwidth = bofs - fbofs
            fstrs.append(f"{' '*indent}_RESERVED{fresv}: u{rbwidth} = 0,\n")
            fresv += 1
            fbofs += rbwidth
        fstrs.append(parseField(indent, pname, rname, addr, bofs, bwidth, field))
        fbofs += bwidth
    if fbofs < 32:
        # Insert final reserved field
        rbwidth = 32 - fbofs
        fstrs.append(f"{' '*indent}_RESERVED{fresv}: u{rbwidth} = 0,\n")
    return "".join(fstrs)


def parseRegister(indent, pname, rname, addr, register):
    rstr = ""
    size = int(getText(findElements(register, "size")[0]), 0)
    if size != 32:
        raise RuntimeError(f"Register not 32-bit: {addr:#010x} {pname}.{rname} {size}")

    fields = findElements(register, "fields")
    if not fields:
        # Register without field definitions
        rstr += f"{' '*indent}{rname}: u32 = 0,\n"
        print(f"{addr:#010x} {pname}.{rname}")

    else:
        # Register with field definitions
        rstr += f"{' '*indent}{rname}: mmio.Mmio(packed struct {{\n"
        findent = indent + indent_step
        rstr += parseFields(findent, pname, rname, addr, fields)
        rstr += f"{' '*indent}}}),\n"

    return rstr

def parseRegisters(indent, pname, base, registers):
    rmap = {}
    rstrs = []
    for register in findElements(registers, "register"):
        rname = getText(findElements(register, "name")[0])
        ofs = int(getText(findElements(register, "addressOffset")[0]), 0)
        addr = base + ofs
        regs = rmap.get(addr, [])
        regs.append((rname, register))
        rmap[addr] = regs

    # Ordered by address
    raddr = base
    rresv = 0
    for addr, regs in [(k, rmap[k]) for k in sorted(rmap.keys())]:
        rstr = ""
        rindent = indent + indent_step

        if addr > raddr:
            # Insert reserved registers
            rcnt = addr - raddr
            while rcnt:
                # Maximum allowed Zig bit-width of an integer type is 65535
                # Limit maximum to 32768
                ricnt = min(rcnt, 32768 // 8)
                rstrs.append(f"{' '*rindent}_RESERVED{rresv}: [{ricnt}]u8 = undefined,\n")
                rresv += 1
                raddr += ricnt
                rcnt -= ricnt
        raddr += 4

        # Create union for overlapping registers
        cname = ""
        if len(regs) > 1:
            cname = commonprefix([rname for rname, _ in regs])
            cname = cname.strip("_")
            rstr += f"{' '*rindent}{cname}: extern union {{\n"
            rindent += indent_step

        rrstrs = []
        for rname, register in regs:
            rname = rname[len(cname):].strip("_")
            rrstrs.append(parseRegister(rindent, pname, rname, addr, register))
        rstr += "\n".join(rrstrs)

        if len(regs) > 1:
            rindent -= indent_step
            rstr += f"{' '*rindent}}},\n"

        rstrs.append(rstr)
    return "\n".join(rstrs)


def parsePeripheral(indent, pname, base, peripheral):
    pstr = f"{' '*indent}pub const {pname}: *volatile extern struct {{\n"
    registers = findElements(peripheral, "registers")[0]
    pstr += parseRegisters(indent, pname, base, registers)
    pstr += f"{' '*indent}}} = @ptrFromInt({base:#010x});\n"
    return pstr

def parsePeripherals(indent, peripherals):
    pmap = {}
    pstrs = []
    imap = {}
    for peripheral in findElements(peripherals, "peripheral"):
        pname = getText(findElements(peripheral, "name")[0])
        base = int(getText(findElements(peripheral, "baseAddress")[0]), 0)

        for interrupt in findElements(peripheral, "interrupt"):
            idx = int(getText(findElements(interrupt, "value")[0]), 0)
            iname = getText(findElements(interrupt, "name")[0])
            if idx in imap:
                if iname == imap[idx][0]:
                    # Bug in STM32 SVD, duplicated interrupt declaration
                    continue
                raise RuntimeError(f"Overlapping interrupt {idx}")
            imap[idx] = (iname, interrupt)

        derived = peripheral.getAttribute("derivedFrom")
        if derived:
            # Same type as derived source
            pstrs.append(f"{' '*indent}pub const {pname}: @TypeOf({derived}) = @ptrFromInt({base:#010x});\n")
            continue

        pmap[pname] = peripheral
        pstrs.append(parsePeripheral(indent, pname, base, peripheral))

    # Interrupt enum
    istr = f"{' '*indent}pub const IRQ = enum(u32) {{\n"
    iindent = indent + indent_step
    for idx, (iname, interrupt) in [(k, imap[k]) for k in sorted(imap.keys())]:
        istr += f"{' '*iindent}{iname} = {idx},\n"
        print(idx, iname, interrupt)
    istr += "};\n"
    pstrs.append(istr)

    return "\n".join(pstrs)


def main():
    parser = argparse.ArgumentParser(
        prog='svd2zig', description='SVD to ZIG HAL')
    parser.add_argument("input")
    parser.add_argument("output")
    args = parser.parse_args()

    dom = parse(args.input)
    device = findElements(dom, "device")[0]
    name = getText(findElements(device, "name")[0])
    print(f"device: {name}")

    with open(args.output, "w") as fout:
        fout.write("""const std = @import("std");
const mmio = @import("mmio.zig");

// Common helper functions
pub inline fn set_masked(self: anytype, mask: @TypeOf(self.*), val: @TypeOf(self.*)) void {
    if (!std.meta.eql(mask, .{}))
        self.* = @bitCast((@as(u32, @bitCast(self.*)) &
            ~@as(u32, @bitCast(mask))) | @as(u32, @bitCast(val)));
}

// Peripherals
""")
        peripherals = findElements(device, "peripherals")[0]
        fout.write(parsePeripherals(0, peripherals))

if __name__ == "__main__":
    main()
