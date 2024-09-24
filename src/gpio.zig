const std = @import("std");
const hal = @import("stm32f722.zig");

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

pub const gpio_pin_cfg_t = struct {
    name: ?[:0]const u8 = null,
    mode: mode_t,
    af: u4 = 0,
    pull: pull_t = .pull_none,
    speed: speed_t = .low,
    value: u1 = 0,
};

pub const gpio_cfg_t = struct {
    PIN0: ?gpio_pin_cfg_t = null,
    PIN1: ?gpio_pin_cfg_t = null,
    PIN2: ?gpio_pin_cfg_t = null,
    PIN3: ?gpio_pin_cfg_t = null,
    PIN4: ?gpio_pin_cfg_t = null,
    PIN5: ?gpio_pin_cfg_t = null,
    PIN6: ?gpio_pin_cfg_t = null,
    PIN7: ?gpio_pin_cfg_t = null,
    PIN8: ?gpio_pin_cfg_t = null,
    PIN9: ?gpio_pin_cfg_t = null,
    PIN10: ?gpio_pin_cfg_t = null,
    PIN11: ?gpio_pin_cfg_t = null,
    PIN12: ?gpio_pin_cfg_t = null,
    PIN13: ?gpio_pin_cfg_t = null,
    PIN14: ?gpio_pin_cfg_t = null,
    PIN15: ?gpio_pin_cfg_t = null,
};

pub const cfg_t = struct {
    GPIOA: ?gpio_cfg_t = null,
    GPIOB: ?gpio_cfg_t = null,
    GPIOC: ?gpio_cfg_t = null,
    GPIOD: ?gpio_cfg_t = null,
    GPIOE: ?gpio_cfg_t = null,
    GPIOF: ?gpio_cfg_t = null,
    GPIOG: ?gpio_cfg_t = null,
    GPIOH: ?gpio_cfg_t = null,
    GPIOI: ?gpio_cfg_t = null,
};

fn initPin(port: []const u8, pin: []const u8, cfg: gpio_pin_cfg_t) ?type {
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

pub fn initGpioCfg(comptime port: []const u8, comptime cfgs: gpio_cfg_t) void {
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
        for (@typeInfo(gpio_cfg_t).@"struct".fields) |cfg_field| {
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

                if (conf.mode == .af_open_drain or conf.mode == .af_push_pull) {
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
    }

    if (!std.meta.eql(bsrr_val, .{}))
        reg.*.BSRR.write(bsrr_val);
    reg.*.AFRL.modify_masked(afrl_mask, afrl_val);
    reg.*.AFRH.modify_masked(afrh_mask, afrh_val);
    reg.*.OTYPER.modify_masked(otyper_mask, otyper_val);
    reg.*.PUPDR.modify_masked(pupdr_mask, pupdr_val);
    reg.*.MODER.modify_masked(moder_mask, moder_val);
    reg.*.OSPEEDR.modify_masked(ospeedr_mask, ospeedr_val);
}

pub fn initCfg(comptime cfgs: cfg_t) type {
    comptime var pin_fields: []const std.builtin.Type.StructField = &.{};
    comptime {
        for (@typeInfo(cfg_t).@"struct".fields) |gpio_field| {
            if (@field(cfgs, gpio_field.name)) |gpio_config| {
                for (@typeInfo(gpio_cfg_t).@"struct".fields) |cfg_field| {
                    if (@field(gpio_config, cfg_field.name)) |cfg| {
                        if (cfg.name) |name| {
                            const pin = cfg_field.name[3..];
                            const field_pin_type = initPin(gpio_field.name, pin, cfg);
                            if (field_pin_type) |field_type| {
                                pin_fields = pin_fields ++ &[_]std.builtin.Type.StructField{.{
                                    .name = name,
                                    .type = type,
                                    .is_comptime = true,
                                    .default_value = &field_type,
                                    .alignment = @alignOf(gpio_cfg_t),
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
                inline for (@typeInfo(cfg_t).@"struct".fields) |gpio_field|
                    if (@field(cfgs, gpio_field.name)) |gpio_config|
                        initGpioCfg(gpio_field.name, gpio_config);
            }
        };
    }
}

pub fn ioCompEnable(en: bool) void {
    hal.SYSCFG.CMPCR.modify(.{ .CMP_PD = @intFromBool(en) });
}
