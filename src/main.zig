const std = @import("std");
const hal = @import("stm32f722.zig");
const rcc = @import("rcc.zig");
const nvic = @import("nvic.zig");
const gpio = @import("gpio.zig");
const spi = @import("spi.zig");
const timer = @import("timer.zig");
const systick = @import("systick.zig");
const ir_remote = @import("ir_remote.zig");
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

const timer5 = timer.config(rcc_inst, .{
    .timer = 5,
    .freq_hz = 108_000_000,
    .init_top = 65536 - 1,
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
            .irq_cc = &ir_remote_inst.irq,
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

const ir_remote_inst = ir_remote.config();

const x_spi = spi.master("SPI3");
const y_spi = spi.master("SPI2");

comptime {
    hal.createIrqVect(.{
        .SysTick = &systick_inst.irq,
        .TIM8_TRG_COM_TIM14 = &timer14.irq,
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

    nvic.enable_irq(.TIM8_TRG_COM_TIM14, true);

    // semihosting.writer.print("Hello, world!\n", .{}) catch {};
}

pub fn main() noreturn {
    init() catch {};

    // LED & laser duty cycle
    const rgb_t = struct { r: u32 = 0, g: u32 = 0, b: u32 = 0 };
    var laser: rgb_t = .{};
    var delta: u32 = 1;
    var update_laser = true;
    var update_led = true;

    // Remote state
    var change: enum { r, g, b, top } = .r;
    var use_repeat = true;
    var max_power: u32 = 0;

    // Timer state
    const init_top = timer8.getTop();
    var top = init_top;
    var tick = systick_inst.get_ms();
    var action: u32 = 0;

    while (true) {
        const now = systick_inst.get_ms();
        if (now != tick) {
            tick = now;
            update_led = action == 1;
            action = @max(action, 1) - 1;
            update_laser = max_power == 1;
            max_power = @max(max_power, 1) - 1;
        }

        if (ir_remote_inst.dequeue()) |ir_val| {
            const remote = ir_remote.remote_sky_now_tv.decode(ir_val);
            const channel = switch (change) {
                .r => &laser.r,
                .g => &laser.g,
                .b => &laser.b,
                .top => &top,
            };
            if (!remote.repeat or use_repeat) {
                action = 10;
                switch (remote.button) {
                    .ok => if (!remote.repeat) {
                        use_repeat = !use_repeat;
                    },

                    .rewind => change = .r,
                    .pause => change = .g,
                    .ff => change = .b,
                    .back => change = .top,

                    .up => delta = @min(init_top, delta *% 2),
                    .down => delta = @max(delta, 2) / 2,
                    .left => channel.* = @max(channel.*, delta) - delta,
                    .right => channel.* = @min(channel.* + delta, init_top),

                    .star => {
                        laser = .{};
                        max_power = 0;
                    },
                    .now => max_power = 120,

                    .home => semihosting.writer.print(
                        "LASER r={} g={} b={} top={} CONTROL={s} delta={}\n",
                        .{ laser.r, laser.g, laser.b, top, @tagName(change), delta },
                    ) catch {},

                    else => {
                        semihosting.writer.print(
                            "{s} rep={}\n",
                            .{ @tagName(remote.button), remote.repeat },
                        ) catch {};
                    },
                }
            }
            update_laser = true;
            update_led = true;
        }

        if (update_led) {
            update_led = false;

            var led: rgb_t = .{};
            if (action != 0) {
                led = .{
                    .r = init_top / 8,
                    .g = init_top / 8,
                    .b = init_top / 8,
                };
            } else {
                switch (change) {
                    .r => led.r = delta,
                    .g => led.g = delta,
                    .b => led.b = delta,
                    .top => led = .{ .r = delta, .g = delta, .b = 0 },
                }
            }

            timer5.channels.LED_R.setCmp(led.r);
            timer5.channels.LED_G.setCmp(led.g);
            timer5.channels.LED_B.setCmp(led.b);
        }

        if (update_laser) {
            update_laser = false;
            if (max_power != 0) {
                timer8.channels.LASER_R.setCmp(init_top);
                timer8.channels.LASER_G.setCmp(init_top);
                timer8.channels.LASER_B.setCmp(init_top);
                // timer8.setTop(init_top);
            } else {
                timer8.channels.LASER_R.setCmp(laser.r);
                timer8.channels.LASER_G.setCmp(laser.g);
                timer8.channels.LASER_B.setCmp(laser.b);
                timer8.setTop(top);
            }
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
}
