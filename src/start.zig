const std = @import("std");
const root = @import("root");
const hal = @import("stm32f722.zig");
const systick = @import("systick.zig");
// const timer = @import("timer.zig");

comptime {
    // Interrupt vector table
    asm (
        \\      .section .isr_vector,"a",%progbits
        \\      .type g_pfnVectors, %object
        \\  g_pfnVectors:
        \\      .word __stack_end
        \\      .word Reset_Handler
        \\
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
        \\
        \\      /* External Interrupts */
        \\      .word     WWDG_IRQHandler                   /* Window WatchDog              */
        \\      .word     PVD_IRQHandler                    /* PVD through EXTI Line detection */
        \\      .word     TAMP_STAMP_IRQHandler             /* Tamper and TimeStamps through the EXTI line */
        \\      .word     RTC_WKUP_IRQHandler               /* RTC Wakeup through the EXTI line */
        \\      .word     FLASH_IRQHandler                  /* FLASH                        */
        \\      .word     RCC_IRQHandler                    /* RCC                          */
        \\      .word     EXTI0_IRQHandler                  /* EXTI Line0                   */
        \\      .word     EXTI1_IRQHandler                  /* EXTI Line1                   */
        \\      .word     EXTI2_IRQHandler                  /* EXTI Line2                   */
        \\      .word     EXTI3_IRQHandler                  /* EXTI Line3                   */
        \\      .word     EXTI4_IRQHandler                  /* EXTI Line4                   */
        \\      .word     DMA1_Stream0_IRQHandler           /* DMA1 Stream 0                */
        \\      .word     DMA1_Stream1_IRQHandler           /* DMA1 Stream 1                */
        \\      .word     DMA1_Stream2_IRQHandler           /* DMA1 Stream 2                */
        \\      .word     DMA1_Stream3_IRQHandler           /* DMA1 Stream 3                */
        \\      .word     DMA1_Stream4_IRQHandler           /* DMA1 Stream 4                */
        \\      .word     DMA1_Stream5_IRQHandler           /* DMA1 Stream 5                */
        \\      .word     DMA1_Stream6_IRQHandler           /* DMA1 Stream 6                */
        \\      .word     ADC_IRQHandler                    /* ADC1, ADC2 and ADC3s         */
        \\      .word     CAN1_TX_IRQHandler                /* CAN1 TX                      */
        \\      .word     CAN1_RX0_IRQHandler               /* CAN1 RX0                     */
        \\      .word     CAN1_RX1_IRQHandler               /* CAN1 RX1                     */
        \\      .word     CAN1_SCE_IRQHandler               /* CAN1 SCE                     */
        \\      .word     EXTI9_5_IRQHandler                /* External Line[9:5]s          */
        \\      .word     TIM1_BRK_TIM9_IRQHandler          /* TIM1 Break and TIM9          */
        \\      .word     TIM1_UP_TIM10_IRQHandler          /* TIM1 Update and TIM10        */
        \\      .word     TIM1_TRG_COM_TIM11_IRQHandler     /* TIM1 Trigger and Commutation and TIM11 */
        \\      .word     TIM1_CC_IRQHandler                /* TIM1 Capture Compare         */
        \\      .word     TIM2_IRQHandler                   /* TIM2                         */
        \\      .word     TIM3_IRQHandler                   /* TIM3                         */
        \\      .word     TIM4_IRQHandler                   /* TIM4                         */
        \\      .word     I2C1_EV_IRQHandler                /* I2C1 Event                   */
        \\      .word     I2C1_ER_IRQHandler                /* I2C1 Error                   */
        \\      .word     I2C2_EV_IRQHandler                /* I2C2 Event                   */
        \\      .word     I2C2_ER_IRQHandler                /* I2C2 Error                   */
        \\      .word     SPI1_IRQHandler                   /* SPI1                         */
        \\      .word     SPI2_IRQHandler                   /* SPI2                         */
        \\      .word     USART1_IRQHandler                 /* USART1                       */
        \\      .word     USART2_IRQHandler                 /* USART2                       */
        \\      .word     USART3_IRQHandler                 /* USART3                       */
        \\      .word     EXTI15_10_IRQHandler              /* External Line[15:10]s        */
        \\      .word     RTC_Alarm_IRQHandler              /* RTC Alarm (A and B) through EXTI Line */
        \\      .word     OTG_FS_WKUP_IRQHandler            /* USB OTG FS Wakeup through EXTI line */
        \\      .word     TIM8_BRK_TIM12_IRQHandler         /* TIM8 Break and TIM12         */
        \\      .word     TIM8_UP_TIM13_IRQHandler          /* TIM8 Update and TIM13        */
        \\      .word     TIM8_TRG_COM_TIM14_IRQHandler     /* TIM8 Trigger and Commutation and TIM14 */
        \\      .word     TIM8_CC_IRQHandler                /* TIM8 Capture Compare         */
        \\      .word     DMA1_Stream7_IRQHandler           /* DMA1 Stream7                 */
        \\      .word     FMC_IRQHandler                    /* FMC                          */
        \\      .word     SDMMC1_IRQHandler                 /* SDMMC1                       */
        \\      .word     TIM5_IRQHandler                   /* TIM5                         */
        \\      .word     SPI3_IRQHandler                   /* SPI3                         */
        \\      .word     UART4_IRQHandler                  /* UART4                        */
        \\      .word     UART5_IRQHandler                  /* UART5                        */
        \\      .word     TIM6_DAC_IRQHandler               /* TIM6 and DAC1&2 underrun errors */
        \\      .word     TIM7_IRQHandler                   /* TIM7                         */
        \\      .word     DMA2_Stream0_IRQHandler           /* DMA2 Stream 0                */
        \\      .word     DMA2_Stream1_IRQHandler           /* DMA2 Stream 1                */
        \\      .word     DMA2_Stream2_IRQHandler           /* DMA2 Stream 2                */
        \\      .word     DMA2_Stream3_IRQHandler           /* DMA2 Stream 3                */
        \\      .word     DMA2_Stream4_IRQHandler           /* DMA2 Stream 4                */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     OTG_FS_IRQHandler                 /* USB OTG FS                   */
        \\      .word     DMA2_Stream5_IRQHandler           /* DMA2 Stream 5                */
        \\      .word     DMA2_Stream6_IRQHandler           /* DMA2 Stream 6                */
        \\      .word     DMA2_Stream7_IRQHandler           /* DMA2 Stream 7                */
        \\      .word     USART6_IRQHandler                 /* USART6                       */
        \\      .word     I2C3_EV_IRQHandler                /* I2C3 event                   */
        \\      .word     I2C3_ER_IRQHandler                /* I2C3 error                   */
        \\      .word     OTG_HS_EP1_OUT_IRQHandler         /* USB OTG HS End Point 1 Out   */
        \\      .word     OTG_HS_EP1_IN_IRQHandler          /* USB OTG HS End Point 1 In    */
        \\      .word     OTG_HS_WKUP_IRQHandler            /* USB OTG HS Wakeup through EXTI */
        \\      .word     OTG_HS_IRQHandler                 /* USB OTG HS                   */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     RNG_IRQHandler                    /* RNG                          */
        \\      .word     FPU_IRQHandler                    /* FPU                          */
        \\      .word     UART7_IRQHandler                  /* UART7                        */
        \\      .word     UART8_IRQHandler                  /* UART8                        */
        \\      .word     SPI4_IRQHandler                   /* SPI4                         */
        \\      .word     SPI5_IRQHandler                   /* SPI5                         */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     SAI1_IRQHandler                   /* SAI1                         */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     SAI2_IRQHandler                   /* SAI2                         */
        \\      .word     QUADSPI_IRQHandler                /* QUADSPI                      */
        \\      .word     LPTIM1_IRQHandler                 /* LPTIM1                       */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     0                                 /* Reserved                     */
        \\      .word     SDMMC2_IRQHandler                 /* SDMMC2                       */
        \\      .size g_pfnVectors, .-g_pfnVectors
    );

    // Interrupt handlers
    @export(&default_irq, .{ .name = "NMI_Handler" });
    @export(&default_irq, .{ .name = "HardFault_Handler" });
    @export(&default_irq, .{ .name = "MemManage_Handler" });
    @export(&default_irq, .{ .name = "BusFault_Handler" });
    @export(&default_irq, .{ .name = "UsageFault_Handler" });
    @export(&default_irq, .{ .name = "SVC_Handler" });
    @export(&default_irq, .{ .name = "DebugMon_Handler" });
    @export(&default_irq, .{ .name = "PendSV_Handler" });
    @export(&systick.irq, .{ .name = "SysTick_Handler" });
    @export(&default_irq, .{ .name = "WWDG_IRQHandler" });
    @export(&default_irq, .{ .name = "PVD_IRQHandler" });
    @export(&default_irq, .{ .name = "TAMP_STAMP_IRQHandler" });
    @export(&default_irq, .{ .name = "RTC_WKUP_IRQHandler" });
    @export(&default_irq, .{ .name = "FLASH_IRQHandler" });
    @export(&default_irq, .{ .name = "RCC_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI0_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI1_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI2_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI3_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI4_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream0_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream1_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream2_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream3_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream4_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream5_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream6_IRQHandler" });
    @export(&default_irq, .{ .name = "ADC_IRQHandler" });
    @export(&default_irq, .{ .name = "CAN1_TX_IRQHandler" });
    @export(&default_irq, .{ .name = "CAN1_RX0_IRQHandler" });
    @export(&default_irq, .{ .name = "CAN1_RX1_IRQHandler" });
    @export(&default_irq, .{ .name = "CAN1_SCE_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI9_5_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM1_BRK_TIM9_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM1_UP_TIM10_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM1_TRG_COM_TIM11_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM1_CC_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM2_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM3_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM4_IRQHandler" });
    @export(&default_irq, .{ .name = "I2C1_EV_IRQHandler" });
    @export(&default_irq, .{ .name = "I2C1_ER_IRQHandler" });
    @export(&default_irq, .{ .name = "I2C2_EV_IRQHandler" });
    @export(&default_irq, .{ .name = "I2C2_ER_IRQHandler" });
    @export(&default_irq, .{ .name = "SPI1_IRQHandler" });
    @export(&default_irq, .{ .name = "SPI2_IRQHandler" });
    @export(&default_irq, .{ .name = "USART1_IRQHandler" });
    @export(&default_irq, .{ .name = "USART2_IRQHandler" });
    @export(&default_irq, .{ .name = "USART3_IRQHandler" });
    @export(&default_irq, .{ .name = "EXTI15_10_IRQHandler" });
    @export(&default_irq, .{ .name = "RTC_Alarm_IRQHandler" });
    @export(&default_irq, .{ .name = "OTG_FS_WKUP_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM8_BRK_TIM12_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM8_UP_TIM13_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM8_TRG_COM_TIM14_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM8_CC_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA1_Stream7_IRQHandler" });
    @export(&default_irq, .{ .name = "FMC_IRQHandler" });
    @export(&default_irq, .{ .name = "SDMMC1_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM5_IRQHandler" });
    @export(&default_irq, .{ .name = "SPI3_IRQHandler" });
    @export(&default_irq, .{ .name = "UART4_IRQHandler" });
    @export(&default_irq, .{ .name = "UART5_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM6_DAC_IRQHandler" });
    @export(&default_irq, .{ .name = "TIM7_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream0_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream1_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream2_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream3_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream4_IRQHandler" });
    @export(&default_irq, .{ .name = "OTG_FS_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream5_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream6_IRQHandler" });
    @export(&default_irq, .{ .name = "DMA2_Stream7_IRQHandler" });
    @export(&default_irq, .{ .name = "USART6_IRQHandler" });
    @export(&default_irq, .{ .name = "I2C3_EV_IRQHandler" });
    @export(&default_irq, .{ .name = "I2C3_ER_IRQHandler" });
    @export(&default_irq, .{ .name = "OTG_HS_EP1_OUT_IRQHandler" });
    @export(&default_irq, .{ .name = "OTG_HS_EP1_IN_IRQHandler" });
    @export(&default_irq, .{ .name = "OTG_HS_WKUP_IRQHandler" });
    @export(&default_irq, .{ .name = "OTG_HS_IRQHandler" });
    @export(&default_irq, .{ .name = "RNG_IRQHandler" });
    @export(&default_irq, .{ .name = "FPU_IRQHandler" });
    @export(&default_irq, .{ .name = "UART7_IRQHandler" });
    @export(&default_irq, .{ .name = "UART8_IRQHandler" });
    @export(&default_irq, .{ .name = "SPI4_IRQHandler" });
    @export(&default_irq, .{ .name = "SPI5_IRQHandler" });
    @export(&default_irq, .{ .name = "SAI1_IRQHandler" });
    @export(&default_irq, .{ .name = "SAI2_IRQHandler" });
    @export(&default_irq, .{ .name = "QUADSPI_IRQHandler" });
    @export(&default_irq, .{ .name = "LPTIM1_IRQHandler" });
    @export(&default_irq, .{ .name = "SDMMC2_IRQHandler" });

    // Startup entry function
    @export(&_main, .{ .name = "_main" });

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
