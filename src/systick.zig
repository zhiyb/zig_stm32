const std = @import("std");
const hal = @import("stm32f722.zig");
const rcc = @import("rcc.zig");

pub const cfg_t = struct {
    tick_rate_hz: comptime_int,
};

pub fn config(rcc_inst: type, cfg: cfg_t) type {
    const freq_in = rcc_inst.clockHz(.AHB) / 8;
    const ratio = freq_in / cfg.tick_rate_hz;
    return struct {
        var tick_cnt = std.atomic.Value(u32).init(0);

        pub fn irq() callconv(.C) void {
            _ = tick_cnt.rmw(.Add, 1, .monotonic);
        }

        pub fn get_tick() struct { tick: u32, cnt: u32 } {
            var tick = tick_cnt.load(.acquire);
            var cnt: u32 = 0;
            while (true) {
                cnt = @atomicLoad(u32, &hal.SYST.CVR.raw, .acquire);
                const now = tick_cnt.load(.monotonic);
                if (now == tick) {
                    break;
                } else {
                    tick = now;
                }
            }
            return .{ .tick = tick, .cnt = ratio - 1 - cnt };
        }

        pub fn get_ms() u32 {
            if (cfg.tick_rate_hz != 1_000)
                @compileError("Unsupported tick rate");
            return tick_cnt.load(.monotonic);
        }

        pub fn delay_ms(ms: u32) void {
            if (cfg.tick_rate_hz != 1_000)
                @compileError("Unsupported tick rate");
            const tick_start = tick_cnt.load(.monotonic);
            while (tick_cnt.load(.monotonic) -% tick_start < ms) {}
        }

        pub fn delay_us(us: u32) void {
            if (cfg.tick_rate_hz != 1_000)
                @compileError("Unsupported tick rate");
            const tick_start = get_tick();
            const cnt = @as(u64, us) * ratio / 1000;
            while (true) {
                const tick = get_tick();
                const delta_tick = tick.tick -% tick_start.tick;
                const delta_cnt = @as(u64, delta_tick) * ratio + tick.cnt - tick_start.cnt;
                if (delta_cnt >= cnt)
                    break;
            }
        }

        pub fn apply() void {
            const reg = hal.SYST;
            tick_cnt.store(0, .monotonic);

            reg.CSR.write(.{
                .CLKSOURCE = 0,
                .TICKINT = 1,
                .ENABLE = 0,
            });
            reg.RVR.write(.{ .RELOAD = ratio - 1 });
            reg.CVR.write(.{ .CURRENT = 0 });
            reg.CSR.modify(.{ .ENABLE = 1 });
        }
    };
}
