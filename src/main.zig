const std = @import("std");
const hal = @import("stm32f722.zig");
const rcc = @import("rcc.zig");
// const nvic = @import("nvic.zig");
const gpio = @import("gpio.zig");
const spi = @import("spi.zig");
const timer = @import("timer.zig");
const systick = @import("systick.zig");
const semihosting = @import("semihosting.zig");

pub const panic = semihosting.panic;

const rcc_inst = rcc.config(.{
    .mode = .pll_hse,
    .hse_freq_hz = 19_200_000,
    .pll_freq_hz = 216_000_000,
});

const systick_inst = systick.config(rcc_inst, .{
    .tick_rate_hz = 1_000,
});

const pin_inst = gpio.initCfg(.{
    .GPIOA = .{
        .PIN0 = .{ .name = "LED_G", .mode = .af_push_pull, .af = 2, .speed = .medium, .value = 1 }, // TIM5_CH1
        .PIN1 = .{ .name = "LED_B", .mode = .af_push_pull, .af = 2, .speed = .medium, .value = 1 }, // TIM5_CH2
        .PIN2 = .{ .name = "LED_R", .mode = .af_push_pull, .af = 2, .speed = .medium, .value = 1 }, // TIM5_CH3
        .PIN3 = .{ .name = "OTG_HS_ULPI_D0", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN4 = .{ .name = null, .mode = .analog },
        .PIN5 = .{ .name = "OTG_HS_ULPI_CK", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN6 = .{ .name = "ESP_INT", .mode = .analog },
        .PIN7 = .{ .name = "IR", .mode = .input, .af = 9, .pull = .pull_up }, // TIM14_CH1
        .PIN8 = .{ .name = "MCO_1", .mode = .af_push_pull, .af = 0, .speed = .high },
        .PIN9 = .{ .name = "Y_SCK", .mode = .af_push_pull, .af = 5, .speed = .medium }, // SPI2_SCK
        .PIN10 = .{ .name = "USB_OTG_FS_ID", .mode = .af_push_pull, .af = 10, .speed = .medium },
        .PIN11 = .{ .name = "USB_OTG_FS_DM", .mode = .af_push_pull, .af = 10, .speed = .medium },
        .PIN12 = .{ .name = "USB_OTG_FS_DP", .mode = .af_push_pull, .af = 10, .speed = .medium },
        .PIN13 = .{ .name = "SWDIO", .mode = .af_push_pull, .af = 0, .speed = .medium },
        .PIN14 = .{ .name = "SWCLK", .mode = .af_push_pull, .af = 0, .speed = .medium },
        .PIN15 = .{ .name = "X_CS", .mode = .af_push_pull, .af = 6, .speed = .medium }, // SPI3_NSS
    },
    .GPIOB = .{
        .PIN0 = .{ .name = "OTG_HS_ULPI_D1", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN1 = .{ .name = "OTG_HS_ULPI_D2", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN2 = .{ .name = "X_SDI", .mode = .af_push_pull, .af = 7, .speed = .medium }, // SPI3_MOSI
        .PIN3 = .{ .name = "SWO", .mode = .af_push_pull, .af = 0, .speed = .medium },
        .PIN4 = .{ .name = "Y_CS", .mode = .af_push_pull, .af = 7, .speed = .medium }, // SPI2_NSS
        .PIN5 = .{ .name = "OTG_HS_ULPI_D7", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN6 = .{ .name = "I2C_SCL", .mode = .af_open_drain, .af = 4, .speed = .low }, // I2C1_SCL
        .PIN7 = .{ .name = "I2C_SDA", .mode = .af_open_drain, .af = 4, .speed = .low }, // I2C1_SDA
        .PIN8 = .{ .name = null, .mode = .analog },
        .PIN9 = .{ .name = null, .mode = .analog },
        .PIN10 = .{ .name = "OTG_HS_ULPI_D3", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN11 = .{ .name = "OTG_HS_ULPI_D4", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN12 = .{ .name = "OTG_HS_ULPI_D4", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN13 = .{ .name = "OTG_HS_ULPI_D6", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN14 = .{ .name = null, .mode = .analog },
        .PIN15 = .{ .name = "Y_SDI", .mode = .af_push_pull, .af = 5, .speed = .medium }, // SPI2_MOSI
    },
    .GPIOC = .{
        .PIN0 = .{ .name = "OTG_HS_ULPI_STP", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN1 = .{ .name = null, .mode = .analog },
        .PIN2 = .{ .name = "OTG_HS_ULPI_DIR", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN3 = .{ .name = "OTG_HS_ULPI_NXT", .mode = .af_push_pull, .af = 10, .speed = .high },
        .PIN4 = .{ .name = "V_SENSE", .mode = .analog }, // ADC1_IN14
        .PIN5 = .{ .name = null, .mode = .analog },
        .PIN6 = .{ .name = "XY_LDAC", .mode = .output_push_pull, .speed = .medium, .value = 1 }, // TIM3_CH1
        .PIN7 = .{ .name = "LASER_R", .mode = .output_push_pull, .speed = .medium, .value = 0 }, // TIM8_CH2
        .PIN8 = .{ .name = "LASER_G", .mode = .output_push_pull, .speed = .medium, .value = 0 }, // TIM8_CH3
        .PIN9 = .{ .name = "LASER_B", .mode = .output_push_pull, .speed = .medium, .value = 0 }, // TIM8_CH4
        .PIN10 = .{ .name = "X_SDI", .mode = .af_push_pull, .af = 6, .speed = .medium }, // SPI3_SCK
        .PIN11 = .{ .name = null, .mode = .analog },
        .PIN12 = .{ .name = null, .mode = .analog },
        .PIN13 = .{ .name = "BTN_1", .mode = .input, .pull = .pull_down },
        .PIN14 = .{ .name = "BTN_2", .mode = .input, .pull = .pull_down },
        .PIN15 = .{ .name = null, .mode = .analog },
    },
    .GPIOD = .{
        .PIN2 = .{ .name = null, .mode = .analog },
    },
});

const timer_pin_inst = gpio.initCfg(.{
    .GPIOA = .{
        .PIN7 = .{ .name = "IR", .mode = .af_push_pull, .af = 9, .pull = .pull_up }, // TIM14_CH1
    },
    .GPIOC = .{
        .PIN6 = .{ .name = "XY_LDAC", .mode = .af_push_pull, .af = 2, .speed = .medium, .value = 1 }, // TIM3_CH1
        .PIN7 = .{ .name = "LASER_R", .mode = .af_push_pull, .af = 3, .speed = .medium, .value = 0 }, // TIM8_CH2
        .PIN8 = .{ .name = "LASER_G", .mode = .af_push_pull, .af = 3, .speed = .medium, .value = 0 }, // TIM8_CH3
        .PIN9 = .{ .name = "LASER_B", .mode = .af_push_pull, .af = 3, .speed = .medium, .value = 0 }, // TIM8_CH4
    },
});

const x_spi = spi.master("SPI3");
const y_spi = spi.master("SPI2");

const timer5 = timer.config(rcc_inst, .{
    .timer = 5,
    .freq_hz = 108_000_000,
    .init_top = 65536 / 4 - 1,
    .ch = &.{
        .{ .num = 1, .name = "LED_G", .mode = .{ .output = .{
            .oc = .inverted,
            .ocn = .disabled,
            .mode = .{ .pwm = .{} },
        } } },
        .{ .num = 2, .name = "LED_B", .mode = .{ .output = .{
            .oc = .inverted,
            .ocn = .disabled,
            .mode = .{ .pwm = .{} },
        } } },
        .{ .num = 3, .name = "LED_R", .mode = .{ .output = .{
            .oc = .inverted,
            .ocn = .disabled,
            .mode = .{ .pwm = .{} },
        } } },
    },
});

const timer8 = timer.config(rcc_inst, .{
    .timer = 8,
    .freq_hz = 108_000_000,
    .init_top = 65536 - 1,
    .ch = &.{
        .{ .num = 2, .name = "LASER_R", .mode = .{ .output = .{
            .oc = .enabled,
            .ocn = .disabled,
            .mode = .{ .pwm = .{} },
        } } },
        .{ .num = 3, .name = "LASER_G", .mode = .{ .output = .{
            .oc = .enabled,
            .ocn = .disabled,
            .mode = .{ .pwm = .{} },
        } } },
        .{ .num = 4, .name = "LASER_B", .mode = .{ .output = .{
            .oc = .enabled,
            .ocn = .disabled,
            .mode = .{ .pwm = .{} },
        } } },
    },
});

const timer14 = timer.config(rcc_inst, .{
    .timer = 14,
    .freq_hz = 1_000_000,
    .init_top = 65536 - 1,
    .ch = &.{
        .{ .num = 1, .name = "IR", .interrupt = true, .mode = .{ .input = .{
            .ic = .both_edges,
            .mode = .{ .capture = .{} },
        } } },
    },
});

// const timer3 = timer.config(rcc_inst, .{
//     .timer = 3,
//     .freq_hz = 1_000_000,
//     .channels = &.{
//         .{ .num = 1, .mode = .pwm },
//     },
// });

comptime {
    hal.createIrqVect(.{
        .SysTick = &systick_inst.irq,
        // .TIM8_TRG_COM_TIM14 = &start.default_irq,
    });
}

fn init() !void {
    rcc_inst.apply();
    rcc.enablePeripheralsComp(&.{
        .{ .per = "GPIOA" },
        .{ .per = "GPIOB" },
        .{ .per = "GPIOC" },
        .{ .per = "GPIOD" },
        .{ .per = "SYSCFG" },
        .{ .per = "SPI2" },
        .{ .per = "SPI3" },
        .{ .per = "TIM3" },
        .{ .per = "TIM5" },
        .{ .per = "TIM8" },
        .{ .per = "TIM14" },
    });

    systick_inst.apply();

    gpio.ioCompEnable(true);
    pin_inst.apply();

    const spi_cfg: spi.spi_cfg_t = .{
        .cpha = 0,
        .cpol = 0,
        .bits = 16,
        .freq_hz = 20_000_000,
    };
    x_spi.init(rcc_inst, spi_cfg);
    y_spi.init(rcc_inst, spi_cfg);

    // timer3.init();
    timer5.init();
    timer8.init();
    timer14.init();

    // Connect timer pins after initialised timer
    timer_pin_inst.apply();

    // timer.timer1.initPwm(0x03ff);
    // timer.timer4.initIrRemote();
    // timer.timer14.initIrRemote();

    // nvic.enable_irq(.TIM4, true);
}

pub fn main() noreturn {
    init() catch {};

    // semihosting.writer.print("Hello, world!\n", .{}) catch {};

    var tick = systick_inst.get_ms();
    const top = timer8.getTop();
    var cmp: u32 = 0;
    while (true) {
        const now = systick_inst.get_ms();
        if (now != tick) {
            tick = now;
            if (pin_inst.pins.BTN_1.read() != 0) {
                if (cmp != top)
                    cmp += 1;
            }
            if (pin_inst.pins.BTN_2.read() != 0) {
                if (cmp != 0)
                    cmp -= 1;
            }
            timer5.channels.LED_R.setCmp(cmp);
            timer5.channels.LED_G.setCmp(cmp);
            timer5.channels.LED_B.setCmp(cmp);
            timer8.channels.LASER_R.setCmp(cmp);
            timer8.channels.LASER_G.setCmp(cmp);
            timer8.channels.LASER_B.setCmp(cmp);
        }
    }

    // const seq = [_]struct { x: u16, y: u16, steps: u16 }{
    //     .{ .x = 0, .y = 0, .steps = 1000 },
    //     .{ .x = 0, .y = 0, .steps = 500 },
    //     .{ .x = 0, .y = 0xfff, .steps = 1000 },
    //     .{ .x = 0, .y = 0xfff, .steps = 500 },
    //     .{ .x = 0xfff, .y = 0xfff, .steps = 1000 },
    //     .{ .x = 0xfff, .y = 0xfff, .steps = 500 },
    //     .{ .x = 0xfff, .y = 0, .steps = 1000 },
    //     .{ .x = 0xfff, .y = 0, .steps = 500 },
    // };

    // const seq = [_]struct {
    //     x: u16,
    //     y: u16,
    //     steps: u16,
    //     on: bool = true,
    // }{
    //     .{ .x = 100, .y = 100, .steps = 100, .on = false },
    //     .{ .x = 100, .y = 100, .steps = 100, .on = false },
    //     .{ .x = 100, .y = 100, .steps = 100 },
    //     .{ .x = 100, .y = 1900, .steps = 200 },
    //     .{ .x = 100, .y = 1900, .steps = 100 },
    //     .{ .x = 100, .y = 980, .steps = 1 },
    //     .{ .x = 100, .y = 980, .steps = 100 },
    //     .{ .x = 900, .y = 980, .steps = 20 },
    //     .{ .x = 900, .y = 980, .steps = 100 },
    //     .{ .x = 900, .y = 100, .steps = 1 },
    //     .{ .x = 900, .y = 100, .steps = 100 },
    //     .{ .x = 900, .y = 1900, .steps = 200 },
    //     .{ .x = 900, .y = 1900, .steps = 100 },
    // };

    // var last_x: u16 = seq[seq.len - 1].x;
    // var last_y: u16 = seq[seq.len - 1].y;
    // var iseq: u16 = 0;
    // var step: u16 = 0;

    // const pins = pin_inst.pins;
    // while (true) {
    //     step += 1;
    //     const s = seq[iseq];
    //     const x: i32 = @as(i32, last_x) + @divTrunc((@as(i32, s.x) - @as(i32, last_x)) * @as(i32, step), s.steps);
    //     const y: i32 = @as(i32, last_y) + @divTrunc((@as(i32, s.y) - @as(i32, last_y)) * @as(i32, step), s.steps);

    //     if (step == s.steps) {
    //         last_x = s.x;
    //         last_y = s.y;
    //         step = 0;
    //         iseq = (iseq + 1) % @as(u16, seq.len);
    //     }

    //     if (!s.on) {
    //         pins.LASER_R.write(0);
    //         pins.LASER_G.write(0);
    //         pins.LASER_B.write(0);
    //     }

    //     const ux = @as(u12, @intCast(x));
    //     const uy = @as(u12, @intCast(y));
    //     x_spi.transmit((0b0111 << 12) + @as(u16, ux));
    //     y_spi.transmit((0b0111 << 12) + @as(u16, uy));
    //     x_spi.transmit((0b1111 << 12) + @as(u16, ~ux));
    //     y_spi.transmit((0b1111 << 12) + @as(u16, ~uy));
    //     pins.XY_LDAC.write(0);
    //     systick_inst.delay_us(2);
    //     pins.XY_LDAC.write(1);
    //     systick_inst.delay_us(2);

    //     // pins.LED_R.write(pins.IR.read());
    //     // pins.LED_G.write(~pins.BTN_1.read());
    //     // pins.LED_B.write(~pins.BTN_2.read());

    //     if (s.on) {
    //         pins.LASER_R.write(~pins.IR.read());
    //         pins.LASER_G.write(pins.BTN_1.read());
    //         pins.LASER_B.write(pins.BTN_2.read());
    //     }
    // }

    // var ch: u8 = 1;
    // while (true) {
    //     const ir = timer.timer4.popIrRemote(1);
    //     if (ir != 0) {
    //         const out = semihosting.writer;
    //         out.print("IR: 0x{x:08}\n", .{ir}) catch {};

    //         const mask = 0xfffffcfc;
    //         const button = enum(u32) { // Sky NOW TV remote
    //             back = 0x57436699 & mask,
    //             home = 0x5743c03f & mask,
    //             ok = 0x574354ab & mask,
    //             up = 0x57439966 & mask,
    //             down = 0x5743cd32 & mask,
    //             left = 0x57437986 & mask,
    //             right = 0x5743b54a & mask,
    //             rewind = 0x57432dd2 & mask,
    //             pause = 0x574333cc & mask,
    //             ff = 0x5743ab54 & mask,
    //             star = 0x57438679 & mask,
    //             now = 0x574320df & mask,
    //             store = 0x574318e7 & mask,
    //         };
    //         switch (@as(button, @enumFromInt(ir & mask))) {
    //             .rewind => ch = 1,
    //             .pause => ch = 2,
    //             .ff => ch = 3,
    //             .up => timer.timer1.setCC(ch, timer.timer1.getCC(ch) +% 8),
    //             .down => timer.timer1.setCC(ch, @max(timer.timer1.getCC(ch), 8) -% 8),
    //             .left => timer.timer1.setCC(ch, @max(timer.timer1.getCC(ch), 1) -% 1),
    //             .right => timer.timer1.setCC(ch, timer.timer1.getCC(ch) +% 1),
    //             .back => @breakpoint(),
    //             else => {},
    //         }
    //     }
    // }
}
