const std = @import("std");
const timer = @import("timer.zig");
const semihosting = @import("semihosting.zig");

pub fn Config() type {
    return struct {
        // NEC IR remote protocol decoder
        const nec = struct {
            const start_burst_us = 9_000.0;
            const start_space_us = 4_500.0;
            const bit_burst_us = 562.5;
            const b0_space_us = 562.5;
            const b1_space_us = 1_687.5;
            const tolerance = 0.30; // 30% tolerance

            pub fn minTicks(timer_ch: anytype, us: comptime_float) comptime_int {
                return usToTicks(timer_ch, us * (1.0 - nec.tolerance));
            }

            pub fn maxTicks(timer_ch: anytype, us: comptime_float) comptime_int {
                return usToTicks(timer_ch, us * (1.0 + nec.tolerance));
            }
        };

        // Last timer count
        var last_cnt: u32 = 0;

        // 32-bit IR code
        var state: enum {
            idle,
            start_burst,
            start_space,
            bit_burst,
            bit_space,
        } = .idle;
        var val: u32 = 0;
        var bit: u5 = 0;

        // IR code log
        const num_log_entries = 8;
        var log: [num_log_entries]u32 = .{0} ** num_log_entries;
        var log_read_idx = std.atomic.Value(u32).init(0);
        var log_write_idx = std.atomic.Value(u32).init(0);

        fn usToTicks(timer_ch: type, us: comptime_float) comptime_int {
            const freq = timer_ch.cnt_freq_hz;
            const tick_us = 1_000_000.0 / freq;
            return @round(us / tick_us);
        }

        pub fn dequeue() ?u32 {
            const ridx = log_read_idx.load(.monotonic);
            const widx = log_write_idx.load(.monotonic);
            if (ridx != widx) {
                const ridx_next = (ridx +% 1) % num_log_entries;
                const v = @atomicLoad(u32, &log[ridx], .monotonic);
                log_read_idx.store(ridx_next, .release);
                return v;
            }
            return null;
        }

        pub fn irq(timer_ch: anytype, cnt: u32, oc: bool) void {
            const period = timer_ch.getTop() + 1;
            const ticks = (period + cnt - last_cnt) % period;
            last_cnt = cnt;

            if (oc) {
                state = .idle;
                return;
            }

            const start_min_ticks = nec.minTicks(timer_ch, nec.start_burst_us);
            const start_max_ticks = nec.maxTicks(timer_ch, nec.start_burst_us);
            if (ticks >= start_min_ticks and ticks <= start_max_ticks) {
                state = .start_burst;
                // val = 0;
                bit = 0;
                return;
            }

            switch (state) {
                .idle => {
                    return;
                },
                .start_burst => {
                    const min_ticks = nec.minTicks(timer_ch, nec.start_space_us);
                    const max_ticks = nec.maxTicks(timer_ch, nec.start_space_us);
                    state = if (ticks >= min_ticks and ticks <= max_ticks) .start_space else .idle;
                },
                .start_space => {
                    const min_ticks = nec.minTicks(timer_ch, nec.bit_burst_us);
                    const max_ticks = nec.maxTicks(timer_ch, nec.bit_burst_us);
                    state = if (ticks >= min_ticks and ticks <= max_ticks) .bit_burst else .idle;
                },
                .bit_burst => {
                    const b0_min_ticks = nec.minTicks(timer_ch, nec.b0_space_us);
                    const b0_max_ticks = nec.maxTicks(timer_ch, nec.b0_space_us);
                    const b1_min_ticks = nec.minTicks(timer_ch, nec.b1_space_us);
                    const b1_max_ticks = nec.maxTicks(timer_ch, nec.b1_space_us);
                    if (ticks >= b0_min_ticks and ticks <= b0_max_ticks) {
                        val = (val << 1) | 0;
                        bit +%= 1;
                        state = .bit_space;
                    } else if (ticks >= b1_min_ticks and ticks <= b1_max_ticks) {
                        val = (val << 1) | 1;
                        bit +%= 1;
                        state = .bit_space;
                    } else {
                        state = .idle;
                    }

                    if (bit == 0) {
                        // 32-bit IR code complete
                        const ridx = log_read_idx.load(.monotonic);
                        const widx = log_write_idx.load(.monotonic);
                        const widx_next = (widx +% 1) % num_log_entries;
                        if (ridx != widx_next) {
                            @atomicStore(u32, &log[widx], val, .monotonic);
                            log_write_idx.store(widx_next, .release);
                        }
                        state = .idle;
                    }
                },
                .bit_space => {
                    const min_ticks = nec.minTicks(timer_ch, nec.bit_burst_us);
                    const max_ticks = nec.maxTicks(timer_ch, nec.bit_burst_us);
                    state = if (ticks >= min_ticks and ticks <= max_ticks) .bit_burst else .idle;
                },
            }
        }
    };
}

// Known IR remote codes

pub const remote_sky_now_tv = struct {
    const special_mask: u32 = 0x00000303;
    pub const Button = enum(u32) {
        back = 0x57436699 & ~special_mask,
        home = 0x5743c03f & ~special_mask,
        up = 0x57439867 & ~special_mask,
        down = 0x5743cc33 & ~special_mask,
        left = 0x57437887 & ~special_mask,
        right = 0x5743b44b & ~special_mask,
        ok = 0x574354ab & ~special_mask,
        rewind = 0x57432cd3 & ~special_mask,
        pause = 0x574332cd & ~special_mask,
        ff = 0x5743aa55 & ~special_mask,
        star = 0x57438679 & ~special_mask,
        now = 0x574320df & ~special_mask,
        store = 0x574318e7 & ~special_mask,
    };

    pub fn decode(val: u32) ?struct { button: Button, repeat: bool } {
        const button = std.meta.intToEnum(Button, val & ~special_mask) catch return null;
        return .{ .button = button, .repeat = (val & 0x00000101) == 0x00000100 };
    }
};
