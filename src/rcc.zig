const hal = @import("stm32f103.zig");

pub fn init() void {
    // Enable external crystal oscillator
    hal.REG.RCC.CR.HSEON = 1;
    while (hal.REG.RCC.CR.HSERDY == 0) {}
    hal.REG.RCC.CFGR.SW = @intFromEnum(hal.RCC_CFGR_SW.HSE);
    while (hal.REG.RCC.CFGR.SWS != @intFromEnum(hal.RCC_CFGR_SW.HSE)) {}

    // Enable PLL
    // Clock from 8MHz HSE, x9 to 72MHz system clock
    // System timer @ 72 MHz
    // APB1         @ 36 MHz
    // APB2         @ 72 MHz
    // USB          @ 48 MHz
    hal.REG.RCC.CFGR = .{
        .PLLMUL = @intFromEnum(hal.RCC_CFGR_PLLMUL.MUL_9),
        .PLLSRC = @intFromEnum(hal.RCC_CFGR_PLLSRC.HSE),
        .PPRE1 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_2),
        .PPRE2 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_1),
        .SW = @intFromEnum(hal.RCC_CFGR_SW.HSE),
    };
    hal.REG.RCC.CR = .{
        .HSION = 1,
        .HSEON = 1,
        .PLLON = 1,
    };
    while (hal.REG.RCC.CR.PLLRDY == 0) {}

    // 2 flash wait states for SYSCLK >= 48 MHz
    hal.REG.FLASH.ACR = .{
        .PRFTBS = 1,
        .PRFTBE = 1,
        .LATENCY = @intFromEnum(hal.FLASH_ACR_LATENCY.WAIT_2),
    };

    // Switch to PLL clock
    hal.REG.RCC.CFGR.SW = @intFromEnum(hal.RCC_CFGR_SW.PLL);
    while (hal.REG.RCC.CFGR.SWS != @intFromEnum(hal.RCC_CFGR_SW.PLL)) {}
}

pub const peripherals_t = enum {
    IOPA,
    IOPB,
    TIM1,
    TIM2,
    TIM3,
    TIM4,
};

pub fn enable(ph: peripherals_t, en: bool) void {
    const v = @intFromBool(en);
    switch (ph) {
        .IOPA => hal.REG.RCC.APB2ENR.IOPAEN = v,
        .IOPB => hal.REG.RCC.APB2ENR.IOPBEN = v,
        .TIM1 => hal.REG.RCC.APB2ENR.TIM1EN = v,
        .TIM2 => hal.REG.RCC.APB1ENR.TIM2EN = v,
        .TIM3 => hal.REG.RCC.APB1ENR.TIM3EN = v,
        .TIM4 => hal.REG.RCC.APB1ENR.TIM4EN = v,
    }
}
