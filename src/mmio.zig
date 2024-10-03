// From microzig

const std = @import("std");
const assert = std.debug.assert;

pub fn Mmio(comptime PackedT: type) type {
    const size = @bitSizeOf(PackedT);
    if ((size % 8) != 0)
        @compileError("size must be divisible by 8!");

    if (!std.math.isPowerOfTwo(size / 8))
        @compileError("size must encode a power of two number of bytes!");

    const IntT = std.meta.Int(.unsigned, size);

    if (@sizeOf(PackedT) != (size / 8))
        @compileError(std.fmt.comptimePrint("IntT and PackedT must have the same size!, they are {} and {} bytes respectively", .{ size / 8, @sizeOf(PackedT) }));

    return extern struct {
        const Self = @This();

        raw: IntT,

        pub const underlying_type = PackedT;

        pub inline fn read(addr: *volatile Self) PackedT {
            return @bitCast(addr.raw);
        }

        pub inline fn read_raw(addr: *volatile Self) IntT {
            return addr.raw;
        }

        pub inline fn write(addr: *volatile Self, val: PackedT) void {
            comptime {
                assert(@bitSizeOf(PackedT) == @bitSizeOf(IntT));
            }
            addr.write_raw(@bitCast(val));
        }

        pub fn write_raw(addr: *volatile Self, val: IntT) void {
            addr.raw = val;
        }

        pub inline fn modify(addr: *volatile Self, fields: anytype) void {
            var val = addr.read();
            inline for (@typeInfo(@TypeOf(fields)).@"struct".fields) |field| {
                @field(val, field.name) = @field(fields, field.name);
            }
            addr.write(val);
        }

        pub inline fn modify_masked(addr: *volatile Self, mask: PackedT, val: PackedT) void {
            const mask_int = @as(IntT, @bitCast(mask));
            if (mask_int == 0) {
                return;
            } else if (~mask_int == 0) {
                addr.write(val);
            } else {
                var reg_val = addr.read();
                inline for (@typeInfo(PackedT).@"struct".fields) |field| {
                    if (@field(mask, field.name) != 0)
                        @field(reg_val, field.name) = @field(val, field.name);
                }
                addr.write(reg_val);
            }
        }

        pub inline fn toggle(addr: *volatile Self, fields: anytype) void {
            var val = addr.read();
            inline for (@typeInfo(@TypeOf(fields)).@"struct".fields) |field| {
                @field(val, field.name) = @field(val, field.name) ^ @field(fields, field.name);
            }
            addr.write(val);
        }
    };
}
