const std = @import("std");
const root = @import("root");

extern var __bss_start: u32;
extern var __bss_end: u32;

extern var __data_load: u32;
extern var __data_start: u32;
extern var __data_end: u32;

pub fn entry() callconv(.C) noreturn {
    const bss = @as([*]u32, @ptrCast(&__bss_start))[0 .. &__bss_end - &__bss_start];
    @memset(bss, 0);
    const data = @as([*]u32, @ptrCast(&__data_start))[0 .. &__data_end - &__data_start];
    @memcpy(data, @as([*]u32, @ptrCast(&__data_load)));
    root.main();
    std.debug.panic("Exited from main()", .{});
}

pub fn defaultIrq() callconv(.C) noreturn {
    std.debug.panic("Unhandled interrupt", .{});
}
