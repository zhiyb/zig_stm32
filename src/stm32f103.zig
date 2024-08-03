pub const svd = @import("stm32f103_svd.zig");
pub const REG = svd;
pub const IRQ = svd.IRQ;

pub const RCC_CFGR_SW = enum(u2) {
    HSI = 0,
    HSE = 1,
    PLL = 2,
};

pub const RCC_CFGR_PLLSRC = enum(u1) {
    HSI_2 = 0,
    HSE = 1,
};

pub const RCC_CFGR_PLLMUL = enum(u4) {
    MUL_2 = 0b0000,
    MUL_3 = 0b0001,
    MUL_4 = 0b0010,
    MUL_5 = 0b0011,
    MUL_6 = 0b0100,
    MUL_7 = 0b0101,
    MUL_8 = 0b0110,
    MUL_9 = 0b0111,
    MUL_10 = 0b1000,
    MUL_11 = 0b1001,
    MUL_12 = 0b1010,
    MUL_13 = 0b1011,
    MUL_14 = 0b1100,
    MUL_15 = 0b1101,
    MUL_16 = 0b1110,
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

pub const FLASH_ACR_LATENCY = enum(u3) {
    WAIT_0 = 0b000,
    WAIT_1 = 0b001,
    WAIT_2 = 0b010,
};

pub const GPIO_CR_CNF = enum(u2) {
    ANALOG_OUTPUT_PP = 0b00,
    FLOATING_OUTPUT_OD = 0b01,
    INPUT_AF_PP = 0b10,
    AF_OD = 0b11,
};

pub const GPIO_CR_MODE = enum(u2) {
    INPUT = 0b00,
    MAX_10MHZ = 0b01,
    MAX_2MHZ = 0b10,
    MAX_50MHZ = 0b11,
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
    INPUT_TI2 = 0b01,
    INPUT_TI1 = 0b10,
    INPUT_TRC = 0b11,
};

pub const TIM_CCMR_OCM = enum(u3) {
    FROZEN = 0b000,
    MATCH_ACT = 0b001,
    MATCH_INACT = 0b010,
    MATCH_TOGGLE = 0b011,
    FORCE_INACT = 0b100,
    FORCE_ACT = 0b101,
    PWM_1 = 0b110,
    PWM_2 = 0b111,
};
