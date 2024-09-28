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

pub const timer_cfg_t = struct {
    timer: comptime_int,
    freq_hz: comptime_int,
    interrupt: bool = false,
    channels: []const struct {
        num: comptime_int,
        mode: timer_channel_mode_t = .disabled,
        interrupt: bool = false,
    },
};

pub fn config(rcc_inst: anytype, cfg: timer_cfg_t) type {
    return struct {
        const timer = std.fmt.comptimePrint("TIM{}", .{cfg.timer});
        const reg = @field(hal, timer);
        const freq_in = rcc_inst.clockHz(@field(timer_bus_map_t, timer));

        pub fn init() void {
            reg.CR1.write(.{ .CEN = 0 });
            reg.DIER.write(.{});
            reg.SR.write(.{});
            inline for (@typeInfo(@TypeOf(reg.*)).@"struct".fields) |reg_field| {
                // @compileLog(reg_field.name);
                if (comptime std.mem.startsWith(u8, reg_field.name, "CCMR")) {
                    if (comptime std.mem.endsWith(u8, reg_field.name, "_Output")) {
                        // TODO
                        continue;
                    }

                    comptime var CCMR_in: (@TypeOf(@field(reg.*, reg_field.name).Input).underlying_type) = .{};
                    comptime var CCMR_in_mask: (@TypeOf(@field(reg, reg_field.name).Input).underlying_type) = .{};
                    inline for (@typeInfo(@TypeOf(CCMR_in)).@"struct".fields) |field| {
                        if (comptime std.mem.startsWith(u8, field.name, "_RESERVED"))
                            continue;

                        comptime var ch = 0;
                        inline for (field.name) |c| {
                            if (comptime std.ascii.isDigit(c)) {
                                ch = c - '0';
                                break;
                            }
                        }
                        if (ch == 0)
                            @compileError("Unkown field: " ++ reg_field.name ++ "." ++ field.name);
                        const chs = std.fmt.comptimePrint("{}", .{ch});

                        inline for (cfg.channels) |channel| {
                            if (comptime channel.num != ch)
                                continue;
                            const f_ccs = "CC" ++ chs ++ "S";
                            const f_ic_psc = "IC" ++ chs ++ "PSC";
                            const f_ic_f = "IC" ++ chs ++ "F";
                            switch (channel.mode) {
                                .input_capture => {
                                    if (comptime std.mem.eql(u8, field.name, f_ccs)) {
                                        @field(CCMR_in, f_ccs) = @intFromEnum(hal.TIM_CCMR_CCS.INPUT_SAME);
                                        @field(CCMR_in_mask, f_ccs) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_ic_psc)) {
                                        @field(CCMR_in, f_ic_psc) = @intFromEnum(hal.TIM_CCMR_IC_PSC.DIV1);
                                        @field(CCMR_in_mask, f_ic_psc) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_ic_f)) {
                                        @field(CCMR_in, f_ic_f) = @intFromEnum(hal.TIM_CCMR_IC_F.DTS_DIV1_N1);
                                        @field(CCMR_in_mask, f_ic_f) = 1;
                                    } else {
                                        @compileLog("TODO", channel, field.name);
                                    }
                                },
                                else => {},
                            }
                        }
                    }
                    if (comptime !std.meta.eql(CCMR_in_mask, .{}))
                        @field(reg.*, reg_field.name).Input.modify_masked(CCMR_in_mask, CCMR_in);

                    comptime var CCMR_out: (@TypeOf(@field(reg, reg_field.name).Output).underlying_type) = .{};
                    comptime var CCMR_out_mask: (@TypeOf(@field(reg, reg_field.name).Output).underlying_type) = .{};
                    inline for (@typeInfo(@TypeOf(CCMR_out)).@"struct".fields) |field| {
                        if (comptime std.mem.startsWith(u8, field.name, "_RESERVED"))
                            continue;

                        comptime var ch = 0;
                        inline for (field.name) |c| {
                            if (comptime std.ascii.isDigit(c)) {
                                ch = c - '0';
                                break;
                            }
                        }
                        if (ch == 0)
                            @compileError("Unkown field: " ++ reg_field.name ++ "." ++ field.name);
                        const chs = std.fmt.comptimePrint("{}", .{ch});

                        inline for (cfg.channels) |channel| {
                            if (comptime channel.num != ch)
                                continue;
                            const f_ccs = "CC" ++ chs ++ "S";
                            const f_oc_ce = "OC" ++ chs ++ "CE";
                            const f_oc_fe = "OC" ++ chs ++ "FE";
                            const f_oc_pe = "OC" ++ chs ++ "PE";
                            const f_oc_m = "OC" ++ chs ++ "M";
                            const f_oc_m3 = "OC" ++ chs ++ "M_3";
                            switch (channel.mode) {
                                .pwm => {
                                    const oc_m = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1);
                                    if (comptime std.mem.eql(u8, field.name, f_ccs)) {
                                        @field(CCMR_out, f_ccs) = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT);
                                        @field(CCMR_out_mask, f_ccs) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_oc_ce)) {
                                        @field(CCMR_out, f_oc_ce) = 0;
                                        @field(CCMR_out_mask, f_oc_ce) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_oc_fe)) {
                                        @field(CCMR_out, f_oc_fe) = 0;
                                        @field(CCMR_out_mask, f_oc_fe) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_oc_pe)) {
                                        @field(CCMR_out, f_oc_pe) = 0;
                                        @field(CCMR_out_mask, f_oc_pe) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_oc_m)) {
                                        @field(CCMR_out, f_oc_m) = oc_m & 7;
                                        @field(CCMR_out_mask, f_oc_m) = 1;
                                    } else if (comptime std.mem.eql(u8, field.name, f_oc_m3)) {
                                        @field(CCMR_out, f_oc_m3) = oc_m >> 3;
                                        @field(CCMR_out_mask, f_oc_m3) = 1;
                                    } else {
                                        @compileLog("TODO", channel, field.name);
                                    }
                                },
                                else => {},
                            }
                        }
                    }
                    if (comptime !std.meta.eql(CCMR_out_mask, .{}))
                        @field(reg.*, reg_field.name).Output.modify_masked(CCMR_out_mask, CCMR_out);
                }
            }
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

//     fn initPwm(self: anytype, top: u16) void {
//         const reg = self.reg;
//         self.common.mode = .OutputPWM;

//         // Edge counting up
//         reg.CR1 = .{
//             .ARPE = 0,
//             .CMS = @intFromEnum(hal.TIM_CR1_CMS.EDGE),
//             .DIR = @intFromEnum(hal.TIM_CR1_DIR.UP),
//             .OPM = 0,
//             .URS = 0,
//             .UDIS = 0,
//         };
//         reg.CR2 = .{};
//         reg.SMCR = .{};
//         reg.DIER = .{};
//         // Enable CC output 2, 3, 4
//         reg.CCMR1.Output = .{
//             .CC1S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
//             .OC1M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
//             .OC1PE = 0,
//             .OC1FE = 0,
//             .CC2S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
//             .OC2M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
//             .OC2PE = 0,
//             .OC2FE = 0,
//         };
//         reg.CCMR2.Output = .{
//             .CC3S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
//             .OC3M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
//             .OC3PE = 0,
//             .OC3FE = 0,
//             .CC4S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
//             .OC4M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
//             .OC4PE = 0,
//             .OC4FE = 0,
//         };
//         reg.CCER = .{
//             .CC1E = 1,
//             .CC1P = 0,
//             .CC2E = 1,
//             .CC2P = 0,
//             .CC3E = 1,
//             .CC3P = 0,
//             .CC4E = 1,
//             .CC4P = 0,
//         };
//         if (@TypeOf(self.*) == timer_type1_t)
//             reg.BDTR.MOE = 1;

//         if (false) {
//             // Timer overflow frequency
//             const freq = 480;
//             // TIM1 from APB2 @ 72 MHz
//             const freq_in = 72_000_000;
//             const ratio = @max(1, freq_in / freq / 65536);
//             reg.PSC.PSC = @intCast(ratio - 1);
//             reg.ARR.ARR = 65536 - 1;
//         } else {
//             reg.PSC.PSC = 1;
//             reg.ARR.ARR = top;
//         }

//         // Compare values
//         reg.CCR1.CCR1 = 1;
//         reg.CCR2.CCR2 = 1;
//         reg.CCR3.CCR3 = 1;
//         reg.CCR4.CCR4 = 1;

//         // Enable timer
//         reg.CR1.CEN = 1;
//     }

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

//     fn getCC(self: anytype, ch: u8) u16 {
//         return switch (ch) {
//             1 => self.reg.CCR1.CCR1,
//             2 => self.reg.CCR2.CCR2,
//             3 => self.reg.CCR3.CCR3,
//             4 => self.reg.CCR4.CCR4,
//             else => 0,
//         };
//     }

//     fn setCC(self: anytype, ch: u8, val: u16) void {
//         (switch (ch) {
//             1 => self.reg.CCR1.CCR1,
//             2 => self.reg.CCR2.CCR2,
//             3 => self.reg.CCR3.CCR3,
//             else => self.reg.CCR4.CCR4,
//         }) = val;
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
