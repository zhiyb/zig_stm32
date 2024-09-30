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
            mode: union(enum) {},
        },
    },
};

pub const timer_cfg_t = struct {
    timer: comptime_int,
    interrupt: bool = false,
    freq_hz: comptime_int,
    init_top: comptime_int = 0,
    ch: []const timer_channel_t,
};

fn channelType(comptime timer: [:0]const u8, comptime ch_cfg: timer_channel_t) type {
    const reg = @field(hal, timer);
    const ch = ch_cfg.num;
    const chs = std.fmt.comptimePrint("{}", .{ch});

    switch (ch_cfg.mode) {
        .input => {
            @compileError("TODO");
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
                    .default_value = &channelType(timer, ch_cfg),
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
        pub const channels = channels_type{};

        const reg = @field(hal, timer);
        const freq_in = rcc_inst.clockHz(@field(timer_bus_map_t, timer));

        pub fn getTop() u32 {
            return reg.ARR.raw;
        }

        pub fn init() void {
            reg.CR1.write(.{ .CEN = 0 });
            reg.DIER.write(.{});
            reg.SR.write(.{});

            const psc_ratio = @max(1, (freq_in + cfg.freq_hz - 1) / cfg.freq_hz);
            reg.PSC.write(.{ .PSC = psc_ratio - 1 });
            reg.ARR.write_raw(cfg.init_top);
            reg.CNT.write_raw(0);

            inline for (@typeInfo(@TypeOf(reg.*)).@"struct".fields) |reg_field| {
                // @compileLog(reg_field.name);
                if (comptime !std.mem.startsWith(u8, reg_field.name, "CCMR"))
                    continue;
                // TODO
                if (comptime std.mem.endsWith(u8, reg_field.name, "_Output"))
                    continue;

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

            comptime var CCER: (@TypeOf(reg.CCER).underlying_type) = .{};
            comptime var CCER_modified = false;
            inline for (cfg.ch) |ch_cfg| {
                const ch = ch_cfg.num;
                const chs = std.fmt.comptimePrint("{}", .{ch});
                switch (ch_cfg.mode) {
                    .input => {
                        @compileLog("TODO");
                    },
                    .output => {
                        const out_cfg = ch_cfg.mode.output;
                        const f_cce = "CC" ++ chs ++ "E";
                        @field(CCER, f_cce) = if (out_cfg.oc != .disabled) 1 else 0;
                        const f_ccp = "CC" ++ chs ++ "P";
                        @field(CCER, f_ccp) = if (out_cfg.oc == .inverted) 1 else 0;
                        const f_ccne = "CC" ++ chs ++ "NE";
                        if (@hasField(@TypeOf(CCER), f_ccne)) {
                            @field(CCER, f_ccne) = if (out_cfg.ocn != .disabled) 1 else 0;
                            const f_ccnp = "CC" ++ chs ++ "NE";
                            @field(CCER, f_ccnp) = if (out_cfg.ocn == .inverted) 1 else 0;
                        } else if (out_cfg.ocn != .disabled) {
                            @compileError("Timer does not support OCN output");
                        }
                        CCER_modified = true;

                        @field(reg, "CCR" ++ chs).write_raw(out_cfg.init_cmp);
                    },
                }
            }
            if (CCER_modified)
                reg.CCER.write(CCER);

            if (@hasField(@TypeOf(reg.*), "BDTR"))
                reg.BDTR.write(.{ .MOE = 1 });
            // Enable timer
            reg.CR1.write(.{ .CEN = 1 });
        }
    };
}

// const ir_remote_debug = false;
// const ir_remote_log = 8;

// const common_t = struct {
//     const mode_t = enum { Uninitialised, OutputPWM, InputIrRemote };

//     const data_t = union {
//         const ir_remote_t = struct {
//             // 10us tick resolution
//             const tick_freq = 100_000;

//             const source_t = struct {
//                 debug: if (ir_remote_debug) struct {
//                     const debug_t = struct {
//                         burst: i32 = 0,
//                         space: i32 = 0,
//                         data: u32 = 0,
//                         bit: i8 = 0,
//                     };

//                     log: [64]debug_t = [_]debug_t{.{}} ** 64,
//                     idx: u6 = 0,
//                 } else struct {} = .{},

//                 _log: [ir_remote_log]u32 = [_]u32{0} ** ir_remote_log,
//                 _widx: u8 = 0,
//                 _ridx: u8 = 0,

//                 last_tick: u16 = 0,
//                 burst_ticks: u16 = 0,
//                 data: u32 = 0,
//                 bit: i8 = 0,

//                 /// NEC decoder
//                 fn checkBit(self: *source_t, space_ticks: u16) void {
//                     const start_burst = 9_000 * tick_freq / 1000_000; // 9ms
//                     const start_space = 4_500 * tick_freq / 1000_000; // 4.5ms
//                     const b0_burst = 563 * tick_freq / 1000_000; // 562.5us
//                     const b0_space = b0_burst;
//                     const b1_burst = b0_burst;
//                     const b1_space = 1_688 * tick_freq / 1000_000; // 1.6875ms
//                     const tolerance = 100 / 30; // 30% tolerance

//                     const burst: i32 = self.burst_ticks;
//                     const space: i32 = space_ticks;

//                     if (@abs(burst - start_burst) < start_burst / tolerance and
//                         @abs(space - start_space) < start_space / tolerance)
//                     {
//                         self.bit = 0;
//                     } else if (self.bit >= 0) {
//                         if (@abs(burst - b0_burst) < b0_burst / tolerance and
//                             @abs(space - b0_space) < b0_space / tolerance)
//                         {
//                             self.data = self.data << 1;
//                             self.bit += 1;
//                         } else if (@abs(burst - b1_burst) < b1_burst / tolerance and
//                             @abs(space - b1_space) < b1_space / tolerance)
//                         {
//                             self.data = (self.data << 1) | 1;
//                             self.bit += 1;
//                         } else {
//                             self.bit = -1;
//                         }
//                     }

//                     if (ir_remote_debug) {
//                         const dbg: @TypeOf(self.debug).debug_t = .{
//                             .burst = burst,
//                             .space = space,
//                             .data = self.data,
//                             .bit = self.bit,
//                         };
//                         self.debug.log[self.debug.idx] = dbg;
//                         self.debug.idx +%= 1;
//                     }

//                     if (self.bit == 32) {
//                         // 32-bit data complete
//                         const widx = @as(*volatile @TypeOf(self._widx), &self._widx);
//                         const ridx = @as(*volatile @TypeOf(self._ridx), &self._ridx);
//                         const log = @as(*volatile @TypeOf(self._log), &self._log);
//                         const w = widx.*;
//                         if (w +% 1 != ridx.*) {
//                             log[w] = self.data;
//                             widx.* = (w +% 1) % ir_remote_log;
//                         }
//                         self.bit = -1;
//                     }
//                 }
//             };

//             source: [2]source_t = [_]source_t{.{}} ** 2,
//         };

//         unused: u0,
//         ir_remote: ir_remote_t,
//     };

//     mode: mode_t = .Uninitialised,
//     data: data_t = .{ .unused = 0 },

//     fn initIrRemote(self: anytype) void {
//         const reg = self.reg;
//         self.common.mode = .InputIrRemote;
//         self.common.data = .{ .ir_remote = .{} };

//         // Setup PWM input capture timer using CC inputs 2 and 4
//         reg.CR1 = .{
//             .CMS = @intFromEnum(hal.TIM_CR1_CMS.EDGE),
//             .DIR = @intFromEnum(hal.TIM_CR1_DIR.UP),
//         };
//         reg.CR2 = .{};
//         reg.SMCR = .{};
//         reg.DIER = .{
//             .CC1IE = 1,
//             .CC2IE = 1,
//             .CC3IE = 1,
//             .CC4IE = 1,
//         };
//         reg.SR = .{}; // Clear flags
//         reg.CCMR1.Input = .{
//             .CC1S = @intFromEnum(hal.TIM_CCMR_CCS.INPUT_COMP),
//             .IC1F = @intFromEnum(hal.TIM_CCMR_ICF.INT_N8),
//             .IC1PSC = @intFromEnum(hal.TIM_CCMR_ICPSC.DIV1),
//             .CC2S = @intFromEnum(hal.TIM_CCMR_CCS.INPUT_SAME),
//             .IC2F = @intFromEnum(hal.TIM_CCMR_ICF.INT_N8),
//             .IC2PSC = @intFromEnum(hal.TIM_CCMR_ICPSC.DIV1),
//         };
//         reg.CCMR2.Input = .{
//             .CC3S = @intFromEnum(hal.TIM_CCMR_CCS.INPUT_COMP),
//             .IC3F = @intFromEnum(hal.TIM_CCMR_ICF.INT_N8),
//             .IC3PSC = @intFromEnum(hal.TIM_CCMR_ICPSC.DIV1),
//             .CC4S = @intFromEnum(hal.TIM_CCMR_CCS.INPUT_SAME),
//             .IC4F = @intFromEnum(hal.TIM_CCMR_ICF.INT_N8),
//             .IC4PSC = @intFromEnum(hal.TIM_CCMR_ICPSC.DIV1),
//         };
//         reg.CCER = .{
//             .CC1E = 1,
//             .CC1P = 1,
//             .CC2E = 1,
//             .CC2P = 0,
//             .CC3E = 1,
//             .CC3P = 1,
//             .CC4E = 1,
//             .CC4P = 0,
//         };

//         // TIM @ 72 MHz
//         const freq_in = 72_000_000;
//         const ratio = freq_in / data_t.ir_remote_t.tick_freq;
//         reg.PSC.PSC = ratio - 1;
//         reg.ARR.ARR = 65535;

//         // Enable timer
//         reg.CR1.CEN = 1;
//     }

//     fn popIrRemote(self: anytype, src: u8) u32 {
//         const ir_remote: *data_t.ir_remote_t = &self.common.data.ir_remote;
//         const source = &ir_remote.source[src];
//         const widx = @as(*volatile @TypeOf(source._widx), &source._widx);
//         const ridx = @as(*volatile @TypeOf(source._ridx), &source._ridx);
//         const log = @as(*volatile @TypeOf(source._log), &source._log);
//         const r = ridx.*;
//         if (r == widx.*)
//             return 0;
//         const data = log[r];
//         ridx.* = (r +% 1) % ir_remote_log;
//         return data;
//     }

//     fn irq(self: anytype) void {
//         const reg = self.reg;
//         switch (self.common.mode) {
//             .InputIrRemote => {
//                 const sr = reg.SR;
//                 const ir_remote = &self.common.data.ir_remote;
//                 for (0..2) |i| {
//                     const source = &ir_remote.source[i];
//                     if ((if (i == 0) sr.CC2IF else sr.CC4IF) != 0) {
//                         const tick = (if (i == 0) reg.CCR2.CCR2 else reg.CCR4.CCR4);
//                         source.burst_ticks = tick -% source.last_tick;
//                         source.last_tick = tick;
//                     }
//                     if ((if (i == 0) sr.CC1IF else sr.CC3IF) != 0) {
//                         const tick = (if (i == 0) reg.CCR1.CCR1 else reg.CCR3.CCR3);
//                         const ticks = tick -% source.last_tick;
//                         source.last_tick = tick;
//                         ir_remote.source[i].checkBit(ticks);
//                     }
//                 }
//                 reg.SR = @bitCast(~@as(u32, @bitCast(sr)));
//             },

//             else => unreachable,
//         }
//     }
// };

// pub const timer_type1_t = struct {
//     common: common_t = .{},
//     reg: @TypeOf(hal.TIM1),

//     pub const initPwm = common_t.initPwm;
//     pub const initIrRemote = common_t.initIrRemote;
//     pub const popIrRemote = common_t.popIrRemote;
//     pub const getCC = common_t.getCC;
//     pub const setCC = common_t.setCC;
//     pub const irq = common_t.irq;
// };

// pub const timer_type2_t = struct {
//     common: common_t = .{},
//     reg: @TypeOf(hal.TIM2),

//     pub const initPwm = common_t.initPwm;
//     pub const initIrRemote = common_t.initIrRemote;
//     pub const popIrRemote = common_t.popIrRemote;
//     pub const getCC = common_t.getCC;
//     pub const setCC = common_t.setCC;
//     pub const irq = common_t.irq;
// };

// pub var timer1: timer_type1_t = .{ .reg = hal.TIM1 };
// pub var timer2: timer_type2_t = .{ .reg = hal.TIM2 };
// pub var timer3: timer_type2_t = .{ .reg = hal.TIM3 };
// pub var timer4: timer_type2_t = .{ .reg = hal.TIM4 };

// pub fn timer2_irq() callconv(.C) void {
//     timer2.irq();
// }

// pub fn timer3_irq() callconv(.C) void {
//     timer3.irq();
// }

// pub fn timer4_irq() callconv(.C) void {
//     timer4.irq();
// }
