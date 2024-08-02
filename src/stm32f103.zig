pub const REG = @import("stm32f103_svd.zig");

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
