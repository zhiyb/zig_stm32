const std = @import("std");
const spi = @import("spi.zig");
const timer = @import("timer.zig");

// MCP4922 SPI clock frequency
pub const spi_freq_hz = 20_000_000;
// Min LDAC pulse width 100ns
pub const ldpc_timer_clk_freq_hz = 10_000_000;
// LDAC trigger frequency
pub const ldac_timer_freq_hz = spi_freq_hz / ((16 + 3) * 2 + 2);
// Timer period
pub const ldac_timer_top = (ldpc_timer_clk_freq_hz + ldac_timer_freq_hz) / ldac_timer_freq_hz - 1;

// RGB laser timer period
pub const rgb_timer_top = 255;

pub fn config(
    x_spi: anytype,
    y_spi: anytype,
    timer_r: anytype,
    timer_g: anytype,
    timer_b: anytype,
) type {
    return struct {
        var laser_dac = std.atomic.Value(u32).init(0);

        var rgb_scale: struct {
            r: u16 = 0,
            g: u16 = 0,
            b: u16 = 0,
        } = .{};

        pub fn spi_update_irq(_: timer.timer_cfg_t) void {
            const dac = laser_dac.load(.monotonic);
            const x = @as(u16, @intCast(dac & 0xffff));
            const y = @as(u16, @intCast((dac >> 16) & 0xffff));
            x_spi.transmit(x);
            y_spi.transmit(y);
            x_spi.transmit(x ^ ((0b1000 << 12) | 0x0fff));
            y_spi.transmit(y ^ ((0b1000 << 12) | 0x0fff));
        }

        pub fn update_xy(x: u12, y: u12) void {
            const dac_x = @as(u32, 0b0111 << 12) | x;
            const dac_y = @as(u32, 0b0111 << 12) | y;
            laser_dac.store((dac_y << 16) | dac_x, .monotonic);
        }

        pub fn update_rgb_scale(r: u16, g: u16, b: u16) void {
            rgb_scale = .{ .r = r, .g = g, .b = b };
        }

        pub fn update_rgb(rgb: u32) void {
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
            const spi_cfg: spi.spi_cfg_t = .{
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

pub fn test_pattern(
    laser_inst: anytype,
    systick_inst: anytype,
) type {
    const w = 4096 / 4;
    const h = 4096 / 4;
    const x_ofs = 2048;
    const y_ofs = 2048;
    const delta_ms = 3;
    const pattern = [_]struct {
        x: u12,
        y: u12,
        rgb: u24,
        ms: u32,
    }{
        .{ .x = x_ofs + 0, .y = y_ofs + 0, .rgb = 0xff0000, .ms = delta_ms },
        .{ .x = x_ofs + w - 1, .y = y_ofs + 0, .rgb = 0x00ff00, .ms = delta_ms },
        .{ .x = x_ofs + w - 1, .y = y_ofs + h - 1, .rgb = 0x0000ff, .ms = delta_ms },
        .{ .x = x_ofs + 0, .y = y_ofs + h - 1, .rgb = 0xffcf5f, .ms = delta_ms },
    };

    return struct {
        var pat: struct {
            idx: u32 = 0,
            tick_ms: u32 = 0,
        } = .{};

        pub fn init() void {
            const now_ms = systick_inst.get_ms();
            pat.idx = 0;
            const ptn = pattern[pat.idx];
            pat.tick_ms = now_ms +% ptn.ms;
            laser_inst.update_rgb(ptn.rgb);
            laser_inst.update_xy(ptn.x, ptn.y);
        }

        pub fn update() void {
            const now_ms = systick_inst.get_ms();
            const delta: i32 = @bitCast(now_ms -% pat.tick_ms);
            if (delta >= 0) {
                pat.idx = (pat.idx +% 1) % pattern.len;
                const ptn = pattern[pat.idx];
                pat.tick_ms +%= ptn.ms;
                laser_inst.update_rgb(ptn.rgb);
                laser_inst.update_xy(ptn.x, ptn.y);
            }
        }
    };
}
