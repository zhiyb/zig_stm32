const std = @import("std");
const spi = @import("spi.zig");
const timer = @import("timer.zig");

// MCP4922 SPI clock frequency
pub const spi_freq_hz = 13_500_000; // 54M / 4
// Min LDAC pulse width 100ns
pub const ldpc_timer_clk_freq_hz = 10_000_000;
// LDAC trigger frequency
pub const ldac_timer_freq_hz = spi_freq_hz / ((16 + 2) * 2 + 4);
// Timer period
pub const ldac_timer_top = (ldpc_timer_clk_freq_hz + ldac_timer_freq_hz - 1) / ldac_timer_freq_hz - 1;

// RGB laser timer period
pub const rgb_timer_top = 127;

pub fn Config(
    x_spi: anytype,
    y_spi: anytype,
    timer_r: anytype,
    timer_g: anytype,
    timer_b: anytype,
) type {
    return struct {
        var dac_buf = [_]u32{0} ** 64;
        var dac_ridx = std.atomic.Value(u32).init(0);
        var dac_widx = std.atomic.Value(u32).init(0);

        var rgb_scale: struct {
            r: u16 = 0,
            g: u16 = 0,
            b: u16 = 0,
        } = .{};

        pub fn spiUpdateIrq(_: timer.TimerCfg) void {
            const ridx = dac_ridx.load(.monotonic);
            const dac = @atomicLoad(u32, &dac_buf[ridx], .monotonic);
            const x: u16 = @truncate(dac);
            const y: u16 = @truncate(dac >> 16);
            x_spi.transmit(x);
            y_spi.transmit(y);
            x_spi.transmit(x ^ ((0b1000 << 12) | 0x0fff));
            y_spi.transmit(y ^ ((0b1000 << 12) | 0x0fff));

            const ridx_next = (ridx +% 1) % dac_buf.len;
            const widx = dac_widx.load(.monotonic);
            if (ridx_next != widx)
                dac_ridx.store(ridx_next, .monotonic);
        }

        pub fn dacBufAvailable() bool {
            const widx = dac_widx.load(.monotonic);
            const ridx = dac_ridx.load(.monotonic);
            const widx_next = (widx +% 1) % dac_buf.len;
            return ridx != widx_next;
        }

        pub fn updateXy(x: u12, y: u12) void {
            const dac_x = @as(u32, 0b0111 << 12) | x;
            const dac_y = @as(u32, 0b0111 << 12) | y;
            const dac = (dac_y << 16) | dac_x;
            const widx = dac_widx.load(.monotonic);
            @atomicStore(u32, &dac_buf[widx], dac, .monotonic);
            const widx_next = (widx +% 1) % dac_buf.len;
            // Block waiting for available DAC buffer space
            while (true) {
                const ridx = dac_ridx.load(.monotonic);
                if (ridx != widx_next)
                    break;
            }
            dac_widx.store(widx_next, .monotonic);
        }

        pub fn updateRgbScale(r: u16, g: u16, b: u16) void {
            rgb_scale = .{ .r = r, .g = g, .b = b };
        }

        pub fn updateRgb(rgb: u32) void {
            const r = ((rgb >> 16) & 0xff) * rgb_scale.r / 255;
            const g = ((rgb >> 8) & 0xff) * rgb_scale.g / 255;
            const b = ((rgb >> 0) & 0xff) * rgb_scale.b / 255;
            const r16 = @as(u16, @intCast(r));
            const g16 = @as(u16, @intCast(g));
            const b16 = @as(u16, @intCast(b));
            timer_r.setCmp(r16);
            timer_g.setCmp(g16);
            timer_b.setCmp(b16);
        }

        pub fn init(rcc_inst: anytype) void {
            const spi_cfg: spi.SpiCfg = .{
                .cpha = 0,
                .cpol = 0,
                .bits = 16,
                .freq_hz = spi_freq_hz,
            };
            x_spi.init(rcc_inst, spi_cfg);
            y_spi.init(rcc_inst, spi_cfg);
        }
    };
}

pub const test_pattern = struct {
    pub const rectangle = [_]PatternStep{
        .{ .x = 0, .y = 0, .rgb = 0xff0000, .t = 1000 },
        .{ .x = 4095, .y = 0, .rgb = 0x00ff00, .t = 1000 },
        .{ .x = 4095, .y = 4095, .rgb = 0x0000ff, .t = 1000 },
        .{ .x = 0, .y = 4095, .rgb = 0xffffff, .t = 1000 },
    };

    pub const pentagram = [_]PatternStep{
        .{ .x = 2048, .y = 0, .rgb = 0xff0000, .t = 1000 },
        .{ .x = 3315, .y = 4095, .rgb = 0x00ff00, .t = 1000 },
        .{ .x = 0, .y = 1594, .rgb = 0x0000ff, .t = 1000 },
        .{ .x = 4095, .y = 1594, .rgb = 0xffff00, .t = 1000 },
        .{ .x = 780, .y = 4095, .rgb = 0xffffff, .t = 1000 },
    };

    pub const pentagram_2 = [_]PatternStep{
        .{ .x = 2048, .y = 0, .rgb = 0xff0000, .t = 500 },
        .{ .x = 3315, .y = 4095, .rgb = 0xff0000, .t = 500 },
        .{ .x = 780, .y = 4095, .rgb = 0x00ff00, .t = 500 },
        .{ .x = 2048, .y = 0, .rgb = 0x00ff00, .t = 500 },
        .{ .x = 4095, .y = 1594, .rgb = 0x0000ff, .t = 500 },
        .{ .x = 780, .y = 4095, .rgb = 0x0000ff, .t = 500 },
        .{ .x = 0, .y = 1594, .rgb = 0xffff00, .t = 500 },
        .{ .x = 4095, .y = 1594, .rgb = 0xffff00, .t = 500 },
        .{ .x = 3315, .y = 4095, .rgb = 0xffffff, .t = 500 },
        .{ .x = 0, .y = 1594, .rgb = 0xffffff, .t = 500 },
    };

    pub const PatternStep = struct {
        x: u12,
        y: u12,
        rgb: u24,
        t: u32,
    };

    pub fn Player(
        laser_inst: type,
        comptime range: struct { x: u12, y: u12, w: u12, h: u12 },
        comptime pattern: []const PatternStep,
    ) type {
        return struct {
            var idx: u32 = 0;
            var tick: u32 = 0;

            pub fn updateXy(px: u12, py: u12) void {
                // Extra XY swap
                const x = @as(u12, @intCast((@as(u32, py) *% range.w) / 4096 +% range.x));
                const y = @as(u12, @intCast((@as(u32, px) *% range.h) / 4096 +% range.y));
                laser_inst.updateXy(x, y);
            }

            pub fn init() void {
                idx = 0;
                tick = 0;
                updateXy(pattern[idx].x, pattern[idx].y);
                laser_inst.updateRgb(pattern[idx].rgb);
            }

            pub fn interpolation(start: u12, end: u12, step: u32, total: u32) u12 {
                const s = @as(i32, start);
                const e = @as(i32, end);
                const istep: i32 = @bitCast(step);
                const itotal: i32 = @bitCast(total);
                const intp = s + @divFloor((e - s) * istep, itotal);
                return @truncate(@as(u32, @bitCast(intp)));
            }

            pub fn update() void {
                if (!laser_inst.dacBufAvailable())
                    return;

                const next_idx = (idx +% 1) % pattern.len;
                const pat_c = pattern[idx];
                const pat_n = pattern[next_idx];
                const x = interpolation(pat_c.x, pat_n.x, tick, pat_c.t);
                const y = interpolation(pat_c.y, pat_n.y, tick, pat_c.t);
                updateXy(x, y);
                // TODO Associate RGB with XY position
                laser_inst.updateRgb(pat_c.rgb);

                tick = tick +% 1;
                if (tick == pat_c.t) {
                    tick = 0;
                    idx = next_idx;
                }
            }
        };
    }
};
