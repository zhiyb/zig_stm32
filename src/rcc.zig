const hal = @import("stm32f722.zig");

pub fn init() void {
    // Enable HSE
    hal.RCC.CR.HSEON = 1;
    while (hal.RCC.CR.HSERDY == 0) {}
    // Switch to HSE
    hal.RCC.CFGR.SW = @intFromEnum(hal.RCC_CFGR_SW.HSE);
    while (hal.RCC.CFGR.SWS != @intFromEnum(hal.RCC_CFGR_SW.HSE)) {}

    // Disable HSI and PLL
    hal.RCC.CR.HSION = 0;
    hal.RCC.CR.PLLON = 0;
    while (hal.RCC.CR.PLLRDY != 0) {}

    // Configure PLL (HSE, PLLM = 12, PLLN = 270, PLLP = 2, PLLQ = 8)
    hal.RCC.PLLCFGR = .{
        .PLLM = 12,
        .PLLN = 270,
        .PLLP = @intFromEnum(hal.RCC_PLLCFGR_PLLP.DIV_2),
        .PLLQ = 8,
        .PLLSRC = @intFromEnum(hal.RCC_PLLCFGR_PLLSRC.HSE),
    };

    // Enable power controller
    hal.RCC.APB1ENR.PWREN = 1;
    // Regulator voltage scale 1
    hal.PWR.CR1.VOS = @intFromEnum(hal.PWR_CR1_VOS.SCALE_1);
    // Enable PLL
    hal.RCC.CR.PLLON = 1;
    // Enable Over-drive mode
    hal.PWR.CR1.ODEN = 1;
    while (hal.PWR.CSR1.ODRDY == 0) {}
    hal.PWR.CR1.ODSWEN = 1;
    while (hal.PWR.CSR1.ODSWRDY == 0) {}
    // Set flash latency
    // ART enable, prefetch enable, 7 wait states
    hal.FLASH.ACR = .{
        .ARTRST = 0,
        .ARTEN = 1,
        .PRFTEN = 1,
        .LATENCY = 7,
    };
    // Set AHB & APB prescalers
    // AHB = 1, APB1 = 4, APB2 = 2
    hal.RCC.CFGR = .{
        .SW = @intFromEnum(hal.RCC_CFGR_SW.HSE),
        .HPRE = @intFromEnum(hal.RCC_CFGR_HPRE.DIV_1),
        .PPRE1 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_4),
        .PPRE2 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_2),
    };

    // Wait for PLL lock
    while (hal.RCC.CR.PLLRDY == 0) {}
    // Switch to PLL
    hal.RCC.CFGR.SW = @intFromEnum(hal.RCC_CFGR_SW.PLL);
    while (hal.RCC.CFGR.SWS != @intFromEnum(hal.RCC_CFGR_SW.PLL)) {}
    // Select peripheral clocks
    hal.RCC.DCKCFGR2 = .{};
}

pub const peripherals_t = enum {
    GPIOA,
    GPIOB,
    GPIOC,
    GPIOD,
    GPIOE,
    GPIOF,
    GPIOG,
    GPIOH,
    GPIOI,
};

pub fn enablePeripheralsComp(comptime phs: []const struct {
    per: peripherals_t,
    en: bool = true,
}) void {
    comptime var ahb1enr_mask: @TypeOf(hal.RCC.AHB1ENR) = .{};
    comptime var ahb1enr_val: @TypeOf(hal.RCC.AHB1ENR) = .{};
    comptime {
        for (phs) |ph| {
            const en = @intFromBool(ph.en);
            switch (ph.per) {
                .GPIOA => {
                    ahb1enr_mask.GPIOAEN = 1;
                    ahb1enr_val.GPIOAEN = en;
                },
                .GPIOB => {
                    ahb1enr_mask.GPIOBEN = 1;
                    ahb1enr_val.GPIOBEN = en;
                },
                .GPIOC => {
                    ahb1enr_mask.GPIOCEN = 1;
                    ahb1enr_val.GPIOCEN = en;
                },
                .GPIOD => {
                    ahb1enr_mask.GPIODEN = 1;
                    ahb1enr_val.GPIODEN = en;
                },
                .GPIOE => {
                    ahb1enr_mask.GPIOEEN = 1;
                    ahb1enr_val.GPIOEEN = en;
                },
                .GPIOF => {
                    ahb1enr_mask.GPIOFEN = 1;
                    ahb1enr_val.GPIOFEN = en;
                },
                .GPIOG => {
                    ahb1enr_mask.GPIOGEN = 1;
                    ahb1enr_val.GPIOGEN = en;
                },
                .GPIOH => {
                    ahb1enr_mask.GPIOHEN = 1;
                    ahb1enr_val.GPIOHEN = en;
                },
                .GPIOI => {
                    ahb1enr_mask.GPIOIEN = 1;
                    ahb1enr_val.GPIOIEN = en;
                },
            }
        }
    }
    hal.RCC.AHB1ENR.set(ahb1enr_mask, ahb1enr_val);
}
