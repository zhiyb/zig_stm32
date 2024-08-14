const std = @import("std");
const rcc = @import("rcc.zig");
// const nvic = @import("nvic.zig");
const gpio = @import("gpio.zig");
const dac = @import("dac.zig");
// const timer = @import("timer.zig");
const systick = @import("systick.zig");
const semihosting = @import("semihosting.zig");

pub const panic = semihosting.panic;

comptime {
    // Force import start.zig
    _ = @import("start.zig");
}

fn init() !void {
    rcc.init();
    rcc.enablePeripheralsComp(&.{
        .{ .per = "GPIOA" },
        .{ .per = "GPIOB" },
        .{ .per = "DAC" },
    });

    systick.init();

    gpio.gpio_a.setPinModesComp(&.{
        .{ .pin = 0, .mode = .analog },
        .{ .pin = 1, .mode = .analog },
        .{ .pin = 2, .mode = .analog },
        .{ .pin = 3, .mode = .analog },
        .{ .pin = 4, .mode = .analog }, // DAC_OUT1
        .{ .pin = 5, .mode = .analog }, // DAC_OUT2
        .{ .pin = 6, .mode = .analog },
        .{ .pin = 7, .mode = .analog },
        .{ .pin = 8, .mode = .analog },
        .{ .pin = 9, .mode = .analog },
        .{ .pin = 10, .mode = .analog },
        .{ .pin = 11, .mode = .analog },
        .{ .pin = 12, .mode = .analog },
        .{ .pin = 13, .mode = .af_push_pull, .af = 0, .speed = .high }, // SWDIO
        .{ .pin = 14, .mode = .af_push_pull, .af = 0, .speed = .high }, // SWCLK
        .{ .pin = 15, .mode = .analog },
    });
    gpio.gpio_b.setPinModesComp(&.{
        .{ .pin = 14, .mode = .af_push_pull, .af = 12, .speed = .medium }, // USB_DM
        .{ .pin = 15, .mode = .af_push_pull, .af = 12, .speed = .medium }, // USB_DP
    });

    dac.init();

    // timer.timer1.initPwm(0x03ff);
    // timer.timer4.initIrRemote();

    // nvic.enable_irq(.TIM4, true);
}

pub fn main() noreturn {
    init() catch {};

    semihosting.writer.print("Hello, world!\n", .{}) catch {};

    var dac1: u12 = 0;
    // var ch: u8 = 1;
    while (true) {
        const dac2: u12 = ~dac1;
        dac.update(dac1, dac2);
        systick.delay_us(100);
        dac1 +%= 1;

        // const ir = timer.timer4.popIrRemote(1);
        // if (ir != 0) {
        //     const out = semihosting.writer;
        //     out.print("IR: 0x{x:08}\n", .{ir}) catch {};

        //     const mask = 0xfffffcfc;
        //     const button = enum(u32) { // Sky NOW TV remote
        //         back = 0x57436699 & mask,
        //         home = 0x5743c03f & mask,
        //         ok = 0x574354ab & mask,
        //         up = 0x57439966 & mask,
        //         down = 0x5743cd32 & mask,
        //         left = 0x57437986 & mask,
        //         right = 0x5743b54a & mask,
        //         rewind = 0x57432dd2 & mask,
        //         pause = 0x574333cc & mask,
        //         ff = 0x5743ab54 & mask,
        //         star = 0x57438679 & mask,
        //         now = 0x574320df & mask,
        //         store = 0x574318e7 & mask,
        //     };
        //     switch (@as(button, @enumFromInt(ir & mask))) {
        //         .rewind => ch = 1,
        //         .pause => ch = 2,
        //         .ff => ch = 3,
        //         .up => timer.timer1.setCC(ch, timer.timer1.getCC(ch) +% 8),
        //         .down => timer.timer1.setCC(ch, @max(timer.timer1.getCC(ch), 8) -% 8),
        //         .left => timer.timer1.setCC(ch, @max(timer.timer1.getCC(ch), 1) -% 1),
        //         .right => timer.timer1.setCC(ch, timer.timer1.getCC(ch) +% 1),
        //         .back => @breakpoint(),
        //         else => {},
        //     }
        // }
    }
}
