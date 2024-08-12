const std = @import("std");
const rcc = @import("rcc.zig");
// const nvic = @import("nvic.zig");
// const gpio = @import("gpio.zig");
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
    // rcc.enable(.IOPA, true);
    // rcc.enable(.IOPB, true);
    // rcc.enable(.TIM1, true);
    // rcc.enable(.TIM4, true);
    systick.init();

    // gpio.gpio_a.setPinModesComp(&.{
    //     .{ .p = 0, .m = .output_push_pull, .s = .max_2mhz },
    //     .{ .p = 1, .m = .output_push_pull, .s = .max_2mhz },
    //     .{ .p = 2, .m = .output_push_pull, .s = .max_2mhz },
    //     .{ .p = 3, .m = .output_push_pull, .s = .max_2mhz },
    //     .{ .p = 8, .m = .af_push_pull, .s = .max_2mhz },
    //     .{ .p = 9, .m = .af_push_pull, .s = .max_2mhz },
    //     .{ .p = 10, .m = .af_push_pull, .s = .max_2mhz },
    //     .{ .p = 11, .m = .af_push_pull, .s = .max_2mhz },
    // });
    // gpio.gpio_b.setPinModesComp(&.{
    //     .{ .p = 7, .m = .input_pull_up, .s = .input },
    //     .{ .p = 9, .m = .input_pull_up, .s = .input },
    // });

    // timer.timer1.initPwm(0x03ff);
    // timer.timer4.initIrRemote();

    // nvic.enable_irq(.TIM4, true);
}

pub fn main() noreturn {
    init() catch {};

    semihosting.writer.print("Hello, world!\n", .{}) catch {};

    // var ch: u8 = 1;
    while (true) {
        @breakpoint();

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
