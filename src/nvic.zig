const hal = @import("stm32f103.zig");

const nvic = hal.NVIC;

pub fn enable_irq(irq: hal.IRQ, en: bool) void {
    //const v = @as(u32, @intFromBool(en));
    const mask32 = @as(u32, 1) << @intCast(@intFromEnum(irq) % 32);
    if (@intFromEnum(irq) >= 32) {
        (if (en) nvic.ISER1.SETENA else nvic.ICER1.CLRENA) = mask32;
    } else {
        (if (en) nvic.ISER0.SETENA else nvic.ICER0.CLRENA) = mask32;
    }
}
