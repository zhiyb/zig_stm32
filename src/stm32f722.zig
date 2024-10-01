const std = @import("std");
const mmio = @import("mmio.zig");
const start = @import("start.zig");
pub usingnamespace @import("stm32f722_svd.zig");

comptime {
    // Interrupt vector table
    asm (
        \\      .section .isr_vector,"a",%progbits
        \\      .type g_pfnVectors, %object
        \\  g_pfnVectors:
        \\      .word __stack_end
        \\      .word Reset_Handler
        \\
        \\      .word NMI_IRQHandler
        \\      .word HardFault_IRQHandler
        \\      .word MemManage_IRQHandler
        \\      .word BusFault_IRQHandler
        \\      .word UsageFault_IRQHandler
        \\      .word 0
        \\      .word 0
        \\      .word 0
        \\      .word 0
        \\      .word SVC_IRQHandler
        \\      .word DebugMon_IRQHandler
        \\      .word 0
        \\      .word PendSV_IRQHandler
        \\      .word SysTick_IRQHandler
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
        \\      .word     RTC_ALARM_IRQHandler              /* RTC Alarm (A and B) through EXTI Line */
        \\      .word     OTG_FS_WKUP_IRQHandler            /* USB OTG FS Wakeup through EXTI line */
        \\      .word     TIM8_BRK_TIM12_IRQHandler         /* TIM8 Break and TIM12         */
        \\      .word     TIM8_UP_TIM13_IRQHandler          /* TIM8 Update and TIM13        */
        \\      .word     TIM8_TRG_COM_TIM14_IRQHandler     /* TIM8 Trigger and Commutation and TIM14 */
        \\      .word     TIM8_CC_IRQHandler                /* TIM8 Capture Compare         */
        \\      .word     DMA1_Stream7_IRQHandler           /* DMA1 Stream7                 */
        \\      .word     FSMC_IRQHandler                   /* FMC                          */
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
        \\      .word     QuadSPI_IRQHandler                /* QUADSPI                      */
        \\      .word     LP_Timer1_IRQHandler              /* LPTIM1                       */
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

    asm (
        \\      .section .text.Reset_Handler,"ax",%progbits
        \\      .weak Reset_Handler
        \\      .type Reset_Handler, %function
        \\  Reset_Handler:
        \\      ldr sp, =__stack_end
        \\      bl _entry
        \\      b Reset_Handler
        \\      .size Reset_Handler, .-Reset_Handler
    );
}

pub const irq_t = @Type(std.builtin.Type{ .@"enum" = .{
    .is_exhaustive = true,
    .tag_type = i32,
    .decls = &.{},
    .fields = @typeInfo(@This().IRQ).@"enum".fields ++ .{
        .{ .name = "NMI", .value = -14 },
        .{ .name = "HardFault", .value = -13 },
        .{ .name = "MemManage", .value = -12 },
        .{ .name = "BusFault", .value = -11 },
        .{ .name = "UsageFault", .value = -10 },
        .{ .name = "SVC", .value = -5 },
        .{ .name = "DebugMon", .value = -4 },
        .{ .name = "PendSV", .value = -2 },
        .{ .name = "SysTick", .value = -1 },
    },
} });

pub fn createIrqVect(comptime vect_list: anytype) void {
    @export(&start.entry, .{ .name = "_entry" });
    inline for (@typeInfo(irq_t).@"enum".fields) |field| {
        const func = if (@hasField(@TypeOf(vect_list), field.name))
            @field(vect_list, field.name)
        else
            &start.default_irq;
        @export(func, .{ .name = field.name ++ "_IRQHandler" });
    }
}

pub const CoreDebug: *volatile extern struct {
    DHCSR: mmio.Mmio(packed struct {
        C_DEBUGEN: u1,
        C_HALT: u1,
        C_STEP: u1,
        C_MASKINTS: u1,
        _RESERVED0: u1,
        C_SNAPSTALL: u1,
        _RESERVED1: u10,
        DEBUG: packed union {
            S: packed struct {
                S_REGRDY: u1,
                S_HALT: u1,
                S_SLEEP: u1,
                S_LOCKUP: u1,
                _RESERVED2: u4,
                S_RETIRE_ST: u1,
                S_RESET_ST: u1,
                _RESERVED3: u6,
            },
            DBGKEY: u16,
        },
    }),

    DCRSR: mmio.Mmio(packed struct {
        _RESERVED0: u32,
    }),

    DCRDR: mmio.Mmio(packed struct {
        _RESERVED0: u32,
    }),

    DEMCR: mmio.Mmio(packed struct {
        _RESERVED0: u32,
    }),
} = @ptrFromInt(0xE000EDF0);

pub const SYST: *volatile extern struct {
    CSR: mmio.Mmio(packed struct {
        ENABLE: u1 = 0,
        TICKINT: u1 = 0,
        CLKSOURCE: u1 = 0,
        _RESERVED0: u13 = 0,
        COUNTFLAG: u1 = 0,
        _RESERVED1: u15 = 0,
    }),

    RVR: mmio.Mmio(packed struct {
        RELOAD: u24 = 0,
        _RESERVED0: u8 = 0,
    }),

    CVR: mmio.Mmio(packed struct {
        CURRENT: u24 = 0,
        _RESERVED0: u8 = 0,
    }),

    CALIB: mmio.Mmio(packed struct {
        TENMS: u24 = 0,
        _RESERVED0: u6 = 0,
        SKEW: u1 = 0,
        NOREF: u1 = 0,
    }),
} = @ptrFromInt(0xE000E010);

pub const NVIC: *volatile extern struct {
    ISER: [8]mmio.Mmio(packed struct {
        SETENA: u32 = 0,
    }),
    _RESERVED0: [96]u8,
    ICER: [8]mmio.Mmio(packed struct {
        CLRENA: u32 = 0,
    }),
    _RESERVED1: [96]u8,
    ISPR: [8]mmio.Mmio(packed struct {
        SETPEND: u32 = 0,
    }),
    _RESERVED2: [96]u8,
    ICPR: [8]mmio.Mmio(packed struct {
        CLRPEND: u32 = 0,
    }),
    _RESERVED3: [96]u8,
    IABR: [8]mmio.Mmio(packed struct {
        ACTIVE: u32 = 0,
    }),
    _RESERVED4: [224]u8,
    IPR: [60]mmio.Mmio(packed struct {
        PRI_0: u8,
        PRI_1: u8,
        PRI_2: u8,
        PRI_3: u8,
    }),
    _RESERVED5: [2576]u8,
    STIR: mmio.Mmio(packed struct {
        INTID: u9 = 0,
        _RESERVED0: u23 = 0,
    }),
} = @ptrFromInt(0xE000E100);

pub const PWR_CR1_VOS = enum(u2) {
    SCALE_3 = 0b01,
    SCALE_2 = 0b10,
    SCALE_1 = 0b11,
};

pub const RCC_CFGR_SW = enum(u2) {
    HSI = 0,
    HSE = 1,
    PLL = 2,
};

pub const RCC_CFGR_HPRE = enum(u4) {
    DIV_1 = 0b0000,
    DIV_2 = 0b1000,
    DIV_4 = 0b1001,
    DIV_8 = 0b1010,
    DIV_16 = 0b1011,
    DIV_64 = 0b1100,
    DIV_128 = 0b1101,
    DIV_256 = 0b1110,
    DIV_512 = 0b1111,
};

pub const RCC_CFGR_PPRE = enum(u3) {
    DIV_1 = 0b000,
    DIV_2 = 0b100,
    DIV_4 = 0b101,
    DIV_8 = 0b110,
    DIV_16 = 0b111,
};

pub const RCC_PLLCFGR_PLLSRC = enum(u1) {
    HSI = 0,
    HSE = 1,
};

pub const RCC_PLLCFGR_PLLP = enum(u2) {
    DIV_2 = 0b00,
    DIV_4 = 0b01,
    DIV_6 = 0b10,
    DIV_8 = 0b11,
};

pub const GPIO_MODER = enum(u2) {
    INPUT = 0b00,
    OUTPUT = 0b01,
    ALTERNATE_FUNCTION = 0b10,
    ANALOG = 0b11,
};

pub const GPIO_OTYPER = enum(u1) {
    PUSH_PULL = 0,
    OPEN_DRAIN = 1,
};

pub const GPIO_OSPEEDR = enum(u2) {
    LOW = 0b00,
    MEDIUM = 0b01,
    HIGH = 0b10,
    VERY_HIGH = 0b11,
};

pub const GPIO_PUPDR = enum(u2) {
    PULL_NONE = 0b00,
    PULL_UP = 0b01,
    PULL_DOWN = 0b10,
};

pub const TIM_CR1_CKD = enum(u2) {
    DIV1 = 0b00,
    DIV2 = 0b01,
    DIV4 = 0b10,
};

pub const TIM_CR1_CMS = enum(u2) {
    EDGE = 0b00,
    CENTER_DOWN = 0b01, // CC set when counter counting down
    CENTER_UP = 0b10, // CC set when counter counting up
    CENTER_BOTH = 0b11, // CC set when counter counting up or down
};

pub const TIM_CR1_DIR = enum(u1) {
    UP = 0,
    DOWN = 1,
};

pub const TIM_CCMR_CCS = enum(u2) {
    OUTPUT = 0b00,
    INPUT_SAME = 0b01, // Same input channel
    INPUT_COMP = 0b10, // Complementary input channel
    INPUT_TRC = 0b11,
};

pub const TIM_CCMR_OCM = enum(u4) {
    FROZEN = 0b0000,
    MATCH_ACT = 0b0001,
    MATCH_INACT = 0b0010,
    MATCH_TOGGLE = 0b0011,
    FORCE_INACT = 0b0100,
    FORCE_ACT = 0b0101,
    PWM_1 = 0b0110,
    PWM_2 = 0b0111,
    RETRIG_OPM_1 = 0b1000,
    RETRIG_OPM_2 = 0b1001,
    COMBINED_PWM_1 = 0b1100,
    COMBINED_PWM_2 = 0b1101,
    ASYM_PWM_1 = 0b1110,
    ASYM_PWM_2 = 0b1111,
};

pub const TIM_CCMR_IC_F = enum(u4) {
    DTS_DIV1_N1 = 0b0000,
    INT_N2 = 0b0001,
    INT_N4 = 0b0010,
    INT_N8 = 0b0011,
    DTS_DIV2_N6 = 0b0100,
    DTS_DIV2_N8 = 0b0101,
    DTS_DIV4_N6 = 0b0110,
    DTS_DIV4_N8 = 0b0111,
    DTS_DIV8_N6 = 0b1000,
    DTS_DIV8_N8 = 0b1001,
    DTS_DIV16_N5 = 0b1010,
    DTS_DIV16_N6 = 0b1011,
    DTS_DIV16_N8 = 0b1100,
    DTS_DIV32_N5 = 0b1101,
    DTS_DIV32_N6 = 0b1110,
    DTS_DIV32_N8 = 0b1111,
};

pub const TIM_CCMR_IC_PSC = enum(u2) {
    DIV1 = 0b00,
    DIV2 = 0b01,
    DIV4 = 0b10,
    DIV8 = 0b11,
};

pub fn dbgEn() bool {
    return CoreDebug.DHCSR.read().C_DEBUGEN != 0;
}
