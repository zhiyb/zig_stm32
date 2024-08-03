const root = @import("root");
const hal = @import("stm32f103.zig");
const systick = @import("systick.zig");

comptime {
    // Interrupt vector table
    asm (
        \\      .section .isr_vector,"a",%progbits
        \\      .type g_pfnVectors, %object
        \\  g_pfnVectors:
        \\      .word __stack_end
        \\      .word Reset_Handler
        \\      .word NMI_Handler
        \\      .word HardFault_Handler
        \\      .word MemManage_Handler
        \\      .word BusFault_Handler
        \\      .word UsageFault_Handler
        \\      .word 0
        \\      .word 0
        \\      .word 0
        \\      .word 0
        \\      .word SVC_Handler
        \\      .word DebugMon_Handler
        \\      .word 0
        \\      .word PendSV_Handler
        \\      .word SysTick_Handler
        \\      .size g_pfnVectors, .-g_pfnVectors
    );

    // Interrupt handlers
    @export(default_irq, .{ .name = "NMI_Handler" });
    @export(default_irq, .{ .name = "HardFault_Handler" });
    @export(default_irq, .{ .name = "MemManage_Handler" });
    @export(default_irq, .{ .name = "BusFault_Handler" });
    @export(default_irq, .{ .name = "UsageFault_Handler" });
    @export(default_irq, .{ .name = "SVC_Handler" });
    @export(default_irq, .{ .name = "DebugMon_Handler" });
    @export(default_irq, .{ .name = "PendSV_Handler" });
    @export(systick.irq, .{ .name = "SysTick_Handler" });

    // Startup entry function
    @export(_main, .{ .name = "_main" });

    asm (
        \\      .section .text.Reset_Handler,"ax",%progbits
        \\      .weak Reset_Handler
        \\      .type Reset_Handler, %function
        \\  Reset_Handler:
        \\      ldr sp, =__stack_end
        \\      bl _main
        \\      bkpt #0
        \\      b Reset_Handler
        \\      .size Reset_Handler, .-Reset_Handler
    );
}

extern var __bss_start: u32;
extern var __bss_end: u32;

extern var __data_load: u32;
extern var __data_start: u32;
extern var __data_end: u32;

fn _main() callconv(.C) noreturn {
    const bss = @as([*]u32, @ptrCast(&__bss_start))[0 .. &__bss_end - &__bss_start];
    @memset(bss, 0);
    const data = @as([*]u32, @ptrCast(&__data_start))[0 .. &__data_end - &__data_start];
    @memcpy(data, @as([*]u32, @ptrCast(&__data_load)));
    root.main();
    @breakpoint();
}

fn default_irq() callconv(.C) noreturn {
    while (true)
        if (hal.REG.SCB.SHCRS.MONITORACT != 0)
            @breakpoint();
}
