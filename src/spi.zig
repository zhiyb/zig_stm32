const std = @import("std");
const hal = @import("stm32f722.zig");
const rcc = @import("rcc.zig");

pub const spi_bus_map_t = struct {
    const SPI1 = "APB2";
    const SPI2 = "APB1";
    const SPI3 = "APB1";
    const SPI4 = "APB2";
    const SPI5 = "APB2";
};

pub const spi_cfg_t = struct {
    format: enum { motorola, ti } = .motorola,
    cpha: u1 = 0,
    cpol: u1 = 0,
    bits: u5 = 8,
    nss_mode: enum { ssm, input, hardware } = .hardware,
    lsb_first: u1 = 0,
    freq_hz: u32,
};

fn baudRateDiv(ratio: u32) u3 {
    const baud_map = [_]comptime_int{ 2, 4, 8, 16, 32, 64, 128, 256 };
    var br: u3 = 0;
    inline for (baud_map) |baud_div| {
        if (baud_div >= ratio)
            return br;
        br += 1;
    }
    std.debug.panic("Impossible baud rate divider: {}", .{ratio});
}

pub fn master(comptime spix: []const u8) type {
    const reg = @field(hal, spix);
    return struct {
        pub fn init(comptime cfg: spi_cfg_t) void {
            // Configure SPI
            const bus_freq_hz = comptime rcc.clockHz(@field(spi_bus_map_t, spix));
            const ratio = comptime bus_freq_hz / cfg.freq_hz;
            const br = comptime baudRateDiv(ratio);
            reg.CR1.write(comptime .{
                .BIDIMODE = 0,
                .BIDIOE = 0,
                .CRCEN = 0,
                .CRCNEXT = 0,
                .CRCL = 0,
                .RXONLY = 0,
                .SSM = @intFromBool(cfg.nss_mode == .ssm),
                .SSI = 1,
                .LSBFIRST = cfg.lsb_first,
                .SPE = 0,
                .BR = br,
                .MSTR = 1,
                .CPOL = cfg.cpol,
                .CPHA = cfg.cpha,
            });
            reg.CR2.write(comptime .{
                .DS = cfg.bits - 1,
                .TXEIE = 0,
                .RXNEIE = 0,
                .ERRIE = 0,
                .FRF = @intFromBool(cfg.format == .ti),
                .NSSP = @intFromBool(cfg.nss_mode == .hardware),
                .SSOE = @intFromBool(cfg.nss_mode == .hardware),
                .TXDMAEN = 0,
                .RXDMAEN = 0,
            });
            reg.I2SCFGR.write(.{ .I2SMOD = 0 });

            // Enable SPI
            reg.CR1.modify(.{ .SPE = 1 });
        }

        pub fn transmit(val: u16) void {
            while (reg.SR.read().TXE == 0) {}
            reg.DR.write(.{ .DR = val });
        }
    };
}
