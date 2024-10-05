const std = @import("std");
const hal = @import("stm32f722.zig");

pub const Mode = enum {
    analog,
    input,
    output_push_pull,
    output_open_drain,
    af_push_pull,
    af_open_drain,
};

pub const Speed = enum {
    low,
    medium,
    high,
    very_high,
};

pub const Pull = enum {
    pull_none,
    pull_up,
    pull_down,
};

pub const GpioPinCfg = struct {
    name: ?[:0]const u8 = null,
    mode: Mode,
    af: u4 = 0,
    pull: Pull = .pull_none,
    speed: Speed = .low,
    value: u1 = 0,
};

pub const GpioCfg = struct {
    PIN0: ?GpioPinCfg = null,
    PIN1: ?GpioPinCfg = null,
    PIN2: ?GpioPinCfg = null,
    PIN3: ?GpioPinCfg = null,
    PIN4: ?GpioPinCfg = null,
    PIN5: ?GpioPinCfg = null,
    PIN6: ?GpioPinCfg = null,
    PIN7: ?GpioPinCfg = null,
    PIN8: ?GpioPinCfg = null,
    PIN9: ?GpioPinCfg = null,
    PIN10: ?GpioPinCfg = null,
    PIN11: ?GpioPinCfg = null,
    PIN12: ?GpioPinCfg = null,
    PIN13: ?GpioPinCfg = null,
    PIN14: ?GpioPinCfg = null,
    PIN15: ?GpioPinCfg = null,
};

pub const Cfg = struct {
    GPIOA: ?GpioCfg = null,
    GPIOB: ?GpioCfg = null,
    GPIOC: ?GpioCfg = null,
    GPIOD: ?GpioCfg = null,
    GPIOE: ?GpioCfg = null,
    GPIOF: ?GpioCfg = null,
    GPIOG: ?GpioCfg = null,
    GPIOH: ?GpioCfg = null,
    GPIOI: ?GpioCfg = null,
};

fn InitPin(port: []const u8, pin: []const u8, cfg: GpioPinCfg) ?type {
    if (cfg.name == null)
        return null;
    return switch (cfg.mode) {
        .input => struct {
            pub fn read() u1 {
                const val = @field(hal, port).IDR.read();
                return @field(val, "IDR" ++ pin);
            }
        },
        .output_push_pull, .output_open_drain => struct {
            pub fn write(val: u1) void {
                const bsrr = &@field(hal, port).BSRR;
                var bsrr_val = @TypeOf(bsrr.*).underlying_type{};
                if (val != 0) {
                    @field(bsrr_val, "BS" ++ pin) = 1;
                } else {
                    @field(bsrr_val, "BR" ++ pin) = 1;
                }
                bsrr.write(bsrr_val);
            }
        },
        .analog, .af_open_drain, .af_push_pull => null,
    };
}

pub fn initGpioCfg(comptime port: []const u8, comptime cfgs: GpioCfg) void {
    const reg = &@field(hal, port);
    comptime var moder_mask: @TypeOf(reg.*.MODER).underlying_type = .{};
    comptime var moder_val: @TypeOf(reg.*.MODER).underlying_type = .{};
    comptime var otyper_mask: @TypeOf(reg.*.OTYPER).underlying_type = .{};
    comptime var otyper_val: @TypeOf(reg.*.OTYPER).underlying_type = .{};
    comptime var ospeedr_mask: @TypeOf(reg.*.OSPEEDR).underlying_type = .{};
    comptime var ospeedr_val: @TypeOf(reg.*.OSPEEDR).underlying_type = .{};
    comptime var pupdr_mask: @TypeOf(reg.*.PUPDR).underlying_type = .{};
    comptime var pupdr_val: @TypeOf(reg.*.PUPDR).underlying_type = .{};
    comptime var bsrr_val: @TypeOf(reg.*.BSRR).underlying_type = .{};
    comptime var afrl_mask: @TypeOf(reg.*.AFRL).underlying_type = .{};
    comptime var afrl_val: @TypeOf(reg.*.AFRL).underlying_type = .{};
    comptime var afrh_mask: @TypeOf(reg.*.AFRH).underlying_type = .{};
    comptime var afrh_val: @TypeOf(reg.*.AFRH).underlying_type = .{};

    comptime {
        for (@typeInfo(GpioCfg).@"struct".fields) |cfg_field| {
            if (@field(cfgs, cfg_field.name)) |conf| {
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

                const pin = cfg_field.name[3..];
                const pin_int = std.fmt.parseUnsigned(u4, pin, 0) catch {};

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

                if (pin_int >= 8) {
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
        reg.*.BSRR.write(bsrr_val);
    reg.*.AFRL.modifyMasked(afrl_mask, afrl_val);
    reg.*.AFRH.modifyMasked(afrh_mask, afrh_val);
    reg.*.OTYPER.modifyMasked(otyper_mask, otyper_val);
    reg.*.PUPDR.modifyMasked(pupdr_mask, pupdr_val);
    reg.*.MODER.modifyMasked(moder_mask, moder_val);
    reg.*.OSPEEDR.modifyMasked(ospeedr_mask, ospeedr_val);
}

pub fn InitCfg(comptime cfgs: Cfg) type {
    comptime {
        var pin_fields: []const std.builtin.Type.StructField = &.{};
        for (@typeInfo(Cfg).@"struct".fields) |gpio_field| {
            if (@field(cfgs, gpio_field.name)) |gpio_config| {
                for (@typeInfo(GpioCfg).@"struct".fields) |cfg_field| {
                    if (@field(gpio_config, cfg_field.name)) |cfg| {
                        if (cfg.name) |name| {
                            const pin = cfg_field.name[3..];
                            const field_pin_type = InitPin(gpio_field.name, pin, cfg);
                            if (field_pin_type) |field_type| {
                                pin_fields = pin_fields ++ &[_]std.builtin.Type.StructField{.{
                                    .name = name,
                                    .type = type,
                                    .is_comptime = true,
                                    .default_value = &field_type,
                                    .alignment = @alignOf(GpioCfg),
                                }};
                            }
                        }
                    }
                }
            }
        }

        const pin_type = @Type(.{ .@"struct" = .{
            .layout = .auto,
            .is_tuple = false,
            .fields = pin_fields,
            .decls = &.{},
        } });

        return struct {
            pub const pins = pin_type{};

            pub fn apply() void {
                inline for (@typeInfo(Cfg).@"struct".fields) |gpio_field|
                    if (@field(cfgs, gpio_field.name)) |gpio_config|
                        initGpioCfg(gpio_field.name, gpio_config);
            }
        };
    }
}

pub fn ioCompEnable(en: bool) void {
    hal.SYSCFG.CMPCR.modify(.{ .CMP_PD = @intFromBool(en) });
}
