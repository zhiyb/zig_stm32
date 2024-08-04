const std = @import("std");
const root = @import("root");
const hal = @import("stm32f103.zig");
const systick = @import("systick.zig");
const timer = @import("timer.zig");

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
        \\      .word WWDG_IRQHandler
        \\      .word PVD_IRQHandler
        \\      .word TAMPER_IRQHandler
        \\      .word RTC_IRQHandler
        \\      .word FLASH_IRQHandler
        \\      .word RCC_IRQHandler
        \\      .word EXTI0_IRQHandler
        \\      .word EXTI1_IRQHandler
        \\      .word EXTI2_IRQHandler
        \\      .word EXTI3_IRQHandler
        \\      .word EXTI4_IRQHandler
        \\      .word DMA1_Channel1_IRQHandler
        \\      .word DMA1_Channel2_IRQHandler
        \\      .word DMA1_Channel3_IRQHandler
        \\      .word DMA1_Channel4_IRQHandler
        \\      .word DMA1_Channel5_IRQHandler
        \\      .word DMA1_Channel6_IRQHandler
        \\      .word DMA1_Channel7_IRQHandler
        \\      .word ADC1_2_IRQHandler
        \\      .word USB_HP_CAN1_TX_IRQHandler
        \\      .word USB_LP_CAN1_RX0_IRQHandler
        \\      .word CAN1_RX1_IRQHandler
        \\      .word CAN1_SCE_IRQHandler
        \\      .word EXTI9_5_IRQHandler
        \\      .word TIM1_BRK_IRQHandler
        \\      .word TIM1_UP_IRQHandler
        \\      .word TIM1_TRG_COM_IRQHandler
        \\      .word TIM1_CC_IRQHandler
        \\      .word TIM2_IRQHandler
        \\      .word TIM3_IRQHandler
        \\      .word TIM4_IRQHandler
        \\      .word I2C1_EV_IRQHandler
        \\      .word I2C1_ER_IRQHandler
        \\      .word I2C2_EV_IRQHandler
        \\      .word I2C2_ER_IRQHandler
        \\      .word SPI1_IRQHandler
        \\      .word SPI2_IRQHandler
        \\      .word USART1_IRQHandler
        \\      .word USART2_IRQHandler
        \\      .word USART3_IRQHandler
        \\      .word EXTI15_10_IRQHandler
        \\      .word RTC_Alarm_IRQHandler
        \\      .word USBWakeUp_IRQHandler
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
    @export(default_irq, .{ .name = "WWDG_IRQHandler" });
    @export(default_irq, .{ .name = "PVD_IRQHandler" });
    @export(default_irq, .{ .name = "TAMPER_IRQHandler" });
    @export(default_irq, .{ .name = "RTC_IRQHandler" });
    @export(default_irq, .{ .name = "FLASH_IRQHandler" });
    @export(default_irq, .{ .name = "RCC_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI0_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI1_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI2_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI3_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI4_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel1_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel2_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel3_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel4_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel5_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel6_IRQHandler" });
    @export(default_irq, .{ .name = "DMA1_Channel7_IRQHandler" });
    @export(default_irq, .{ .name = "ADC1_2_IRQHandler" });
    @export(default_irq, .{ .name = "USB_HP_CAN1_TX_IRQHandler" });
    @export(default_irq, .{ .name = "USB_LP_CAN1_RX0_IRQHandler" });
    @export(default_irq, .{ .name = "CAN1_RX1_IRQHandler" });
    @export(default_irq, .{ .name = "CAN1_SCE_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI9_5_IRQHandler" });
    @export(default_irq, .{ .name = "TIM1_BRK_IRQHandler" });
    @export(default_irq, .{ .name = "TIM1_UP_IRQHandler" });
    @export(default_irq, .{ .name = "TIM1_TRG_COM_IRQHandler" });
    @export(default_irq, .{ .name = "TIM1_CC_IRQHandler" });
    @export(timer.timer2_irq, .{ .name = "TIM2_IRQHandler" });
    @export(timer.timer3_irq, .{ .name = "TIM3_IRQHandler" });
    @export(timer.timer4_irq, .{ .name = "TIM4_IRQHandler" });
    @export(default_irq, .{ .name = "I2C1_EV_IRQHandler" });
    @export(default_irq, .{ .name = "I2C1_ER_IRQHandler" });
    @export(default_irq, .{ .name = "I2C2_EV_IRQHandler" });
    @export(default_irq, .{ .name = "I2C2_ER_IRQHandler" });
    @export(default_irq, .{ .name = "SPI1_IRQHandler" });
    @export(default_irq, .{ .name = "SPI2_IRQHandler" });
    @export(default_irq, .{ .name = "USART1_IRQHandler" });
    @export(default_irq, .{ .name = "USART2_IRQHandler" });
    @export(default_irq, .{ .name = "USART3_IRQHandler" });
    @export(default_irq, .{ .name = "EXTI15_10_IRQHandler" });
    @export(default_irq, .{ .name = "RTC_Alarm_IRQHandler" });
    @export(default_irq, .{ .name = "USBWakeUp_IRQHandler" });

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
    default_irq();
}

fn default_irq() callconv(.C) noreturn {
    std.debug.panic("unhandled interrupt", .{});
}
