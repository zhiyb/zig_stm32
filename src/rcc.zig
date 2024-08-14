const std = @import("std");
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
    enablePeripheralsComp(&.{.{ .per = "PWR" }});
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

const clock_t = enum {
    ahb,
    apb1,
    apb1_timer,
    apb2,
    apb2_timer,
};

pub fn clockHz(clock: clock_t) u32 {
    return switch (clock) {
        .ahb => 216_000_000,
        .apb1 => 54_000_000,
        .apb1_timer => 108_000_000,
        .apb2 => 108_000_000,
        .apb2_timer => 216_000_000,
    };
}

const buses = .{ "ahb1", "ahb2", "ahb3", "apb1", "apb2" };
const reg_set_t = struct {
    ahb1enr_mask: @TypeOf(hal.RCC.AHB1ENR) = .{},
    ahb1enr_val: @TypeOf(hal.RCC.AHB1ENR) = .{},
    ahb2enr_mask: @TypeOf(hal.RCC.AHB2ENR) = .{},
    ahb2enr_val: @TypeOf(hal.RCC.AHB2ENR) = .{},
    ahb3enr_mask: @TypeOf(hal.RCC.AHB3ENR) = .{},
    ahb3enr_val: @TypeOf(hal.RCC.AHB3ENR) = .{},
    apb1enr_mask: @TypeOf(hal.RCC.APB1ENR) = .{},
    apb1enr_val: @TypeOf(hal.RCC.APB1ENR) = .{},
    apb2enr_mask: @TypeOf(hal.RCC.APB2ENR) = .{},
    apb2enr_val: @TypeOf(hal.RCC.APB2ENR) = .{},
};

pub fn enablePeripheralsComp(comptime phs: []const struct {
    per: []const u8,
    en: bool = true,
}) void {
    comptime var reg_set: reg_set_t = .{};
    inline for (phs) |ph| {
        const en = @intFromBool(ph.en);
        const field = ph.per ++ "EN";
        comptime var found = false;
        inline for (buses) |r| {
            const mask = &@field(reg_set, r ++ "enr_mask");
            const val = &@field(reg_set, r ++ "enr_val");
            if (@hasField(@TypeOf(mask.*), field)) {
                @field(mask.*, field) = 1;
                @field(val.*, field) = en;
                found = true;
                break;
            }
        }
        if (!found)
            @compileError("Unknown peripheral: " ++ ph.per);
    }

    inline for (buses) |r| {
        const mask = &@field(reg_set, r ++ "enr_mask");
        const val = &@field(reg_set, r ++ "enr_val");
        const reg_name = comptime blk: {
            var buf: [16]u8 = undefined;
            break :blk std.ascii.upperString(&buf, r ++ "enr");
        };
        @field(hal.RCC, reg_name).set(mask.*, val.*);
    }
}
