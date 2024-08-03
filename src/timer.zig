const hal = @import("stm32f103.zig");

pub const timer_type1_t = struct {
    reg: @TypeOf(hal.REG.TIM1),

    pub fn init(self: timer_type1_t) void {
        const reg = self.reg;
        // Edge counting up
        reg.CR1 = .{
            .ARPE = 0,
            .CMS = @intFromEnum(hal.TIM_CR1_CMS.EDGE),
            .DIR = @intFromEnum(hal.TIM_CR1_DIR.UP),
            .OPM = 0,
            .URS = 0,
            .UDIS = 0,
        };
        reg.CR2 = .{};
        reg.SMCR = .{};
        reg.DIER = .{};
        // Enable CC output 2, 3, 4
        reg.CCMR1.Output = .{
            .CC1S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC1M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC1PE = 0,
            .OC1FE = 0,
            .CC2S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC2M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC2PE = 0,
            .OC2FE = 0,
        };
        reg.CCMR2.Output = .{
            .CC3S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC3M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC3PE = 0,
            .OC3FE = 0,
            .CC4S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC4M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC4PE = 0,
            .OC4FE = 0,
        };
        reg.CCER = .{
            .CC1E = 1,
            .CC1P = 0,
            .CC2E = 1,
            .CC2P = 0,
            .CC3E = 1,
            .CC3P = 0,
            .CC4E = 1,
            .CC4P = 0,
        };
        reg.BDTR.MOE = 1;

        // Timer overflow frequency
        const freq = 480;
        // TIM1 from APB2 @ 72 MHz
        const freq_in = 72_000_000;
        const ratio = @max(1, freq_in / freq / 65536);
        reg.PSC.PSC = ratio - 1;
        reg.ARR.ARR = 65535;

        // Compare values
        reg.CCR1.CCR1 = 16;
        reg.CCR2.CCR2 = 32;
        reg.CCR3.CCR3 = 64;
        reg.CCR4.CCR4 = 128;

        // Enable timer
        reg.CR1.CEN = 1;
    }
};

pub const timer_type2_t = struct {
    reg: @TypeOf(hal.REG.TIM2),

    pub fn init(self: timer_type2_t) void {
        const reg = self.reg;
        // Edge counting up
        reg.CR1 = .{
            .ARPE = 0,
            .CMS = @intFromEnum(hal.TIM_CR1_CMS.EDGE),
            .DIR = @intFromEnum(hal.TIM_CR1_DIR.UP),
            .OPM = 0,
            .URS = 0,
            .UDIS = 0,
        };
        reg.CR2 = .{};
        reg.SMCR = .{};
        reg.DIER = .{};
        // Enable CC output 2, 3, 4
        reg.CCMR1.Output = .{
            .CC1S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC1M = @intFromEnum(hal.TIM_CCMR_OCM.FROZEN),
            .CC2S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC2M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC2PE = 0,
            .OC2FE = 0,
        };
        reg.CCMR2.Output = .{
            .CC3S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC3M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC3PE = 0,
            .OC3FE = 0,
            .CC4S = @intFromEnum(hal.TIM_CCMR_CCS.OUTPUT),
            .OC4M = @intFromEnum(hal.TIM_CCMR_OCM.PWM_1),
            .OC4PE = 0,
            .OC4FE = 0,
        };
        reg.CCER = .{
            .CC1E = 0,
            .CC2E = 1,
            .CC2P = 0,
            .CC3E = 1,
            .CC3P = 0,
            .CC4E = 1,
            .CC4P = 0,
        };

        // Timer overflow frequency
        const freq = 480;
        // TIM2 from APB1 @ 72 MHz
        const freq_in = 72_000_000;
        const ratio = @max(1, freq_in / freq / 65536);
        reg.PSC.PSC = ratio - 1;
        reg.ARR.ARR = 65535;

        // Compare values
        reg.CCR2.CCR2 = 128;
        reg.CCR3.CCR3 = 1024;
        reg.CCR4.CCR4 = 8192;

        // Enable timer
        reg.CR1.CEN = 1;
    }
};

pub const timer1: timer_type1_t = .{ .reg = hal.REG.TIM1 };
pub const timer2: timer_type2_t = .{ .reg = hal.REG.TIM2 };
pub const timer3: timer_type2_t = .{ .reg = hal.REG.TIM3 };
pub const timer4: timer_type2_t = .{ .reg = hal.REG.TIM4 };
