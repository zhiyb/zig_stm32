const std = @import("std");
const hal = @import("stm32f1.zig");

pub fn init() void {
    // Enable external crystal oscillator
    hal.RCC.CR.HSEON = true;
    while (!hal.RCC.CR.HSERDY) {}
    hal.RCC.CFGR.SW = .HSE;
    while (hal.RCC.CFGR.SWS != .HSE) {}

    // Enable PLL
    // Clock from 8MHz HSE, x9 to 72MHz system clock
    // System timer @ 72 MHz
    // APB1         @ 36 MHz
    // APB2         @ 72 MHz
    // USB          @ 48 MHz
    hal.RCC.CFGR = .{
        .PLLMUL = .MUL_9,
        .PLLSRC = .HSE,
        .PPRE1 = .DIV_2,
        .PPRE2 = .DIV_1,
        .SW = .HSE,
    };
    hal.RCC.CR = .{
        .HSION = true,
        .HSEON = true,
        .PLLON = true,
    };
    while (!hal.RCC.CR.PLLRDY) {}

    // 2 flash wait states for SYSCLK >= 48 MHz
    hal.FLASH.ACR = .{
        .PRFTBS = true,
        .PRFTBE = true,
        .LATENCY = .WAIT_2,
    };

    // Switch to PLL clock
    hal.RCC.CFGR.SW = .PLL;
    while (hal.RCC.CFGR.SWS != .PLL) {}
}
