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

    gpio.gpio_a.setPinMode(0, .output_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(1, .output_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(2, .output_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(3, .output_push_pull, .max_2mhz);

    gpio.gpio_a.setPinMode(8, .af_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(9, .af_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(10, .af_push_pull, .max_2mhz);
    gpio.gpio_a.setPinMode(11, .af_push_pull, .max_2mhz);

    timer.timer1.init();
}

pub fn main() noreturn {
    init() catch {};

    @breakpoint();
    while (true) {}
}
