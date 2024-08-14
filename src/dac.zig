const hal = @import("stm32f722.zig");

pub fn init() void {
    hal.DAC.CR = .{
        .EN1 = 0,
        .EN2 = 0,
    };
    hal.DAC.DHR12RD = .{
        .DACC1DHR = 0,
        .DACC2DHR = 2048,
    };
    hal.DAC.CR = .{
        .WAVE1 = 0b00,
        .BOFF1 = 0,
        .EN1 = 1,
        .WAVE2 = 0b00,
        .BOFF2 = 0,
        .EN2 = 1,
    };
}

pub fn update(dac1: u12, dac2: u12) void {
    hal.DAC.DHR12RD = .{
        .DACC1DHR = dac1,
        .DACC2DHR = dac2,
    };
}
