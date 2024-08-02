const std = @import("std");
const hal = @import("stm32f103.zig");
const REG = hal.REG;

pub fn init() void {
    // Enable external crystal oscillator
    REG.RCC.CR.HSEON = 1;
    while (REG.RCC.CR.HSERDY == 0) {}
    REG.RCC.CFGR.SW = @intFromEnum(hal.RCC_CFGR_SW.HSE);
    while (REG.RCC.CFGR.SWS != @intFromEnum(hal.RCC_CFGR_SW.HSE)) {}

    // Enable PLL
    // Clock from 8MHz HSE, x9 to 72MHz system clock
    // System timer @ 72 MHz
    // APB1         @ 36 MHz
    // APB2         @ 72 MHz
    // USB          @ 48 MHz
    REG.RCC.CFGR = .{
        .PLLMUL = @intFromEnum(hal.RCC_CFGR_PLLMUL.MUL_9),
        .PLLSRC = @intFromEnum(hal.RCC_CFGR_PLLSRC.HSE),
        .PPRE1 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_2),
        .PPRE2 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_1),
        .SW = @intFromEnum(hal.RCC_CFGR_SW.HSE),
    };
    REG.RCC.CR = .{
        .HSION = 1,
        .HSEON = 1,
        .PLLON = 1,
    };
    while (REG.RCC.CR.PLLRDY == 0) {}

    // 2 flash wait states for SYSCLK >= 48 MHz
    REG.FLASH.ACR = .{
        .PRFTBS = 1,
        .PRFTBE = 1,
        .LATENCY = @intFromEnum(hal.FLASH_ACR_LATENCY.WAIT_2),
    };

    // Switch to PLL clock
    REG.RCC.CFGR.SW = @intFromEnum(hal.RCC_CFGR_SW.PLL);
    while (REG.RCC.CFGR.SWS != @intFromEnum(hal.RCC_CFGR_SW.PLL)) {}
}
