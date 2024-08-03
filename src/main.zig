const std = @import("std");
const rcc = @import("rcc.zig");
const gpio = @import("gpio.zig");
const timer = @import("timer.zig");

comptime {
    // Force import start.zig
    _ = @import("start.zig");
}

fn init() !void {
    rcc.init();
    rcc.enable(.IOPA, true);
    rcc.enable(.TIM2, true);

    gpio.gpio_a.setPinMode(1, .af_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(2, .af_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(3, .af_push_pull, .max_2mhz);

    timer.timer2.init();
}

pub fn main() noreturn {
    init() catch {};

    // Function
    @breakpoint();
    while (true) {}
}
