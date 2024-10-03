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

pub fn config(x_spi: anytype, y_spi: anytype) type {
    return struct {
        var laser_dac = std.atomic.Value(u32).init(0);

        pub fn spi_update_irq(_: timer.timer_cfg_t) void {
            const dac = laser_dac.load(.monotonic);
            const x = @as(u16, @intCast(dac & 0xffff));
            const y = @as(u16, @intCast((dac >> 16) & 0xffff));
            x_spi.transmit(x);
            y_spi.transmit(y);
            x_spi.transmit(x ^ ((0b1000 << 12) | 0x0fff));
            y_spi.transmit(y ^ ((0b1000 << 12) | 0x0fff));
        }

        pub fn update(x: u12, y: u12) void {
            const dac_x = @as(u32, 0b0111 << 12) | x;
            const dac_y = @as(u32, 0b0111 << 12) | y;
            laser_dac.store((dac_y << 16) | dac_x, .monotonic);
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
