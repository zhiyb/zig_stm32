const std = @import("std");
const hal = @import("stm32f722.zig");
const rcc = @import("rcc.zig");

pub const mode_t = enum {
    analog,
    input,
    output_push_pull,
    output_open_drain,
    af_push_pull,
    af_open_drain,
};

pub const speed_t = enum {
    low,
    medium,
    high,
    very_high,
};

pub const pull_t = enum {
    pull_none,
    pull_up,
    pull_down,
};

pub fn gpio_t(comptime port: []const u8) struct {
    port: []const u8,
    reg: @TypeOf(@field(hal, "GPIO" ++ port)),

    pub fn setPinModesComp(self: @This(), comptime confs: []const struct {
        pin: u5,
        mode: mode_t,
        af: u4 = 0,
        pull: pull_t = .pull_none,
        speed: speed_t = .low,
        value: u1 = 0,
    }) void {
        comptime var moder_mask: @TypeOf(self.reg.MODER) = .{};
        comptime var moder_val: @TypeOf(self.reg.MODER) = .{};
        comptime var otyper_mask: @TypeOf(self.reg.OTYPER) = .{};
        comptime var otyper_val: @TypeOf(self.reg.OTYPER) = .{};
        comptime var ospeedr_mask: @TypeOf(self.reg.OSPEEDR) = .{};
        comptime var ospeedr_val: @TypeOf(self.reg.OSPEEDR) = .{};
        comptime var pupdr_mask: @TypeOf(self.reg.PUPDR) = .{};
        comptime var pupdr_val: @TypeOf(self.reg.PUPDR) = .{};
        comptime var bsrr_val: @TypeOf(self.reg.BSRR) = .{};
        comptime var afrl_mask: @TypeOf(self.reg.AFRL) = .{};
        comptime var afrl_val: @TypeOf(self.reg.AFRL) = .{};
        comptime var afrh_mask: @TypeOf(self.reg.AFRH) = .{};
        comptime var afrh_val: @TypeOf(self.reg.AFRH) = .{};

        comptime {
            for (confs) |conf| {
                const moder = switch (conf.mode) {
                    .analog => hal.GPIO_MODER.ANALOG,
                    .input => hal.GPIO_MODER.INPUT,
                    .output_push_pull, .output_open_drain => hal.GPIO_MODER.OUTPUT,
                    .af_push_pull, .af_open_drain => hal.GPIO_MODER.ALTERNATE_FUNCTION,
                };
                const ospeedr = switch (conf.speed) {
                    .low => hal.GPIO_OSPEEDR.LOW,
                    .medium => hal.GPIO_OSPEEDR.MEDIUM,
                    .high => hal.GPIO_OSPEEDR.HIGH,
                    .very_high => hal.GPIO_OSPEEDR.VERY_HIGH,
                };
                const pupdr = switch (conf.mode) {
                    .analog => hal.GPIO_PUPDR.PULL_NONE,
                    else => switch (conf.pull) {
                        .pull_none => hal.GPIO_PUPDR.PULL_NONE,
                        .pull_up => hal.GPIO_PUPDR.PULL_UP,
                        .pull_down => hal.GPIO_PUPDR.PULL_DOWN,
                    },
                };

                const pin = std.fmt.comptimePrint("{}", .{conf.pin});

                @field(moder_mask, "MODER" ++ pin) = 0b11;
                @field(moder_val, "MODER" ++ pin) = @intFromEnum(moder);

                @field(pupdr_mask, "PUPDR" ++ pin) = 0b11;
                @field(pupdr_val, "PUPDR" ++ pin) = @intFromEnum(pupdr);

                if (conf.mode == .output_open_drain or conf.mode == .output_push_pull or
                    conf.mode == .af_open_drain or conf.mode == .af_push_pull)
                {
                    @field(otyper_mask, "OT" ++ pin) = 1;
                    @field(otyper_val, "OT" ++ pin) =
                        if (conf.mode == .output_open_drain) 1 else 0;

                    @field(ospeedr_mask, "OSPEEDR" ++ pin) = 0b11;
                    @field(ospeedr_val, "OSPEEDR" ++ pin) = @intFromEnum(ospeedr);
                }

                if (conf.mode == .output_open_drain or conf.mode == .output_push_pull) {
                    if (conf.value == 0) {
                        @field(bsrr_val, "BR" ++ pin) = 1;
                    } else {
                        @field(bsrr_val, "BS" ++ pin) = 1;
                    }
                }

                if (conf.mode == .af_open_drain or conf.mode == .af_push_pull) {
                    if (conf.pin >= 8) {
                        @field(afrh_mask, "AFRH" ++ pin) = 0b1111;
                        @field(afrh_val, "AFRH" ++ pin) = conf.af;
                    } else {
                        @field(afrl_mask, "AFRL" ++ pin) = 0b1111;
                        @field(afrl_val, "AFRL" ++ pin) = conf.af;
                    }
                }
            }
        }

        if (!std.meta.eql(bsrr_val, .{}))
            self.reg.BSRR = bsrr_val;
        self.reg.AFRL.set(afrl_mask, afrl_val);
        self.reg.AFRH.set(afrh_mask, afrh_val);
        self.reg.OTYPER.set(otyper_mask, otyper_val);
        self.reg.PUPDR.set(pupdr_mask, pupdr_val);
        self.reg.MODER.set(moder_mask, moder_val);
        self.reg.OSPEEDR.set(ospeedr_mask, ospeedr_val);
    }

    // pub fn setPinValue(self: gpio_t, p: u5, v: u1) void {
    //     if (v == 0) {
    //         self.reg.BSRR = @bitCast(@as(u32, 1) << (p + 16));
    //     } else {
    //         self.reg.BSRR = @bitCast(@as(u32, 1) << p);
    //     }
    // }

    // pub fn setPinValues(self: gpio_t, values: []const struct { p: u5, v: u1 }) void {
    //     var bsrr: u32 = 0;
    //     for (values) |v| {
    //         if (v.v == 0) {
    //             bsrr |= @as(u32, 1) << (v.p + 16);
    //         } else {
    //             bsrr |= @as(u32, 1) << v.p;
    //         }
    //     }
    //     self.reg.BSRR = @bitCast(bsrr);
    // }

    // pub fn setPinValuesComp(self: gpio_t, comptime values: []const struct { p: u5, v: u1 }) void {
    //     comptime var bsrr: u32 = 0;
    //     comptime {
    //         for (values) |v| {
    //             if (v.v == 0) {
    //                 bsrr |= @as(u32, 1) << (v.p + 16);
    //             } else {
    //                 bsrr |= @as(u32, 1) << v.p;
    //             }
    //         }
    //     }
    //     self.reg.BSRR = @bitCast(bsrr);
    // }
} {
    return .{
        .port = port,
        .reg = @field(hal, "GPIO" ++ port),
    };
}

pub const gpio_a = gpio_t("A");
pub const gpio_b = gpio_t("B");
pub const gpio_c = gpio_t("C");
pub const gpio_d = gpio_t("D");
pub const gpio_e = gpio_t("E");
pub const gpio_f = gpio_t("F");
pub const gpio_g = gpio_t("G");
pub const gpio_h = gpio_t("H");
pub const gpio_i = gpio_t("I");
