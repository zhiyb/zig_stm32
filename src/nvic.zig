const hal = @import("stm32f722.zig");

const reg = hal.NVIC;

pub fn enable_irq(irq: hal.irq_t, en: bool) void {
    const nirq = @as(u32, @intCast(@intFromEnum(irq)));
    const mask32 = @as(u32, 1) << @intCast(nirq % 32);
    if (en) {
        reg.ISER[nirq / 32].write(.{ .SETENA = mask32 });
    } else {
        reg.ICER[nirq / 32].write(.{ .CLRENA = mask32 });
    }
}
