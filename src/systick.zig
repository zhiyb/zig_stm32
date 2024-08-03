const hal = @import("stm32f103.zig");

pub const tick_rate = 1_000;

pub var tick: u32 = 0;
pub const ptick = @as(*volatile u32, &tick);

pub fn init() void {
    const reg = hal.REG.STK;
    tick = 0;

    // Clock source AHB/8 = 72/8 = 9 MHz
    reg.CTRL = .{
        .CLKSOURCE = 0,
        .TICKINT = 1,
        .ENABLE = 0,
    };
    const freq_in = 72_000_000 / 8;
    const ratio = freq_in / tick_rate;
    reg.LOAD.RELOAD = ratio - 1;
    reg.VAL.CURRENT = 0;
    reg.CTRL.ENABLE = 1;
}

pub fn irq() callconv(.C) void {
    ptick.* +%= 1;
}

pub fn delay_ms(ms: u32) void {
    const tick_start = ptick.*;
    while (ptick.* -% tick_start < ms) {}
}
