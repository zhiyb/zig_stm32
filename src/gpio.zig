const hal = @import("stm32f103.zig");
const rcc = @import("rcc.zig");

pub const mode_t = enum {
    analog,
    floating,
    input_pull_up,
    input_pull_down,
    output_push_pull,
    output_open_drain,
    af_push_pull,
    af_open_drain,
};

pub const speed_t = enum {
    input,
    max_2mhz,
    max_10mhz,
    max_50mhz,
};

pub const gpio_t = struct {
    reg: @TypeOf(hal.REG.GPIOA),

    pub fn setPinMode(self: gpio_t, p: u5, m: mode_t, s: speed_t) void {
        const cnf = switch (m) {
            .analog => hal.GPIO_CR_CNF.ANALOG_OUTPUT_PP,
            .floating => hal.GPIO_CR_CNF.FLOATING_OUTPUT_OD,
            .input_pull_up, .input_pull_down => hal.GPIO_CR_CNF.INPUT_AF_PP,
            .output_push_pull => hal.GPIO_CR_CNF.ANALOG_OUTPUT_PP,
            .output_open_drain => hal.GPIO_CR_CNF.FLOATING_OUTPUT_OD,
            .af_push_pull => hal.GPIO_CR_CNF.INPUT_AF_PP,
            .af_open_drain => hal.GPIO_CR_CNF.AF_OD,
        };
        const mode = switch (m) {
            .analog, .floating, .input_pull_up, .input_pull_down => hal.GPIO_CR_MODE.INPUT,
            .output_push_pull, .output_open_drain, .af_push_pull, .af_open_drain => switch (s) {
                .input => hal.GPIO_CR_MODE.MAX_50MHZ,
                .max_2mhz => hal.GPIO_CR_MODE.MAX_2MHZ,
                .max_10mhz => hal.GPIO_CR_MODE.MAX_10MHZ,
                .max_50mhz => hal.GPIO_CR_MODE.MAX_50MHZ,
            },
        };

        const cr_mask = @as(u32, 0x0f) << (4 * (p % 8));
        const cr_val = ((@as(u32, @intFromEnum(cnf)) << 2) | @as(u32, @intFromEnum(mode))) << (4 * (p % 8));
        if (p < 8) {
            self.reg.CRL = @bitCast((@as(u32, @bitCast(self.reg.CRL)) & ~cr_mask) | cr_val);
        } else {
            self.reg.CRH = @bitCast((@as(u32, @bitCast(self.reg.CRH)) & ~cr_mask) | cr_val);
        }

        if (m == .input_pull_down) {
            self.reg.BSRR = @bitCast(@as(u32, 1) << (p + 16));
        } else if (m == .input_pull_up) {
            self.reg.BSRR = @bitCast(@as(u32, 1) << p);
        }
    }

    pub fn setPinValue(self: gpio_t, p: u5, v: u1) void {
        if (v == 0) {
            self.reg.BSRR = @bitCast(@as(u32, 1) << (p + 16));
        } else {
            self.reg.BSRR = @bitCast(@as(u32, 1) << p);
        }
    }

    pub fn setPinValues(self: gpio_t, values: []const struct { p: u5, v: u1 }) void {
        var bsrr: u32 = 0;
        for (values) |v| {
            if (v.v == 0) {
                bsrr |= @as(u32, 1) << (v.p + 16);
            } else {
                bsrr |= @as(u32, 1) << v.p;
            }
        }
        self.reg.BSRR = @bitCast(bsrr);
    }
};

pub const gpio_a: gpio_t = .{ .reg = hal.REG.GPIOA };
pub const gpio_b: gpio_t = .{ .reg = hal.REG.GPIOB };
pub const gpio_c: gpio_t = .{ .reg = hal.REG.GPIOC };
pub const gpio_d: gpio_t = .{ .reg = hal.REG.GPIOD };
pub const gpio_e: gpio_t = .{ .reg = hal.REG.GPIOE };
