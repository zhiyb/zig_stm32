const std = @import("std");
const hal = @import("stm32f103.zig");

// https://developer.arm.com/documentation/dui0471/i/semihosting/semihosting-operations
pub const op = enum(i32) {
    angel_SWIreason_EnterSVC = 0x17,
    angel_SWIreason_ReportException = 0x18,
    SYS_CLOSE = 0x02,
    SYS_CLOCK = 0x10,
    SYS_ELAPSED = 0x30,
    SYS_ERRNO = 0x13,
    SYS_FLEN = 0x0C,
    SYS_GET_CMDLINE = 0x15,
    SYS_HEAPINFO = 0x16,
    SYS_ISERROR = 0x08,
    SYS_ISTTY = 0x09,
    SYS_OPEN = 0x01,
    SYS_READ = 0x06,
    SYS_READC = 0x07,
    SYS_REMOVE = 0x0E,
    SYS_SEEK = 0x0A,
    SYS_SYSTEM = 0x12,
    SYS_TICKFREQ = 0x31,
    SYS_TIME = 0x11,
    SYS_TMPNAM = 0x0D,
    SYS_WRITE = 0x05,
    SYS_WRITEC = 0x03,
    SYS_WRITE0 = 0x04,
};

fn callback(_: void, string: []const u8) error{}!usize {
    // Skip if debugger not active
    if (!hal.dbgEn())
        return string.len;

    // Convert to 0-terminated string blocks
    var len = string.len;
    var ofs: usize = 0;
    while (len != 0) {
        var buf: [64:0]u8 = .{0} ** 64;
        const blen = @min(buf.len, len);
        @memcpy(buf[0..blen], string[ofs..blen]);
        buf[blen] = 0;

        const data: [*:0]const u8 = &buf;
        asm volatile ("bkpt #0xab"
            :
            : [cmd] "{r0}" (@intFromEnum(op.SYS_WRITE0)),
              [data] "{r1}" (data),
            : "r0"
        );

        len -= blen;
        ofs += blen;
    }
    return string.len;
}

pub const writer = std.io.Writer(void, error{}, callback){ .context = {} };

pub fn panic(msg: []const u8, error_return_trace: ?*std.builtin.StackTrace, ret_addr: ?usize) noreturn {
    @setCold(true);

    //_ = msg;
    _ = error_return_trace;
    //_ = ret_addr;

    while (true) {
        if (hal.dbgEn()) {
            writer.print("panic at 0x{?x:08}: {s}\n", .{ ret_addr, msg }) catch {};
            @breakpoint();
        }
    }
}
