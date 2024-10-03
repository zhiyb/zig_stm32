const std = @import("std");
const hal = @import("stm32f722.zig");
const rcc = @import("rcc.zig");

pub const timer_bus_map_t = struct {
    const TIM1 = rcc.bus_t.APB2_TIMER;
    const TIM2 = rcc.bus_t.APB1_TIMER;
    const TIM3 = rcc.bus_t.APB1_TIMER;
    const TIM4 = rcc.bus_t.APB1_TIMER;
    const TIM5 = rcc.bus_t.APB1_TIMER;
    const TIM6 = rcc.bus_t.APB1_TIMER;
    const TIM7 = rcc.bus_t.APB1_TIMER;
    const TIM8 = rcc.bus_t.APB2_TIMER;
    const TIM9 = rcc.bus_t.APB2_TIMER;
    const TIM10 = rcc.bus_t.APB2_TIMER;
    const TIM11 = rcc.bus_t.APB2_TIMER;
    const TIM12 = rcc.bus_t.APB1_TIMER;
    const TIM13 = rcc.bus_t.APB1_TIMER;
    const TIM14 = rcc.bus_t.APB1_TIMER;
};

pub const timer_channel_mode_t = enum {
    disabled,
    input_capture,
    pwm,
};

pub const timer_channel_input_mode_t = enum {
    disabled,
    rising,
    falling,
    both_edges,
};

pub const timer_channel_output_mode_t = enum {
    disabled,
    enabled,
    inverted,
};

pub const timer_channel_t = struct {
    num: comptime_int,
    name: ?[:0]const u8 = null,
    mode: union(enum) {
        output: struct {
            oc: timer_channel_output_mode_t,
            ocn: timer_channel_output_mode_t,
            init_cmp: comptime_int = 0,
            mode: union(enum) {
                pwm: struct {},
            },
        },
        input: struct {
            ic: timer_channel_input_mode_t,
            irq_cc: ?*const fn (anytype, u32, bool) void = null,
            mode: union(enum) {
                capture: struct {},
            },
        },
    },
};

pub const timer_cfg_t = struct {
    timer: comptime_int,
    irq_upd: ?*const fn (timer_cfg_t) void = null,
    freq_hz: comptime_int,
    init_top: comptime_int = 0,
    ch: []const timer_channel_t,
};

fn channelType(
    comptime timer: [:0]const u8,
    comptime ch_cfg: timer_channel_t,
    comptime timer_cnt_freq_hz: comptime_int,
) type {
    const reg = @field(hal, timer);
    const ch = ch_cfg.num;
    const chs = std.fmt.comptimePrint("{}", .{ch});

    switch (ch_cfg.mode) {
        .input => {
            const in_cfg = ch_cfg.mode.input;
            switch (in_cfg.mode) {
                .capture => return struct {
                    pub const cnt_freq_hz = timer_cnt_freq_hz;

                    pub fn getTop() u32 {
                        return reg.ARR.raw;
                    }
                },
            }
        },
        .output => {
            const out_cfg = ch_cfg.mode.output;
            switch (out_cfg.mode) {
                .pwm => return struct {
                    pub fn getTop() u32 {
                        return reg.ARR.raw;
                    }

                    pub fn getCmp() u32 {
                        return @field(reg, "CCR" ++ chs).raw;
                    }

                    pub fn setCmp(v: u32) void {
                        @field(reg, "CCR" ++ chs).write_raw(v);
                    }
                },
            }
        },
    }
}

pub fn config(comptime rcc_inst: anytype, comptime cfg: timer_cfg_t) type {
    const timer = std.fmt.comptimePrint("TIM{}", .{cfg.timer});

    const reg = @field(hal, timer);
    const freq_in = rcc_inst.clockHz(@field(timer_bus_map_t, timer));
    const psc_ratio = @max(1, (freq_in + cfg.freq_hz - 1) / cfg.freq_hz);
    const timer_cnt_freq_hz = freq_in / psc_ratio;

    // Create struct for channels
    comptime var channels_type: type = undefined;
    comptime {
        var ch_fields: []const std.builtin.Type.StructField = &.{};
        for (cfg.ch) |ch_cfg| {
            if (ch_cfg.name) |name| {
                ch_fields = ch_fields ++ &[_]std.builtin.Type.StructField{.{
                    .name = name,
                    .type = type,
                    .is_comptime = true,
                    .default_value = &channelType(
                        timer,
                        ch_cfg,
                        timer_cnt_freq_hz,
                    ),
                    .alignment = @alignOf(timer_channel_t),
                }};
            }
        }
        channels_type = @Type(.{ .@"struct" = .{
            .layout = .auto,
            .is_tuple = false,
            .fields = ch_fields,
            .decls = &.{},
        } });
    }

    return struct {
        pub const cnt_freq_hz = timer_cnt_freq_hz;
        pub const channels = channels_type{};

        pub fn getTop() u32 {
            return reg.ARR.raw;
        }

        pub fn setTop(v: u32) void {
            return reg.ARR.write_raw(v);
        }

        pub fn irq() callconv(.C) void {
            // Interrupt flags
            const sr = reg.SR.read();

            // Default all interrupt flags to 1 (not clear)
            comptime var SR_clr: @TypeOf(reg.SR).underlying_type = .{};
            inline for (@typeInfo(@TypeOf(SR_clr)).@"struct".fields) |field|
                @field(SR_clr, field.name) = 1;

            // Clear SR channel flags first
            var cc_cnt: [8]u32 = undefined;
            inline for (cfg.ch) |ch_cfg| {
                const chs = std.fmt.comptimePrint("{}", .{ch_cfg.num});
                switch (ch_cfg.mode) {
                    .input => if (ch_cfg.mode.input.irq_cc == null) continue,
                    .output => continue,
                }
                cc_cnt[ch_cfg.num] = @field(reg.*, "CCR" ++ chs).read_raw();
                @field(SR_clr, "CC" ++ chs ++ "IF") = 0;
                @field(SR_clr, "CC" ++ chs ++ "OF") = 0;
            }
            // And common interrupt flags
            if (cfg.irq_upd != null)
                SR_clr.UIF = 0;
            reg.SR.write(SR_clr);

            // Loop over configured channel IRQs
            inline for (cfg.ch) |ch_cfg| {
                const chs = std.fmt.comptimePrint("{}", .{ch_cfg.num});
                const f_ccif = "CC" ++ chs ++ "IF";
                const f_ccof = "CC" ++ chs ++ "OF";
                const cnt = cc_cnt[ch_cfg.num];
                switch (ch_cfg.mode) {
                    .input => {
                        if (ch_cfg.mode.input.irq_cc) |irq_func|
                            if (ch_cfg.name) |name|
                                if (@field(sr, f_ccif) != 0)
                                    irq_func(
                                        @field(channels, name),
                                        cnt,
                                        @field(sr, f_ccof) != 0,
                                    );
                    },
                    .output => {},
                }
            }
            // And common IRQs
            if (cfg.irq_upd) |irq_func|
                if (sr.UIF != 0)
                    irq_func(cfg);
        }

        pub fn init() void {
            reg.CR1.write(.{ .CEN = 0 });
            reg.DIER.write(.{});
            reg.SR.write(.{});

            reg.PSC.write(.{ .PSC = psc_ratio - 1 });
            reg.ARR.write_raw(cfg.init_top);
            reg.CNT.write_raw(0);

            inline for (@typeInfo(@TypeOf(reg.*)).@"struct".fields) |reg_field| {
                if (comptime !std.mem.startsWith(u8, reg_field.name, "CCMR"))
                    continue;
                // TODO Support for timer channel 5 and 6
                if (comptime std.mem.endsWith(u8, reg_field.name, "_Output"))
                    continue;

                // Input mode channels
                comptime var CCMR_in: (@TypeOf(@field(reg.*, reg_field.name).Input).underlying_type) = .{};
                comptime var CCMR_in_mask: (@TypeOf(@field(reg, reg_field.name).Input).underlying_type) = .{};
                comptime {
                    for (@typeInfo(@TypeOf(CCMR_in)).@"struct".fields) |field| {
                        if (std.mem.startsWith(u8, field.name, "_RESERVED"))
                            continue;

                        var ch = 0;
                        for (field.name) |c| {
                            if (std.ascii.isDigit(c)) {
                                ch = c - '0';
                                break;
                            }
                        }
                        if (ch == 0)
                            @compileError("Unkown field: " ++ reg_field.name ++ "." ++ field.name);
                        const chs = std.fmt.comptimePrint("{}", .{ch});

                        for (cfg.ch) |ch_cfg| {
                            if (ch_cfg.num != ch)
                                continue;
                            const f_ccs = "CC" ++ chs ++ "S";
                            const f_ic_psc = "IC" ++ chs ++ "PSC";
                            const f_ic_f = "IC" ++ chs ++ "F";
                            switch (ch_cfg.mode) {
                                .input => {
                                    if (std.mem.eql(u8, field.name, f_ccs)) {
                                        @field(CCMR_in, f_ccs) = @intFromEnum(hal.TIM_CCMR_CCS.INPUT_SAME);
                                        @field(CCMR_in_mask, f_ccs) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_ic_psc)) {
                                        @field(CCMR_in, f_ic_psc) = @intFromEnum(hal.TIM_CCMR_IC_PSC.DIV1);
                                        @field(CCMR_in_mask, f_ic_psc) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_ic_f)) {
                                        @field(CCMR_in, f_ic_f) = @intFromEnum(hal.TIM_CCMR_IC_F.DTS_DIV1_N1);
                                        @field(CCMR_in_mask, f_ic_f) = 1;
                                    } else {
                                        @compileLog("TODO", ch_cfg, field.name);
                                    }
                                },
                                else => {},
                            }
                        }
                    }
                }
                if (comptime !std.meta.eql(CCMR_in_mask, .{}))
                    @field(reg.*, reg_field.name).Input.modify_masked(CCMR_in_mask, CCMR_in);

                // Output mode channels
                comptime var CCMR_out: (@TypeOf(@field(reg, reg_field.name).Output).underlying_type) = .{};
                comptime var CCMR_out_mask: (@TypeOf(@field(reg, reg_field.name).Output).underlying_type) = .{};
                comptime {
                    for (@typeInfo(@TypeOf(CCMR_out)).@"struct".fields) |field| {
                        if (std.mem.startsWith(u8, field.name, "_RESERVED"))
                            continue;

                        var ch = 0;
                        for (field.name) |c| {
                            if (std.ascii.isDigit(c)) {
                                ch = c - '0';
                                break;
                            }
                        }
                        if (ch == 0)
                            @compileError("Unkown field: " ++ reg_field.name ++ "." ++ field.name);
                        const chs = std.fmt.comptimePrint("{}", .{ch});

                        for (cfg.ch) |ch_cfg| {
                            if (ch_cfg.num != ch)
                                continue;
                            const f_ccs = "CC" ++ chs ++ "S";
                            const f_oc_ce = "OC" ++ chs ++ "CE";
                            const f_oc_fe = "OC" ++ chs ++ "FE";
                            const f_oc_pe = "OC" ++ chs ++ "PE";
                            const f_oc_m = "OC" ++ chs ++ "M";
                            const f_oc_m3 = "OC" ++ chs ++ "M_3";
                            switch (ch_cfg.mode) {
                                .output => {
                                    const oc_m = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1);
                                    if (std.mem.eql(u8, field.name, f_ccs)) {
                                        @field(CCMR_out, f_ccs) = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT);
                                        @field(CCMR_out_mask, f_ccs) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_oc_ce)) {
                                        @field(CCMR_out, f_oc_ce) = 0;
                                        @field(CCMR_out_mask, f_oc_ce) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_oc_fe)) {
                                        @field(CCMR_out, f_oc_fe) = 0;
                                        @field(CCMR_out_mask, f_oc_fe) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_oc_pe)) {
                                        @field(CCMR_out, f_oc_pe) = 0;
                                        @field(CCMR_out_mask, f_oc_pe) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_oc_m)) {
                                        @field(CCMR_out, f_oc_m) = oc_m & 7;
                                        @field(CCMR_out_mask, f_oc_m) = 1;
                                    } else if (std.mem.eql(u8, field.name, f_oc_m3)) {
                                        @field(CCMR_out, f_oc_m3) = oc_m >> 3;
                                        @field(CCMR_out_mask, f_oc_m3) = 1;
                                    } else {
                                        @compileLog("TODO", ch_cfg, field.name);
                                    }
                                },
                                else => {},
                            }
                        }
                    }
                }
                if (comptime !std.meta.eql(CCMR_out_mask, .{}))
                    @field(reg.*, reg_field.name).Output.modify_masked(CCMR_out_mask, CCMR_out);
            }

            // Common timer registers
            comptime var CCER: (@TypeOf(reg.CCER).underlying_type) = .{};
            comptime var DIER: (@TypeOf(reg.DIER).underlying_type) = .{};

            inline for (cfg.ch) |ch_cfg| {
                // Channel specific fields
                const ch = ch_cfg.num;
                const chs = std.fmt.comptimePrint("{}", .{ch});
                const f_cce = "CC" ++ chs ++ "E";
                const f_ccp = "CC" ++ chs ++ "P";
                const f_ccne = "CC" ++ chs ++ "NE";
                const f_ccnp = "CC" ++ chs ++ "NP";
                switch (ch_cfg.mode) {
                    .input => {
                        const in_cfg = ch_cfg.mode.input;
                        @field(CCER, f_cce) = if (in_cfg.ic != .disabled) 1 else 0;
                        switch (in_cfg.ic) {
                            .disabled => {},
                            .rising => {
                                @field(CCER, f_ccp) = 0;
                                @field(CCER, f_ccnp) = 0;
                            },
                            .falling => {
                                @field(CCER, f_ccp) = 0;
                                @field(CCER, f_ccnp) = 1;
                            },
                            .both_edges => {
                                @field(CCER, f_ccp) = 1;
                                @field(CCER, f_ccnp) = 1;
                            },
                        }
                        @field(DIER, "CC" ++ chs ++ "IE") = if (in_cfg.irq_cc != null) 1 else 0;
                    },
                    .output => {
                        const out_cfg = ch_cfg.mode.output;
                        @field(CCER, f_cce) = if (out_cfg.oc != .disabled) 1 else 0;
                        @field(CCER, f_ccp) = if (out_cfg.oc == .inverted) 1 else 0;
                        if (@hasField(@TypeOf(CCER), f_ccne)) {
                            @field(CCER, f_ccne) = if (out_cfg.ocn != .disabled) 1 else 0;
                            @field(CCER, f_ccnp) = if (out_cfg.ocn == .inverted) 1 else 0;
                        } else if (out_cfg.ocn != .disabled) {
                            @compileError("Timer does not support OCN output");
                        }
                        @field(reg, "CCR" ++ chs).write_raw(out_cfg.init_cmp);
                    },
                }
            }

            // Common fields
            if (cfg.irq_upd != null)
                DIER.UIE = 1; // Update interrupt

            reg.CCER.write(CCER);
            reg.DIER.write(DIER);

            // Enable timer
            if (@hasField(@TypeOf(reg.*), "BDTR"))
                reg.BDTR.write(.{ .MOE = 1 });
            reg.CR1.write(.{ .CEN = 1 });
        }
    };
}
