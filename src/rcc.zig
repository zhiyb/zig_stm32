const std = @import("std");
const hal = @import("stm32f722.zig");

pub fn init() void {
    // Enable HSE
    hal.RCC.CR.modify(.{ .HSEON = 1 });
    while (hal.RCC.CR.read().HSERDY == 0) {}
    // Switch to HSE
    hal.RCC.CFGR.modify(.{ .SW = @intFromEnum(hal.RCC_CFGR_SW.HSE) });
    while (hal.RCC.CFGR.read().SWS != @intFromEnum(hal.RCC_CFGR_SW.HSE)) {}

    // Disable HSI and PLL
    hal.RCC.CR.modify(.{ .HSION = 0 });
    hal.RCC.CR.modify(.{ .PLLON = 0 });
    while (hal.RCC.CR.read().PLLRDY != 0) {}

    // Configure PLL (HSE, PLLM = 12, PLLN = 270, PLLP = 2, PLLQ = 8)
    hal.RCC.PLLCFGR.write(.{
        .PLLM = 12,
        .PLLN = 270,
        .PLLP = @intFromEnum(hal.RCC_PLLCFGR_PLLP.DIV_2),
        .PLLQ = 8,
        .PLLSRC = @intFromEnum(hal.RCC_PLLCFGR_PLLSRC.HSE),
    });

    // Enable power controller
    enablePeripheralsComp(&.{.{ .per = "PWR" }});
    // Regulator voltage scale 1
    hal.PWR.CR1.modify(.{ .VOS = @intFromEnum(hal.PWR_CR1_VOS.SCALE_1) });
    // Enable PLL
    hal.RCC.CR.modify(.{ .PLLON = 1 });
    // Enable Over-drive mode
    hal.PWR.CR1.modify(.{ .ODEN = 1 });
    while (hal.PWR.CSR1.read().ODRDY == 0) {}
    hal.PWR.CR1.modify(.{ .ODSWEN = 1 });
    while (hal.PWR.CSR1.read().ODSWRDY == 0) {}
    // Set flash latency
    // ART enable, prefetch enable, 7 wait states
    hal.FLASH.ACR.write(.{
        .ARTRST = 0,
        .ARTEN = 1,
        .PRFTEN = 1,
        .LATENCY = 7,
    });
    // Set AHB & APB prescalers
    // AHB = 1, APB1 = 4, APB2 = 2
    hal.RCC.CFGR.write(.{
        .SW = @intFromEnum(hal.RCC_CFGR_SW.HSE),
        .HPRE = @intFromEnum(hal.RCC_CFGR_HPRE.DIV_1),
        .PPRE1 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_4),
        .PPRE2 = @intFromEnum(hal.RCC_CFGR_PPRE.DIV_2),
    });

    // Wait for PLL lock
    while (hal.RCC.CR.read().PLLRDY == 0) {}
    // Switch to PLL
    hal.RCC.CFGR.modify(.{ .SW = @intFromEnum(hal.RCC_CFGR_SW.PLL) });
    while (hal.RCC.CFGR.read().SWS != @intFromEnum(hal.RCC_CFGR_SW.PLL)) {}
    // Select peripheral clocks
    hal.RCC.DCKCFGR2.write(.{});
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
    ahb1enr_mask: @TypeOf(hal.RCC.AHB1ENR).underlying_type = .{},
    ahb1enr_val: @TypeOf(hal.RCC.AHB1ENR).underlying_type = .{},
    ahb2enr_mask: @TypeOf(hal.RCC.AHB2ENR).underlying_type = .{},
    ahb2enr_val: @TypeOf(hal.RCC.AHB2ENR).underlying_type = .{},
    ahb3enr_mask: @TypeOf(hal.RCC.AHB3ENR).underlying_type = .{},
    ahb3enr_val: @TypeOf(hal.RCC.AHB3ENR).underlying_type = .{},
    apb1enr_mask: @TypeOf(hal.RCC.APB1ENR).underlying_type = .{},
    apb1enr_val: @TypeOf(hal.RCC.APB1ENR).underlying_type = .{},
    apb2enr_mask: @TypeOf(hal.RCC.APB2ENR).underlying_type = .{},
    apb2enr_val: @TypeOf(hal.RCC.APB2ENR).underlying_type = .{},
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
        @field(hal.RCC, reg_name).modify_masked(mask.*, val.*);
    }
}
