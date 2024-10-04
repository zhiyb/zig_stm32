const std = @import("std");
const hal = @import("stm32f722.zig");

const reg = hal.NVIC;

pub const cfg_t = struct {
    grouping: hal.irq_grouping_t = @enumFromInt(0),
};

pub fn config(comptime cfg: cfg_t) type {
    return struct {
        pub fn init() void {
            hal.SCB.AIRCR.write(.{
                .VECTKEY = 0x05fa,
                .PRIGROUP = @intFromEnum(cfg.grouping),
            });
        }

        pub fn setPriority(comptime irq: hal.irq_t, comptime pri: u8, comptime sub: u8) void {
            const priority = comptime hal.irq_grouping_t.encode(cfg.grouping, pri, sub);
            switch (irq) {
                .MemManage => hal.SCB.SHPR1.modify(.{ .PRI_4 = priority }),
                .BusFault => hal.SCB.SHPR1.modify(.{ .PRI_5 = priority }),
                .UsageFault => hal.SCB.SHPR1.modify(.{ .PRI_6 = priority }),
                .SVC => hal.SCB.SHPR2.modify(.{ .PRI_11 = priority }),
                .DebugMon => hal.SCB.SHPR3.modify(.{ .PRI_12 = priority }),
                .PendSV => hal.SCB.SHPR3.modify(.{ .PRI_14 = priority }),
                .SysTick => hal.SCB.SHPR3.modify(.{ .PRI_15 = priority }),
                else => {
                    const idx = comptime @intFromEnum(irq);
                    if (idx < 0)
                        @compileLog("Un-settable interrupt priority");
                    comptime var ipr: @TypeOf(hal.NVIC.IPR[0]).underlying_type = .{};
                    comptime var ipr_mask: @TypeOf(hal.NVIC.IPR[0]).underlying_type = .{};
                    comptime {
                        const field = std.fmt.comptimePrint("PRI_{}", .{idx % 4});
                        @field(ipr, field) = priority;
                        @field(ipr_mask, field) = 1;
                    }
                    hal.NVIC.IPR[idx / 4].modify_masked(ipr_mask, ipr);
                },
            }
        }

        pub fn enableIrq(irq: hal.irq_t, en: bool) void {
            const nirq = @as(u32, @intCast(@intFromEnum(irq)));
            const mask32 = @as(u32, 1) << @intCast(nirq % 32);
            if (en) {
                reg.ISER[nirq / 32].write(.{ .SETENA = mask32 });
            } else {
                reg.ICER[nirq / 32].write(.{ .CLRENA = mask32 });
            }
        }
    };
}
