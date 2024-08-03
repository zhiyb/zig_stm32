const std = @import("std");
const rcc = @import("rcc.zig");
const gpio = @import("gpio.zig");
const timer = @import("timer.zig");
const systick = @import("systick.zig");

comptime {
    // Force import start.zig
    _ = @import("start.zig");
}

fn init() !void {
    rcc.init();
    rcc.enable(.IOPA, true);
    rcc.enable(.TIM1, true);
    systick.init();

    gpio.gpio_a.setPinModesComp(&.{
        .{ .p = 0, .m = .output_push_pull, .s = .max_2mhz },
        .{ .p = 1, .m = .output_push_pull, .s = .max_2mhz },
        .{ .p = 2, .m = .output_push_pull, .s = .max_2mhz },
        .{ .p = 3, .m = .output_push_pull, .s = .max_2mhz },
        .{ .p = 8, .m = .af_push_pull, .s = .max_2mhz },
        .{ .p = 9, .m = .af_push_pull, .s = .max_2mhz },
        .{ .p = 10, .m = .af_push_pull, .s = .max_2mhz },
        .{ .p = 11, .m = .af_push_pull, .s = .max_2mhz },
    });

    timer.timer1.init();
}

pub fn main() noreturn {
    init() catch {};

    @breakpoint();
    while (true) {}
}
