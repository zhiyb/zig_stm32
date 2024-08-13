const std = @import("std");

// Common helper functions
pub inline fn set_masked(self: anytype, mask: @TypeOf(self.*), val: @TypeOf(self.*)) void {
    if (!std.meta.eql(mask, .{}))
        self.* = @bitCast((@as(u32, @bitCast(self.*)) &
            ~@as(u32, @bitCast(mask))) | @as(u32, @bitCast(val)));
}

// Peripherals
pub const TIM1: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        DIR: u1 = 0,
        CMS: u2 = 0,
        ARPE: u1 = 0,
        CKD: u2 = 0,
        _0: u1 = 0,
        UIFREMAP: u1 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        CCPC: u1 = 0,
        _0: u1 = 0,
        CCUS: u1 = 0,
        CCDS: u1 = 0,
        MMS: u3 = 0,
        TI1S: u1 = 0,
        OIS1: u1 = 0,
        OIS1N: u1 = 0,
        OIS2: u1 = 0,
        OIS2N: u1 = 0,
        OIS3: u1 = 0,
        OIS3N: u1 = 0,
        OIS4: u1 = 0,
        _1: u1 = 0,
        OIS5: u1 = 0,
        _2: u1 = 0,
        OIS6: u1 = 0,
        _3: u1 = 0,
        MMS2: u4 = 0,
        _4: u8 = 0,

        pub const set = set_masked;
    },

    SMCR: packed struct {
        SMS: u3 = 0,
        _0: u1 = 0,
        TS: u3 = 0,
        MSM: u1 = 0,
        ETF: u4 = 0,
        ETPS: u2 = 0,
        ECE: u1 = 0,
        ETP: u1 = 0,
        SMS_3: u1 = 0,
        _1: u15 = 0,

        pub const set = set_masked;
    },

    DIER: packed struct {
        UIE: u1 = 0,
        CC1IE: u1 = 0,
        CC2IE: u1 = 0,
        CC3IE: u1 = 0,
        CC4IE: u1 = 0,
        COMIE: u1 = 0,
        TIE: u1 = 0,
        BIE: u1 = 0,
        UDE: u1 = 0,
        CC1DE: u1 = 0,
        CC2DE: u1 = 0,
        CC3DE: u1 = 0,
        CC4DE: u1 = 0,
        COMDE: u1 = 0,
        TDE: u1 = 0,
        _0: u17 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        CC1IF: u1 = 0,
        CC2IF: u1 = 0,
        CC3IF: u1 = 0,
        CC4IF: u1 = 0,
        COMIF: u1 = 0,
        TIF: u1 = 0,
        BIF: u1 = 0,
        B2IF: u1 = 0,
        CC1OF: u1 = 0,
        CC2OF: u1 = 0,
        CC3OF: u1 = 0,
        CC4OF: u1 = 0,
        _0: u19 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        CC1G: u1 = 0,
        CC2G: u1 = 0,
        CC3G: u1 = 0,
        CC4G: u1 = 0,
        COMG: u1 = 0,
        TG: u1 = 0,
        BG: u1 = 0,
        B2G: u1 = 0,
        _0: u23 = 0,

        pub const set = set_masked;
    },

    CCMR1: packed union {
        Output: packed struct {
            CC1S: u2 = 0,
            OC1FE: u1 = 0,
            OC1PE: u1 = 0,
            OC1M: u3 = 0,
            OC1CE: u1 = 0,
            CC2S: u2 = 0,
            OC2FE: u1 = 0,
            OC2PE: u1 = 0,
            OC2M: u3 = 0,
            OC2CE: u1 = 0,
            OC1M_3: u1 = 0,
            _0: u7 = 0,
            OC2M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC1S: u2 = 0,
            ICPCS: u2 = 0,
            IC1F: u4 = 0,
            CC2S: u2 = 0,
            IC2PCS: u2 = 0,
            IC2F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCMR2: packed union {
        Output: packed struct {
            CC3S: u2 = 0,
            OC3FE: u1 = 0,
            OC3PE: u1 = 0,
            OC3M: u3 = 0,
            OC3CE: u1 = 0,
            CC4S: u2 = 0,
            OC4FE: u1 = 0,
            OC4PE: u1 = 0,
            OC4M: u3 = 0,
            OC4CE: u1 = 0,
            OC3M_3: u1 = 0,
            _0: u7 = 0,
            OC4M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC3S: u2 = 0,
            IC3PSC: u2 = 0,
            IC3F: u4 = 0,
            CC4S: u2 = 0,
            IC4PSC: u2 = 0,
            IC4F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCER: packed struct {
        CC1E: u1 = 0,
        CC1P: u1 = 0,
        CC1NE: u1 = 0,
        CC1NP: u1 = 0,
        CC2E: u1 = 0,
        CC2P: u1 = 0,
        CC2NE: u1 = 0,
        CC2NP: u1 = 0,
        CC3E: u1 = 0,
        CC3P: u1 = 0,
        CC3NE: u1 = 0,
        CC3NP: u1 = 0,
        CC4E: u1 = 0,
        CC4P: u1 = 0,
        _0: u1 = 0,
        CC4NP: u1 = 0,
        CC5E: u1 = 0,
        CC5P: u1 = 0,
        _1: u2 = 0,
        CC6E: u1 = 0,
        CC6P: u1 = 0,
        _2: u10 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT: u16 = 0,
        _0: u15 = 0,
        UIFCPY: u1 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    RCR: packed struct {
        REP: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    CCR1: packed struct {
        CCR1: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CCR2: packed struct {
        CCR2: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CCR3: packed struct {
        CCR3: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CCR4: packed struct {
        CCR4: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    BDTR: packed struct {
        DTG: u8 = 0,
        LOCK: u2 = 0,
        OSSI: u1 = 0,
        OSSR: u1 = 0,
        BKE: u1 = 0,
        BKP: u1 = 0,
        AOE: u1 = 0,
        MOE: u1 = 0,
        BKF: u4 = 0,
        BK2F: u4 = 0,
        BK2E: u1 = 0,
        BK2P: u1 = 0,
        _0: u6 = 0,

        pub const set = set_masked;
    },

    DCR: packed struct {
        DBA: u5 = 0,
        _0: u3 = 0,
        DBL: u5 = 0,
        _1: u19 = 0,

        pub const set = set_masked;
    },

    DMAR: packed struct {
        DMAB: u32 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    CCMR3_Output: packed struct {
        _0: u2 = 0,
        OC5FE: u1 = 0,
        OC5PE: u1 = 0,
        OC5M: u3 = 0,
        OC5CE: u1 = 0,
        _1: u2 = 0,
        OC6FE: u1 = 0,
        OC6PE: u1 = 0,
        OC6M: u3 = 0,
        OC6CE: u1 = 0,
        OC5M3: u1 = 0,
        _2: u7 = 0,
        OC6M3: u1 = 0,
        _3: u7 = 0,

        pub const set = set_masked;
    },

    CCR5: packed struct {
        CCR5: u16 = 0,
        _0: u13 = 0,
        GC5C1: u1 = 0,
        GC5C2: u1 = 0,
        GC5C3: u1 = 0,

        pub const set = set_masked;
    },

    CCR6: packed struct {
        CCR6: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40010000);

pub const TIM8: @TypeOf(TIM1) = @ptrFromInt(0x40010400);

pub const ADC2: *volatile packed struct {
    SR: packed struct {
        AWD: u1 = 0,
        EOC: u1 = 0,
        JEOC: u1 = 0,
        JSTRT: u1 = 0,
        STRT: u1 = 0,
        OVR: u1 = 0,
        _0: u26 = 0,

        pub const set = set_masked;
    },

    CR1: packed struct {
        AWDCH: u5 = 0,
        EOCIE: u1 = 0,
        AWDIE: u1 = 0,
        JEOCIE: u1 = 0,
        SCAN: u1 = 0,
        AWDSGL: u1 = 0,
        JAUTO: u1 = 0,
        DISCEN: u1 = 0,
        JDISCEN: u1 = 0,
        DISCNUM: u3 = 0,
        _0: u6 = 0,
        JAWDEN: u1 = 0,
        AWDEN: u1 = 0,
        RES: u2 = 0,
        OVRIE: u1 = 0,
        _1: u5 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        ADON: u1 = 0,
        CONT: u1 = 0,
        _0: u6 = 0,
        DMA: u1 = 0,
        DDS: u1 = 0,
        EOCS: u1 = 0,
        ALIGN: u1 = 0,
        _1: u4 = 0,
        JEXTSEL: u4 = 0,
        JEXTEN: u2 = 0,
        JSWSTART: u1 = 0,
        _2: u1 = 0,
        EXTSEL: u4 = 0,
        EXTEN: u2 = 0,
        SWSTART: u1 = 0,
        _3: u1 = 0,

        pub const set = set_masked;
    },

    SMPR1: packed struct {
        SMPx_x: u32 = 0,

        pub const set = set_masked;
    },

    SMPR2: packed struct {
        SMPx_x: u32 = 0,

        pub const set = set_masked;
    },

    JOFR1: packed struct {
        JOFFSET1: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    JOFR2: packed struct {
        JOFFSET2: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    JOFR3: packed struct {
        JOFFSET3: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    JOFR4: packed struct {
        JOFFSET4: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    HTR: packed struct {
        HT: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    LTR: packed struct {
        LT: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    SQR1: packed struct {
        SQ13: u5 = 0,
        SQ14: u5 = 0,
        SQ15: u5 = 0,
        SQ16: u5 = 0,
        L: u4 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    SQR2: packed struct {
        SQ7: u5 = 0,
        SQ8: u5 = 0,
        SQ9: u5 = 0,
        SQ10: u5 = 0,
        SQ11: u5 = 0,
        SQ12: u5 = 0,
        _0: u2 = 0,

        pub const set = set_masked;
    },

    SQR3: packed struct {
        SQ1: u5 = 0,
        SQ2: u5 = 0,
        SQ3: u5 = 0,
        SQ4: u5 = 0,
        SQ5: u5 = 0,
        SQ6: u5 = 0,
        _0: u2 = 0,

        pub const set = set_masked;
    },

    JSQR: packed struct {
        JSQ1: u5 = 0,
        JSQ2: u5 = 0,
        JSQ3: u5 = 0,
        JSQ4: u5 = 0,
        JL: u2 = 0,
        _0: u10 = 0,

        pub const set = set_masked;
    },

    JDR1: packed struct {
        JDATA: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    JDR2: packed struct {
        JDATA: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    JDR3: packed struct {
        JDATA: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    JDR4: packed struct {
        JDATA: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    DR: packed struct {
        DATA: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40012100);

pub const ADC1: @TypeOf(ADC2) = @ptrFromInt(0x40012000);

pub const ADC3: @TypeOf(ADC2) = @ptrFromInt(0x40012200);

pub const TIM6: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        _0: u3 = 0,
        ARPE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        _0: u4 = 0,
        MMS: u3 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    DIER: packed struct {
        UIE: u1 = 0,
        _0: u7 = 0,
        UDE: u1 = 0,
        _1: u23 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        _0: u31 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        _0: u31 = 0,

        pub const set = set_masked;
    },

    _1: u96 = 0,

    CNT: packed struct {
        CNT: u16 = 0,
        _0: u15 = 0,
        UIFCPY: u1 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40001000);

pub const TIM7: @TypeOf(TIM6) = @ptrFromInt(0x40001400);

pub const C_ADC: *volatile packed struct {
    CSR: packed struct {
        AWD1: u1 = 0,
        EOC1: u1 = 0,
        JEOC1: u1 = 0,
        JSTRT1: u1 = 0,
        STRT1: u1 = 0,
        OVR1: u1 = 0,
        _0: u2 = 0,
        AWD2: u1 = 0,
        EOC2: u1 = 0,
        JEOC2: u1 = 0,
        JSTRT2: u1 = 0,
        STRT2: u1 = 0,
        OVR2: u1 = 0,
        _1: u2 = 0,
        AWD3: u1 = 0,
        EOC3: u1 = 0,
        JEOC3: u1 = 0,
        JSTRT3: u1 = 0,
        STRT3: u1 = 0,
        OVR3: u1 = 0,
        _2: u10 = 0,

        pub const set = set_masked;
    },

    CCR: packed struct {
        MULT: u5 = 0,
        _0: u3 = 0,
        DELAY: u4 = 0,
        _1: u1 = 0,
        DDS: u1 = 0,
        DMA: u2 = 0,
        ADCPRE: u2 = 0,
        _2: u4 = 0,
        VBATE: u1 = 0,
        TSVREFE: u1 = 0,
        _3: u8 = 0,

        pub const set = set_masked;
    },

    CDR: packed struct {
        DATA1: u16 = 0,
        DATA2: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40012300);

pub const CAN1: *volatile packed struct {
    MCR: packed struct {
        INRQ: u1 = 0,
        SLEEP: u1 = 0,
        TXFP: u1 = 0,
        RFLM: u1 = 0,
        NART: u1 = 0,
        AWUM: u1 = 0,
        ABOM: u1 = 0,
        TTCM: u1 = 0,
        _0: u7 = 0,
        RESET: u1 = 0,
        DBF: u1 = 0,
        _1: u15 = 0,

        pub const set = set_masked;
    },

    MSR: packed struct {
        INAK: u1 = 0,
        SLAK: u1 = 0,
        ERRI: u1 = 0,
        WKUI: u1 = 0,
        SLAKI: u1 = 0,
        _0: u3 = 0,
        TXM: u1 = 0,
        RXM: u1 = 0,
        SAMP: u1 = 0,
        RX: u1 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },

    TSR: packed struct {
        RQCP0: u1 = 0,
        TXOK0: u1 = 0,
        ALST0: u1 = 0,
        TERR0: u1 = 0,
        _0: u3 = 0,
        ABRQ0: u1 = 0,
        RQCP1: u1 = 0,
        TXOK1: u1 = 0,
        ALST1: u1 = 0,
        TERR1: u1 = 0,
        _1: u3 = 0,
        ABRQ1: u1 = 0,
        RQCP2: u1 = 0,
        TXOK2: u1 = 0,
        ALST2: u1 = 0,
        TERR2: u1 = 0,
        _2: u3 = 0,
        ABRQ2: u1 = 0,
        CODE: u2 = 0,
        TME0: u1 = 0,
        TME1: u1 = 0,
        TME2: u1 = 0,
        LOW0: u1 = 0,
        LOW1: u1 = 0,
        LOW2: u1 = 0,

        pub const set = set_masked;
    },

    RF0R: packed struct {
        FMP0: u2 = 0,
        _0: u1 = 0,
        FULL0: u1 = 0,
        FOVR0: u1 = 0,
        RFOM0: u1 = 0,
        _1: u26 = 0,

        pub const set = set_masked;
    },

    RF1R: packed struct {
        FMP1: u2 = 0,
        _0: u1 = 0,
        FULL1: u1 = 0,
        FOVR1: u1 = 0,
        RFOM1: u1 = 0,
        _1: u26 = 0,

        pub const set = set_masked;
    },

    IER: packed struct {
        TMEIE: u1 = 0,
        FMPIE0: u1 = 0,
        FFIE0: u1 = 0,
        FOVIE0: u1 = 0,
        FMPIE1: u1 = 0,
        FFIE1: u1 = 0,
        FOVIE1: u1 = 0,
        _0: u1 = 0,
        EWGIE: u1 = 0,
        EPVIE: u1 = 0,
        BOFIE: u1 = 0,
        LECIE: u1 = 0,
        _1: u3 = 0,
        ERRIE: u1 = 0,
        WKUIE: u1 = 0,
        SLKIE: u1 = 0,
        _2: u14 = 0,

        pub const set = set_masked;
    },

    ESR: packed struct {
        EWGF: u1 = 0,
        EPVF: u1 = 0,
        BOFF: u1 = 0,
        _0: u1 = 0,
        LEC: u3 = 0,
        _1: u9 = 0,
        TEC: u8 = 0,
        REC: u8 = 0,

        pub const set = set_masked;
    },

    BTR: packed struct {
        BRP: u10 = 0,
        _0: u6 = 0,
        TS1: u4 = 0,
        TS2: u3 = 0,
        _1: u1 = 0,
        SJW: u2 = 0,
        _2: u4 = 0,
        LBKM: u1 = 0,
        SILM: u1 = 0,

        pub const set = set_masked;
    },

    _0: u2816 = 0,

    TI0R: packed struct {
        TXRQ: u1 = 0,
        RTR: u1 = 0,
        IDE: u1 = 0,
        EXID: u18 = 0,
        STID: u11 = 0,

        pub const set = set_masked;
    },

    TDT0R: packed struct {
        DLC: u4 = 0,
        _0: u4 = 0,
        TGT: u1 = 0,
        _1: u7 = 0,
        TIME: u16 = 0,

        pub const set = set_masked;
    },

    TDL0R: packed struct {
        DATA0: u8 = 0,
        DATA1: u8 = 0,
        DATA2: u8 = 0,
        DATA3: u8 = 0,

        pub const set = set_masked;
    },

    TDH0R: packed struct {
        DATA4: u8 = 0,
        DATA5: u8 = 0,
        DATA6: u8 = 0,
        DATA7: u8 = 0,

        pub const set = set_masked;
    },

    TI1R: packed struct {
        TXRQ: u1 = 0,
        RTR: u1 = 0,
        IDE: u1 = 0,
        EXID: u18 = 0,
        STID: u11 = 0,

        pub const set = set_masked;
    },

    TDT1R: packed struct {
        DLC: u4 = 0,
        _0: u4 = 0,
        TGT: u1 = 0,
        _1: u7 = 0,
        TIME: u16 = 0,

        pub const set = set_masked;
    },

    TDL1R: packed struct {
        DATA0: u8 = 0,
        DATA1: u8 = 0,
        DATA2: u8 = 0,
        DATA3: u8 = 0,

        pub const set = set_masked;
    },

    TDH1R: packed struct {
        DATA4: u8 = 0,
        DATA5: u8 = 0,
        DATA6: u8 = 0,
        DATA7: u8 = 0,

        pub const set = set_masked;
    },

    TI2R: packed struct {
        TXRQ: u1 = 0,
        RTR: u1 = 0,
        IDE: u1 = 0,
        EXID: u18 = 0,
        STID: u11 = 0,

        pub const set = set_masked;
    },

    TDT2R: packed struct {
        DLC: u4 = 0,
        _0: u4 = 0,
        TGT: u1 = 0,
        _1: u7 = 0,
        TIME: u16 = 0,

        pub const set = set_masked;
    },

    TDL2R: packed struct {
        DATA0: u8 = 0,
        DATA1: u8 = 0,
        DATA2: u8 = 0,
        DATA3: u8 = 0,

        pub const set = set_masked;
    },

    TDH2R: packed struct {
        DATA4: u8 = 0,
        DATA5: u8 = 0,
        DATA6: u8 = 0,
        DATA7: u8 = 0,

        pub const set = set_masked;
    },

    RI0R: packed struct {
        _0: u1 = 0,
        RTR: u1 = 0,
        IDE: u1 = 0,
        EXID: u18 = 0,
        STID: u11 = 0,

        pub const set = set_masked;
    },

    RDT0R: packed struct {
        DLC: u4 = 0,
        _0: u4 = 0,
        FMI: u8 = 0,
        TIME: u16 = 0,

        pub const set = set_masked;
    },

    RDL0R: packed struct {
        DATA0: u8 = 0,
        DATA1: u8 = 0,
        DATA2: u8 = 0,
        DATA3: u8 = 0,

        pub const set = set_masked;
    },

    RDH0R: packed struct {
        DATA4: u8 = 0,
        DATA5: u8 = 0,
        DATA6: u8 = 0,
        DATA7: u8 = 0,

        pub const set = set_masked;
    },

    RI1R: packed struct {
        _0: u1 = 0,
        RTR: u1 = 0,
        IDE: u1 = 0,
        EXID: u18 = 0,
        STID: u11 = 0,

        pub const set = set_masked;
    },

    RDT1R: packed struct {
        DLC: u4 = 0,
        _0: u4 = 0,
        FMI: u8 = 0,
        TIME: u16 = 0,

        pub const set = set_masked;
    },

    RDL1R: packed struct {
        DATA0: u8 = 0,
        DATA1: u8 = 0,
        DATA2: u8 = 0,
        DATA3: u8 = 0,

        pub const set = set_masked;
    },

    RDH1R: packed struct {
        DATA4: u8 = 0,
        DATA5: u8 = 0,
        DATA6: u8 = 0,
        DATA7: u8 = 0,

        pub const set = set_masked;
    },

    _1: u384 = 0,

    FMR: packed struct {
        FINIT: u1 = 0,
        _0: u31 = 0,

        pub const set = set_masked;
    },

    FM1R: packed struct {
        FBM0: u1 = 0,
        FBM1: u1 = 0,
        FBM2: u1 = 0,
        FBM3: u1 = 0,
        FBM4: u1 = 0,
        FBM5: u1 = 0,
        FBM6: u1 = 0,
        FBM7: u1 = 0,
        FBM8: u1 = 0,
        FBM9: u1 = 0,
        FBM10: u1 = 0,
        FBM11: u1 = 0,
        FBM12: u1 = 0,
        FBM13: u1 = 0,
        _0: u18 = 0,

        pub const set = set_masked;
    },

    _2: u32 = 0,

    FS1R: packed struct {
        FSC0: u1 = 0,
        FSC1: u1 = 0,
        FSC2: u1 = 0,
        FSC3: u1 = 0,
        FSC4: u1 = 0,
        FSC5: u1 = 0,
        FSC6: u1 = 0,
        FSC7: u1 = 0,
        FSC8: u1 = 0,
        FSC9: u1 = 0,
        FSC10: u1 = 0,
        FSC11: u1 = 0,
        FSC12: u1 = 0,
        FSC13: u1 = 0,
        _0: u18 = 0,

        pub const set = set_masked;
    },

    _3: u32 = 0,

    FFA1R: packed struct {
        FFA0: u1 = 0,
        FFA1: u1 = 0,
        FFA2: u1 = 0,
        FFA3: u1 = 0,
        FFA4: u1 = 0,
        FFA5: u1 = 0,
        FFA6: u1 = 0,
        FFA7: u1 = 0,
        FFA8: u1 = 0,
        FFA9: u1 = 0,
        FFA10: u1 = 0,
        FFA11: u1 = 0,
        FFA12: u1 = 0,
        FFA13: u1 = 0,
        _0: u18 = 0,

        pub const set = set_masked;
    },

    _4: u32 = 0,

    FA1R: packed struct {
        FACT0: u1 = 0,
        FACT1: u1 = 0,
        FACT2: u1 = 0,
        FACT3: u1 = 0,
        FACT4: u1 = 0,
        FACT5: u1 = 0,
        FACT6: u1 = 0,
        FACT7: u1 = 0,
        FACT8: u1 = 0,
        FACT9: u1 = 0,
        FACT10: u1 = 0,
        FACT11: u1 = 0,
        FACT12: u1 = 0,
        FACT13: u1 = 0,
        _0: u18 = 0,

        pub const set = set_masked;
    },

    _5: u256 = 0,

    F0R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F0R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F1R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F1R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F2R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F2R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F3R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F3R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F4R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F4R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F5R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F5R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F6R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F6R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F7R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F7R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F8R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F8R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F9R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F9R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F10R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F10R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F11R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F11R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F12R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F12R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F13R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F13R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F14R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F14R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F15R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F15R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F16R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F16R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F17R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F17R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F18R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F18R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F19R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F19R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F20R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F20R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F21R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F21R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F22R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F22R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F23R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F23R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F24R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F24R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F25R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F25R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F26R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F26R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F27R1: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },

    F27R2: packed struct {
        FB0: u1 = 0,
        FB1: u1 = 0,
        FB2: u1 = 0,
        FB3: u1 = 0,
        FB4: u1 = 0,
        FB5: u1 = 0,
        FB6: u1 = 0,
        FB7: u1 = 0,
        FB8: u1 = 0,
        FB9: u1 = 0,
        FB10: u1 = 0,
        FB11: u1 = 0,
        FB12: u1 = 0,
        FB13: u1 = 0,
        FB14: u1 = 0,
        FB15: u1 = 0,
        FB16: u1 = 0,
        FB17: u1 = 0,
        FB18: u1 = 0,
        FB19: u1 = 0,
        FB20: u1 = 0,
        FB21: u1 = 0,
        FB22: u1 = 0,
        FB23: u1 = 0,
        FB24: u1 = 0,
        FB25: u1 = 0,
        FB26: u1 = 0,
        FB27: u1 = 0,
        FB28: u1 = 0,
        FB29: u1 = 0,
        FB30: u1 = 0,
        FB31: u1 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40006400);

pub const CRC: *volatile packed struct {
    DR: packed struct {
        DR: u32 = 0,

        pub const set = set_masked;
    },

    IDR: packed struct {
        IDR: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    CR: packed struct {
        RESET: u1 = 0,
        _0: u2 = 0,
        POLYSIZE: u2 = 0,
        REV_IN: u2 = 0,
        REV_OUT: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    INIT: packed struct {
        CRC_INIT: u32 = 0,

        pub const set = set_masked;
    },

    POL: packed struct {
        POL: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40023000);

pub const CRYP: *volatile packed struct {
    CR: packed struct {
        EN: u1 = 0,
        DATATYPE: u2 = 0,
        MODE: u2 = 0,
        CHMOD: u2 = 0,
        CCFC: u1 = 0,
        ERRC: u1 = 0,
        CCFIE: u1 = 0,
        ERRIE: u1 = 0,
        DMAINEN: u1 = 0,
        DMAOUTEN: u1 = 0,
        GCMPH: u2 = 0,
        _0: u3 = 0,
        KEYSIZE: u1 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        CCF: u1 = 0,
        RDERR: u1 = 0,
        WRERR: u1 = 0,
        Busy: u1 = 0,
        _0: u28 = 0,

        pub const set = set_masked;
    },

    DINR: packed struct {
        DINR: u32 = 0,

        pub const set = set_masked;
    },

    DOUTR: packed struct {
        DOUTR: u32 = 0,

        pub const set = set_masked;
    },

    KEYR0: packed struct {
        KEYR0: u31 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    KEYR1: packed struct {
        KEYR1: u32 = 0,

        pub const set = set_masked;
    },

    KEYR2: packed struct {
        KEYR2: u31 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    KEYR3: packed struct {
        KEYR3: u32 = 0,

        pub const set = set_masked;
    },

    IVR0: packed struct {
        IVR0: u32 = 0,

        pub const set = set_masked;
    },

    IVR1: packed struct {
        IVR1: u32 = 0,

        pub const set = set_masked;
    },

    IVR2: packed struct {
        IVR2: u32 = 0,

        pub const set = set_masked;
    },

    IVR3: packed struct {
        IVR3: u32 = 0,

        pub const set = set_masked;
    },

    KEYR4: packed struct {
        KEYR4: u32 = 0,

        pub const set = set_masked;
    },

    KEYR5: packed struct {
        KEYR5: u32 = 0,

        pub const set = set_masked;
    },

    KEYR6: packed struct {
        KEYR6: u32 = 0,

        pub const set = set_masked;
    },

    KEYR7: packed struct {
        KEYR7: u32 = 0,

        pub const set = set_masked;
    },

    SUSP0R: packed struct {
        SUSP0R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP1R: packed struct {
        SUSP1R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP2R: packed struct {
        SUSP2R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP3R: packed struct {
        SUSP3R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP4R: packed struct {
        SUSP4R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP5R: packed struct {
        SUSP5R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP6R: packed struct {
        SUSP6R: u32 = 0,

        pub const set = set_masked;
    },

    SUSP7R: packed struct {
        SUSP7R: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x50060000);

pub const DBG: *volatile packed struct {
    DBGMCU_IDCODE: packed struct {
        DEV_ID: u12 = 0,
        _0: u4 = 0,
        REV_ID: u16 = 0,

        pub const set = set_masked;
    },

    DBGMCU_CR: packed struct {
        DBG_SLEEP: u1 = 0,
        DBG_STOP: u1 = 0,
        DBG_STANDBY: u1 = 0,
        _0: u2 = 0,
        TRACE_IOEN: u1 = 0,
        TRACE_MODE: u2 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    DBGMCU_APB1_FZ: packed struct {
        DBG_TIM2_STOP: u1 = 0,
        DBG_TIM3_STOP: u1 = 0,
        DBG_TIM4_STOP: u1 = 0,
        DBG_TIM5_STOP: u1 = 0,
        DBG_TIM6_STOP: u1 = 0,
        DBG_TIM7_STOP: u1 = 0,
        DBG_TIM12_STOP: u1 = 0,
        DBG_TIM13_STOP: u1 = 0,
        DBG_TIM14_STOP: u1 = 0,
        _0: u2 = 0,
        DBG_WWDG_STOP: u1 = 0,
        DBG_IWDEG_STOP: u1 = 0,
        _1: u8 = 0,
        DBG_J2C1_SMBUS_TIMEOUT: u1 = 0,
        DBG_J2C2_SMBUS_TIMEOUT: u1 = 0,
        DBG_J2C3SMBUS_TIMEOUT: u1 = 0,
        _2: u1 = 0,
        DBG_CAN1_STOP: u1 = 0,
        DBG_CAN2_STOP: u1 = 0,
        _3: u5 = 0,

        pub const set = set_masked;
    },

    DBGMCU_APB2_FZ: packed struct {
        DBG_TIM1_STOP: u1 = 0,
        DBG_TIM8_STOP: u1 = 0,
        _0: u14 = 0,
        DBG_TIM9_STOP: u1 = 0,
        DBG_TIM10_STOP: u1 = 0,
        DBG_TIM11_STOP: u1 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0xe0042000);

pub const DAC: *volatile packed struct {
    CR: packed struct {
        EN1: u1 = 0,
        BOFF1: u1 = 0,
        TEN1: u1 = 0,
        TSEL1: u3 = 0,
        WAVE1: u2 = 0,
        MAMP1: u4 = 0,
        DMAEN1: u1 = 0,
        DMAUDRIE1: u1 = 0,
        _0: u2 = 0,
        EN2: u1 = 0,
        BOFF2: u1 = 0,
        TEN2: u1 = 0,
        TSEL2: u3 = 0,
        WAVE2: u2 = 0,
        MAMP2: u4 = 0,
        DMAEN2: u1 = 0,
        DMAUDRIE2: u1 = 0,
        _1: u2 = 0,

        pub const set = set_masked;
    },

    SWTRIGR: packed struct {
        SWTRIG1: u1 = 0,
        SWTRIG2: u1 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    DHR12R1: packed struct {
        DACC1DHR: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    DHR12L1: packed struct {
        _0: u4 = 0,
        DACC1DHR: u12 = 0,
        _1: u16 = 0,

        pub const set = set_masked;
    },

    DHR8R1: packed struct {
        DACC1DHR: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    DHR12R2: packed struct {
        DACC2DHR: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    DHR12L2: packed struct {
        _0: u4 = 0,
        DACC2DHR: u12 = 0,
        _1: u16 = 0,

        pub const set = set_masked;
    },

    DHR8R2: packed struct {
        DACC2DHR: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    DHR12RD: packed struct {
        DACC1DHR: u12 = 0,
        _0: u4 = 0,
        DACC2DHR: u12 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    DHR12LD: packed struct {
        _0: u4 = 0,
        DACC1DHR: u12 = 0,
        _1: u4 = 0,
        DACC2DHR: u12 = 0,

        pub const set = set_masked;
    },

    DHR8RD: packed struct {
        DACC1DHR: u8 = 0,
        DACC2DHR: u8 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    DOR1: packed struct {
        DACC1DOR: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    DOR2: packed struct {
        DACC2DOR: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        _0: u13 = 0,
        DMAUDR1: u1 = 0,
        _1: u15 = 0,
        DMAUDR2: u1 = 0,
        _2: u2 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40007400);

pub const DMA2: *volatile packed struct {
    LISR: packed struct {
        FEIF0: u1 = 0,
        _0: u1 = 0,
        DMEIF0: u1 = 0,
        TEIF0: u1 = 0,
        HTIF0: u1 = 0,
        TCIF0: u1 = 0,
        FEIF1: u1 = 0,
        _1: u1 = 0,
        DMEIF1: u1 = 0,
        TEIF1: u1 = 0,
        HTIF1: u1 = 0,
        TCIF1: u1 = 0,
        _2: u4 = 0,
        FEIF2: u1 = 0,
        _3: u1 = 0,
        DMEIF2: u1 = 0,
        TEIF2: u1 = 0,
        HTIF2: u1 = 0,
        TCIF2: u1 = 0,
        FEIF3: u1 = 0,
        _4: u1 = 0,
        DMEIF3: u1 = 0,
        TEIF3: u1 = 0,
        HTIF3: u1 = 0,
        TCIF3: u1 = 0,
        _5: u4 = 0,

        pub const set = set_masked;
    },

    HISR: packed struct {
        FEIF4: u1 = 0,
        _0: u1 = 0,
        DMEIF4: u1 = 0,
        TEIF4: u1 = 0,
        HTIF4: u1 = 0,
        TCIF4: u1 = 0,
        FEIF5: u1 = 0,
        _1: u1 = 0,
        DMEIF5: u1 = 0,
        TEIF5: u1 = 0,
        HTIF5: u1 = 0,
        TCIF5: u1 = 0,
        _2: u4 = 0,
        FEIF6: u1 = 0,
        _3: u1 = 0,
        DMEIF6: u1 = 0,
        TEIF6: u1 = 0,
        HTIF6: u1 = 0,
        TCIF6: u1 = 0,
        FEIF7: u1 = 0,
        _4: u1 = 0,
        DMEIF7: u1 = 0,
        TEIF7: u1 = 0,
        HTIF7: u1 = 0,
        TCIF7: u1 = 0,
        _5: u4 = 0,

        pub const set = set_masked;
    },

    LIFCR: packed struct {
        CFEIF0: u1 = 0,
        _0: u1 = 0,
        CDMEIF0: u1 = 0,
        CTEIF0: u1 = 0,
        CHTIF0: u1 = 0,
        CTCIF0: u1 = 0,
        CFEIF1: u1 = 0,
        _1: u1 = 0,
        CDMEIF1: u1 = 0,
        CTEIF1: u1 = 0,
        CHTIF1: u1 = 0,
        CTCIF1: u1 = 0,
        _2: u4 = 0,
        CFEIF2: u1 = 0,
        _3: u1 = 0,
        CDMEIF2: u1 = 0,
        CTEIF2: u1 = 0,
        CHTIF2: u1 = 0,
        CTCIF2: u1 = 0,
        CFEIF3: u1 = 0,
        _4: u1 = 0,
        CDMEIF3: u1 = 0,
        CTEIF3: u1 = 0,
        CHTIF3: u1 = 0,
        CTCIF3: u1 = 0,
        _5: u4 = 0,

        pub const set = set_masked;
    },

    HIFCR: packed struct {
        CFEIF4: u1 = 0,
        _0: u1 = 0,
        CDMEIF4: u1 = 0,
        CTEIF4: u1 = 0,
        CHTIF4: u1 = 0,
        CTCIF4: u1 = 0,
        CFEIF5: u1 = 0,
        _1: u1 = 0,
        CDMEIF5: u1 = 0,
        CTEIF5: u1 = 0,
        CHTIF5: u1 = 0,
        CTCIF5: u1 = 0,
        _2: u4 = 0,
        CFEIF6: u1 = 0,
        _3: u1 = 0,
        CDMEIF6: u1 = 0,
        CTEIF6: u1 = 0,
        CHTIF6: u1 = 0,
        CTCIF6: u1 = 0,
        CFEIF7: u1 = 0,
        _4: u1 = 0,
        CDMEIF7: u1 = 0,
        CTEIF7: u1 = 0,
        CHTIF7: u1 = 0,
        CTCIF7: u1 = 0,
        _5: u4 = 0,

        pub const set = set_masked;
    },

    S0CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S0NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S0PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S0M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S0M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S0FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S1CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S1NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S1PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S1M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S1M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S1FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S2CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S2NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S2PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S2M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S2M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S2FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S3CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S3NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S3PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S3M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S3M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S3FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S4CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S4NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S4PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S4M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S4M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S4FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S5CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S5NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S5PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S5M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S5M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S5FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S6CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S6NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S6PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S6M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S6M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S6FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    S7CR: packed struct {
        EN: u1 = 0,
        DMEIE: u1 = 0,
        TEIE: u1 = 0,
        HTIE: u1 = 0,
        TCIE: u1 = 0,
        PFCTRL: u1 = 0,
        DIR: u2 = 0,
        CIRC: u1 = 0,
        PINC: u1 = 0,
        MINC: u1 = 0,
        PSIZE: u2 = 0,
        MSIZE: u2 = 0,
        PINCOS: u1 = 0,
        PL: u2 = 0,
        DBM: u1 = 0,
        CT: u1 = 0,
        _0: u1 = 0,
        PBURST: u2 = 0,
        MBURST: u2 = 0,
        CHSEL: u3 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    S7NDTR: packed struct {
        NDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    S7PAR: packed struct {
        PA: u32 = 0,

        pub const set = set_masked;
    },

    S7M0AR: packed struct {
        M0A: u32 = 0,

        pub const set = set_masked;
    },

    S7M1AR: packed struct {
        M1A: u32 = 0,

        pub const set = set_masked;
    },

    S7FCR: packed struct {
        FTH: u2 = 0,
        DMDIS: u1 = 0,
        FS: u3 = 0,
        _0: u1 = 0,
        FEIE: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40026400);

pub const DMA1: @TypeOf(DMA2) = @ptrFromInt(0x40026000);

pub const EXTI: *volatile packed struct {
    IMR: packed struct {
        IM0: u1 = 0,
        IM1: u1 = 0,
        IM2: u1 = 0,
        IM3: u1 = 0,
        IM4: u1 = 0,
        IM5: u1 = 0,
        IM6: u1 = 0,
        IM7: u1 = 0,
        IM8: u1 = 0,
        MI9: u1 = 0,
        IM10: u1 = 0,
        IM11: u1 = 0,
        IM12: u1 = 0,
        IM13: u1 = 0,
        IM14: u1 = 0,
        IM15: u1 = 0,
        IM16: u1 = 0,
        IM17: u1 = 0,
        IM18: u1 = 0,
        IM19: u1 = 0,
        IM20: u1 = 0,
        IM21: u1 = 0,
        IM22: u1 = 0,
        IM23: u1 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    EMR: packed struct {
        EM0: u1 = 0,
        EM1: u1 = 0,
        EM2: u1 = 0,
        EM3: u1 = 0,
        EM4: u1 = 0,
        EM5: u1 = 0,
        EM6: u1 = 0,
        EM7: u1 = 0,
        EM8: u1 = 0,
        EM9: u1 = 0,
        EM10: u1 = 0,
        EM11: u1 = 0,
        EM12: u1 = 0,
        EM13: u1 = 0,
        EM14: u1 = 0,
        EM15: u1 = 0,
        EM16: u1 = 0,
        EM17: u1 = 0,
        EM18: u1 = 0,
        EM19: u1 = 0,
        EM20: u1 = 0,
        EM21: u1 = 0,
        EM22: u1 = 0,
        EM23: u1 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    RTSR: packed struct {
        TR0: u1 = 0,
        TR1: u1 = 0,
        TR2: u1 = 0,
        TR3: u1 = 0,
        TR4: u1 = 0,
        TR5: u1 = 0,
        TR6: u1 = 0,
        TR7: u1 = 0,
        TR8: u1 = 0,
        TR9: u1 = 0,
        TR10: u1 = 0,
        TR11: u1 = 0,
        TR12: u1 = 0,
        TR13: u1 = 0,
        TR14: u1 = 0,
        TR15: u1 = 0,
        TR16: u1 = 0,
        TR17: u1 = 0,
        TR18: u1 = 0,
        TR19: u1 = 0,
        TR20: u1 = 0,
        TR21: u1 = 0,
        TR22: u1 = 0,
        TR23: u1 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    FTSR: packed struct {
        TR0: u1 = 0,
        TR1: u1 = 0,
        TR2: u1 = 0,
        TR3: u1 = 0,
        TR4: u1 = 0,
        TR5: u1 = 0,
        TR6: u1 = 0,
        TR7: u1 = 0,
        TR8: u1 = 0,
        TR9: u1 = 0,
        TR10: u1 = 0,
        TR11: u1 = 0,
        TR12: u1 = 0,
        TR13: u1 = 0,
        TR14: u1 = 0,
        TR15: u1 = 0,
        TR16: u1 = 0,
        TR17: u1 = 0,
        TR18: u1 = 0,
        TR19: u1 = 0,
        TR20: u1 = 0,
        TR21: u1 = 0,
        TR22: u1 = 0,
        TR23: u1 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    SWIER: packed struct {
        SWIER0: u1 = 0,
        SWIER1: u1 = 0,
        SWIER2: u1 = 0,
        SWIER3: u1 = 0,
        SWIER4: u1 = 0,
        SWIER5: u1 = 0,
        SWIER6: u1 = 0,
        SWIER7: u1 = 0,
        SWIER8: u1 = 0,
        SWIER9: u1 = 0,
        SWIER10: u1 = 0,
        SWIER11: u1 = 0,
        SWIER12: u1 = 0,
        SWIER13: u1 = 0,
        SWIER14: u1 = 0,
        SWIER15: u1 = 0,
        SWIER16: u1 = 0,
        SWIER17: u1 = 0,
        SWIER18: u1 = 0,
        SWIER19: u1 = 0,
        SWIER20: u1 = 0,
        SWIER21: u1 = 0,
        SWIER22: u1 = 0,
        SWIER23: u1 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    PR: packed struct {
        PR0: u1 = 0,
        PR1: u1 = 0,
        PR2: u1 = 0,
        PR3: u1 = 0,
        PR4: u1 = 0,
        PR5: u1 = 0,
        PR6: u1 = 0,
        PR7: u1 = 0,
        PR8: u1 = 0,
        PR9: u1 = 0,
        PR10: u1 = 0,
        PR11: u1 = 0,
        PR12: u1 = 0,
        PR13: u1 = 0,
        PR14: u1 = 0,
        PR15: u1 = 0,
        PR16: u1 = 0,
        PR17: u1 = 0,
        PR18: u1 = 0,
        PR19: u1 = 0,
        PR20: u1 = 0,
        PR21: u1 = 0,
        PR22: u1 = 0,
        PR23: u1 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40013c00);

pub const FLASH: *volatile packed struct {
    ACR: packed struct {
        LATENCY: u3 = 0,
        _0: u5 = 0,
        PRFTEN: u1 = 0,
        ARTEN: u1 = 0,
        _1: u1 = 0,
        ARTRST: u1 = 0,
        _2: u20 = 0,

        pub const set = set_masked;
    },

    KEYR: packed struct {
        KEY: u32 = 0,

        pub const set = set_masked;
    },

    OPTKEYR: packed struct {
        OPTKEYR: u32 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        EOP: u1 = 0,
        OPERR: u1 = 0,
        _0: u2 = 0,
        WRPERR: u1 = 0,
        PGAERR: u1 = 0,
        PGPERR: u1 = 0,
        ERSERR: u1 = 0,
        _1: u8 = 0,
        BSY: u1 = 0,
        _2: u15 = 0,

        pub const set = set_masked;
    },

    CR: packed struct {
        PG: u1 = 0,
        SER: u1 = 0,
        MER: u1 = 0,
        SNB: u5 = 0,
        PSIZE: u2 = 0,
        _0: u6 = 0,
        STRT: u1 = 0,
        _1: u7 = 0,
        EOPIE: u1 = 0,
        ERRIE: u1 = 0,
        RDERRIE: u1 = 0,
        _2: u4 = 0,
        LOCK: u1 = 0,

        pub const set = set_masked;
    },

    OPTCR: packed struct {
        OPTLOCK: u1 = 0,
        OPTSTRT: u1 = 0,
        BOR_LEV: u2 = 0,
        WWDG_SW: u1 = 0,
        IWDG_SW: u1 = 0,
        nRST_STOP: u1 = 0,
        nRST_STDBY: u1 = 0,
        RDP: u8 = 0,
        nWRP: u12 = 0,
        _0: u2 = 0,
        IWDG_STDBY: u1 = 0,
        IWDG_STOP: u1 = 0,

        pub const set = set_masked;
    },

    OPTCR1: packed struct {
        BOOT_ADD0: u16 = 0,
        BOOT_ADD1: u16 = 0,

        pub const set = set_masked;
    },

    OPTCR2: packed struct {
        PCROP: u8 = 0,
        _0: u23 = 0,
        PCROP_RDP: u1 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40023c00);

pub const FMC: *volatile packed struct {
    BCR1: packed struct {
        MBKEN: u1 = 0,
        MUXEN: u1 = 0,
        MTYP: u2 = 0,
        MWID: u2 = 0,
        FACCEN: u1 = 0,
        _0: u1 = 0,
        BURSTEN: u1 = 0,
        WAITPOL: u1 = 0,
        _1: u1 = 0,
        WAITCFG: u1 = 0,
        WREN: u1 = 0,
        WAITEN: u1 = 0,
        EXTMOD: u1 = 0,
        ASYNCWAIT: u1 = 0,
        CPSIZE: u3 = 0,
        CBURSTRW: u1 = 0,
        CCLKEN: u1 = 0,
        WFDIS: u1 = 0,
        _2: u10 = 0,

        pub const set = set_masked;
    },

    BTR1: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        CLKDIV: u4 = 0,
        DATLAT: u4 = 0,
        ACCMOD: u2 = 0,
        _0: u2 = 0,

        pub const set = set_masked;
    },

    BCR2: packed struct {
        MBKEN: u1 = 0,
        MUXEN: u1 = 0,
        MTYP: u2 = 0,
        MWID: u2 = 0,
        FACCEN: u1 = 0,
        _0: u1 = 0,
        BURSTEN: u1 = 0,
        WAITPOL: u1 = 0,
        _1: u1 = 0,
        WAITCFG: u1 = 0,
        WREN: u1 = 0,
        WAITEN: u1 = 0,
        EXTMOD: u1 = 0,
        ASYNCWAIT: u1 = 0,
        CPSIZE: u3 = 0,
        CBURSTRW: u1 = 0,
        _2: u12 = 0,

        pub const set = set_masked;
    },

    BTR2: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        CLKDIV: u4 = 0,
        DATLAT: u4 = 0,
        ACCMOD: u2 = 0,
        _0: u2 = 0,

        pub const set = set_masked;
    },

    BCR3: packed struct {
        MBKEN: u1 = 0,
        MUXEN: u1 = 0,
        MTYP: u2 = 0,
        MWID: u2 = 0,
        FACCEN: u1 = 0,
        _0: u1 = 0,
        BURSTEN: u1 = 0,
        WAITPOL: u1 = 0,
        _1: u1 = 0,
        WAITCFG: u1 = 0,
        WREN: u1 = 0,
        WAITEN: u1 = 0,
        EXTMOD: u1 = 0,
        ASYNCWAIT: u1 = 0,
        CPSIZE: u3 = 0,
        CBURSTRW: u1 = 0,
        _2: u12 = 0,

        pub const set = set_masked;
    },

    BTR3: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        CLKDIV: u4 = 0,
        DATLAT: u4 = 0,
        ACCMOD: u2 = 0,
        _0: u2 = 0,

        pub const set = set_masked;
    },

    BCR4: packed struct {
        MBKEN: u1 = 0,
        MUXEN: u1 = 0,
        MTYP: u2 = 0,
        MWID: u2 = 0,
        FACCEN: u1 = 0,
        _0: u1 = 0,
        BURSTEN: u1 = 0,
        WAITPOL: u1 = 0,
        _1: u1 = 0,
        WAITCFG: u1 = 0,
        WREN: u1 = 0,
        WAITEN: u1 = 0,
        EXTMOD: u1 = 0,
        ASYNCWAIT: u1 = 0,
        CPSIZE: u3 = 0,
        CBURSTRW: u1 = 0,
        _2: u12 = 0,

        pub const set = set_masked;
    },

    BTR4: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        CLKDIV: u4 = 0,
        DATLAT: u4 = 0,
        ACCMOD: u2 = 0,
        _0: u2 = 0,

        pub const set = set_masked;
    },

    _0: u768 = 0,

    PCR: packed struct {
        _0: u1 = 0,
        PWAITEN: u1 = 0,
        PBKEN: u1 = 0,
        PTYP: u1 = 0,
        PWID: u2 = 0,
        ECCEN: u1 = 0,
        _1: u2 = 0,
        TCLR: u4 = 0,
        TAR: u4 = 0,
        ECCPS: u3 = 0,
        _2: u12 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        IRS: u1 = 0,
        ILS: u1 = 0,
        IFS: u1 = 0,
        IREN: u1 = 0,
        ILEN: u1 = 0,
        IFEN: u1 = 0,
        FEMPT: u1 = 0,
        _0: u25 = 0,

        pub const set = set_masked;
    },

    PMEM: packed struct {
        MEMSETx: u8 = 0,
        MEMWAITx: u8 = 0,
        MEMHOLDx: u8 = 0,
        MEMHIZx: u8 = 0,

        pub const set = set_masked;
    },

    PATT: packed struct {
        ATTSETx: u8 = 0,
        ATTWAITx: u8 = 0,
        ATTHOLDx: u8 = 0,
        ATTHIZx: u8 = 0,

        pub const set = set_masked;
    },

    _1: u32 = 0,

    ECCR: packed struct {
        ECCx: u32 = 0,

        pub const set = set_masked;
    },

    _2: u864 = 0,

    BWTR1: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        _0: u8 = 0,
        ACCMOD: u2 = 0,
        _1: u2 = 0,

        pub const set = set_masked;
    },

    _3: u32 = 0,

    BWTR2: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        _0: u8 = 0,
        ACCMOD: u2 = 0,
        _1: u2 = 0,

        pub const set = set_masked;
    },

    _4: u32 = 0,

    BWTR3: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        _0: u8 = 0,
        ACCMOD: u2 = 0,
        _1: u2 = 0,

        pub const set = set_masked;
    },

    _5: u32 = 0,

    BWTR4: packed struct {
        ADDSET: u4 = 0,
        ADDHLD: u4 = 0,
        DATAST: u8 = 0,
        BUSTURN: u4 = 0,
        _0: u8 = 0,
        ACCMOD: u2 = 0,
        _1: u2 = 0,

        pub const set = set_masked;
    },

    _6: u256 = 0,

    SDCR1: packed struct {
        NC: u2 = 0,
        NR: u2 = 0,
        MWID: u2 = 0,
        NB: u1 = 0,
        CAS: u2 = 0,
        WP: u1 = 0,
        SDCLK: u2 = 0,
        RBURST: u1 = 0,
        RPIPE: u2 = 0,
        _0: u17 = 0,

        pub const set = set_masked;
    },

    SDCR2: packed struct {
        NC: u2 = 0,
        NR: u2 = 0,
        MWID: u2 = 0,
        NB: u1 = 0,
        CAS: u2 = 0,
        WP: u1 = 0,
        SDCLK: u2 = 0,
        RBURST: u1 = 0,
        _0: u19 = 0,

        pub const set = set_masked;
    },

    SDTR1: packed struct {
        TMRD: u4 = 0,
        TXSR: u4 = 0,
        TRAS: u4 = 0,
        TRC: u4 = 0,
        TWR: u4 = 0,
        TRP: u4 = 0,
        TRCD: u4 = 0,
        _0: u4 = 0,

        pub const set = set_masked;
    },

    SDTR2: packed struct {
        TMRD: u4 = 0,
        TXSR: u4 = 0,
        TRAS: u4 = 0,
        TRC: u4 = 0,
        TWR: u4 = 0,
        TRP: u4 = 0,
        TRCD: u4 = 0,
        _0: u4 = 0,

        pub const set = set_masked;
    },

    SDCMR: packed struct {
        MODE: u3 = 0,
        CTB2: u1 = 0,
        CTB1: u1 = 0,
        NRFS: u4 = 0,
        MRD: u13 = 0,
        _0: u10 = 0,

        pub const set = set_masked;
    },

    SDRTR: packed struct {
        CRE: u1 = 0,
        COUNT: u13 = 0,
        REIE: u1 = 0,
        _0: u17 = 0,

        pub const set = set_masked;
    },

    SDSR: packed struct {
        _0: u1 = 0,
        MODES1: u2 = 0,
        MODES2: u2 = 0,
        BUSY: u1 = 0,
        _1: u26 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0xa0000000);

pub const TIM9: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        _0: u3 = 0,
        ARPE: u1 = 0,
        CKD: u2 = 0,
        _1: u22 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    SMCR: packed struct {
        SMS: u3 = 0,
        _0: u1 = 0,
        TS: u3 = 0,
        MSM: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    DIER: packed struct {
        UIE: u1 = 0,
        CC1IE: u1 = 0,
        CC2IE: u1 = 0,
        _0: u3 = 0,
        TIE: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        CC1IF: u1 = 0,
        CC2IF: u1 = 0,
        _0: u3 = 0,
        TIF: u1 = 0,
        _1: u2 = 0,
        CC1OF: u1 = 0,
        CC2OF: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        CC1G: u1 = 0,
        CC2G: u1 = 0,
        _0: u3 = 0,
        TG: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    CCMR1: packed union {
        Output: packed struct {
            CC1S: u2 = 0,
            OC1FE: u1 = 0,
            OC1PE: u1 = 0,
            OC1M: u3 = 0,
            _0: u1 = 0,
            CC2S: u2 = 0,
            OC2FE: u1 = 0,
            OC2PE: u1 = 0,
            OC2M: u3 = 0,
            _1: u1 = 0,
            OC1M_3: u1 = 0,
            _2: u7 = 0,
            OC2M_3: u1 = 0,
            _3: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC1S: u2 = 0,
            ICPCS: u2 = 0,
            IC1F: u3 = 0,
            _0: u1 = 0,
            CC2S: u2 = 0,
            IC2PCS: u2 = 0,
            IC2F: u3 = 0,
            _1: u17 = 0,

            pub const set = set_masked;
        },
    },

    _1: u32 = 0,

    CCER: packed struct {
        CC1E: u1 = 0,
        CC1P: u1 = 0,
        _0: u1 = 0,
        CC1NP: u1 = 0,
        CC2E: u1 = 0,
        CC2P: u1 = 0,
        _1: u1 = 0,
        CC2NP: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _2: u32 = 0,

    CCR1: packed struct {
        CCR1: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CCR2: packed struct {
        CCR2: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40014000);

pub const TIM12: @TypeOf(TIM9) = @ptrFromInt(0x40001800);

pub const TIM2: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        DIR: u1 = 0,
        CMS: u2 = 0,
        ARPE: u1 = 0,
        CKD: u2 = 0,
        _0: u1 = 0,
        UIFREMAP: u1 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        _0: u3 = 0,
        CCDS: u1 = 0,
        MMS: u3 = 0,
        TI1S: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    SMCR: packed struct {
        SMS: u3 = 0,
        _0: u1 = 0,
        TS: u3 = 0,
        MSM: u1 = 0,
        ETF: u4 = 0,
        ETPS: u2 = 0,
        ECE: u1 = 0,
        ETP: u1 = 0,
        SMS_3: u1 = 0,
        _1: u15 = 0,

        pub const set = set_masked;
    },

    DIER: packed struct {
        UIE: u1 = 0,
        CC1IE: u1 = 0,
        CC2IE: u1 = 0,
        CC3IE: u1 = 0,
        CC4IE: u1 = 0,
        _0: u1 = 0,
        TIE: u1 = 0,
        _1: u1 = 0,
        UDE: u1 = 0,
        CC1DE: u1 = 0,
        CC2DE: u1 = 0,
        CC3DE: u1 = 0,
        CC4DE: u1 = 0,
        _2: u1 = 0,
        TDE: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        CC1IF: u1 = 0,
        CC2IF: u1 = 0,
        CC3IF: u1 = 0,
        CC4IF: u1 = 0,
        _0: u1 = 0,
        TIF: u1 = 0,
        _1: u2 = 0,
        CC1OF: u1 = 0,
        CC2OF: u1 = 0,
        CC3OF: u1 = 0,
        CC4OF: u1 = 0,
        _2: u19 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        CC1G: u1 = 0,
        CC2G: u1 = 0,
        CC3G: u1 = 0,
        CC4G: u1 = 0,
        _0: u1 = 0,
        TG: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    CCMR1: packed union {
        Output: packed struct {
            CC1S: u2 = 0,
            OC1FE: u1 = 0,
            OC1PE: u1 = 0,
            OC1M: u3 = 0,
            OC1CE: u1 = 0,
            CC2S: u2 = 0,
            OC2FE: u1 = 0,
            OC2PE: u1 = 0,
            OC2M: u3 = 0,
            OC2CE: u1 = 0,
            OC1M_3: u1 = 0,
            _0: u7 = 0,
            OC2M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC1S: u2 = 0,
            ICPCS: u2 = 0,
            IC1F: u4 = 0,
            CC2S: u2 = 0,
            IC2PCS: u2 = 0,
            IC2F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCMR2: packed union {
        Output: packed struct {
            CC3S: u2 = 0,
            OC3FE: u1 = 0,
            OC3PE: u1 = 0,
            OC3M: u3 = 0,
            OC3CE: u1 = 0,
            CC4S: u2 = 0,
            OC4FE: u1 = 0,
            OC4PE: u1 = 0,
            OC4M: u3 = 0,
            O24CE: u1 = 0,
            OC3M_3: u1 = 0,
            _0: u7 = 0,
            OC4M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC3S: u2 = 0,
            IC3PSC: u2 = 0,
            IC3F: u4 = 0,
            CC4S: u2 = 0,
            IC4PSC: u2 = 0,
            IC4F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCER: packed struct {
        CC1E: u1 = 0,
        CC1P: u1 = 0,
        _0: u1 = 0,
        CC1NP: u1 = 0,
        CC2E: u1 = 0,
        CC2P: u1 = 0,
        _1: u1 = 0,
        CC2NP: u1 = 0,
        CC3E: u1 = 0,
        CC3P: u1 = 0,
        _2: u1 = 0,
        CC3NP: u1 = 0,
        CC4E: u1 = 0,
        CC4P: u1 = 0,
        _3: u1 = 0,
        CC4NP: u1 = 0,
        _4: u16 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT_L: u16 = 0,
        CNT_H: u16 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR_L: u16 = 0,
        ARR_H: u16 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    CCR1: packed struct {
        CCR1_L: u16 = 0,
        CCR1_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR2: packed struct {
        CCR2_L: u16 = 0,
        CCR2_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR3: packed struct {
        CCR3_L: u16 = 0,
        CCR3_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR4: packed struct {
        CCR4_L: u16 = 0,
        CCR4_H: u16 = 0,

        pub const set = set_masked;
    },

    _1: u32 = 0,

    DCR: packed struct {
        DBA: u5 = 0,
        _0: u3 = 0,
        DBL: u5 = 0,
        _1: u19 = 0,

        pub const set = set_masked;
    },

    DMAR: packed struct {
        DMAB: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OR: packed struct {
        _0: u10 = 0,
        ITR1_RMP: u2 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40000000);

pub const TIM3: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        DIR: u1 = 0,
        CMS: u2 = 0,
        ARPE: u1 = 0,
        CKD: u2 = 0,
        _0: u1 = 0,
        UIFREMAP: u1 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        _0: u3 = 0,
        CCDS: u1 = 0,
        MMS: u3 = 0,
        TI1S: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    SMCR: packed struct {
        SMS: u3 = 0,
        _0: u1 = 0,
        TS: u3 = 0,
        MSM: u1 = 0,
        ETF: u4 = 0,
        ETPS: u2 = 0,
        ECE: u1 = 0,
        ETP: u1 = 0,
        SMS_3: u1 = 0,
        _1: u15 = 0,

        pub const set = set_masked;
    },

    DIER: packed struct {
        UIE: u1 = 0,
        CC1IE: u1 = 0,
        CC2IE: u1 = 0,
        CC3IE: u1 = 0,
        CC4IE: u1 = 0,
        _0: u1 = 0,
        TIE: u1 = 0,
        _1: u1 = 0,
        UDE: u1 = 0,
        CC1DE: u1 = 0,
        CC2DE: u1 = 0,
        CC3DE: u1 = 0,
        CC4DE: u1 = 0,
        _2: u1 = 0,
        TDE: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        CC1IF: u1 = 0,
        CC2IF: u1 = 0,
        CC3IF: u1 = 0,
        CC4IF: u1 = 0,
        _0: u1 = 0,
        TIF: u1 = 0,
        _1: u2 = 0,
        CC1OF: u1 = 0,
        CC2OF: u1 = 0,
        CC3OF: u1 = 0,
        CC4OF: u1 = 0,
        _2: u19 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        CC1G: u1 = 0,
        CC2G: u1 = 0,
        CC3G: u1 = 0,
        CC4G: u1 = 0,
        _0: u1 = 0,
        TG: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    CCMR1: packed union {
        Output: packed struct {
            CC1S: u2 = 0,
            OC1FE: u1 = 0,
            OC1PE: u1 = 0,
            OC1M: u3 = 0,
            OC1CE: u1 = 0,
            CC2S: u2 = 0,
            OC2FE: u1 = 0,
            OC2PE: u1 = 0,
            OC2M: u3 = 0,
            OC2CE: u1 = 0,
            OC1M_3: u1 = 0,
            _0: u7 = 0,
            OC2M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC1S: u2 = 0,
            ICPCS: u2 = 0,
            IC1F: u4 = 0,
            CC2S: u2 = 0,
            IC2PCS: u2 = 0,
            IC2F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCMR2: packed union {
        Output: packed struct {
            CC3S: u2 = 0,
            OC3FE: u1 = 0,
            OC3PE: u1 = 0,
            OC3M: u3 = 0,
            OC3CE: u1 = 0,
            CC4S: u2 = 0,
            OC4FE: u1 = 0,
            OC4PE: u1 = 0,
            OC4M: u3 = 0,
            O24CE: u1 = 0,
            OC3M_3: u1 = 0,
            _0: u7 = 0,
            OC4M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC3S: u2 = 0,
            IC3PSC: u2 = 0,
            IC3F: u4 = 0,
            CC4S: u2 = 0,
            IC4PSC: u2 = 0,
            IC4F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCER: packed struct {
        CC1E: u1 = 0,
        CC1P: u1 = 0,
        _0: u1 = 0,
        CC1NP: u1 = 0,
        CC2E: u1 = 0,
        CC2P: u1 = 0,
        _1: u1 = 0,
        CC2NP: u1 = 0,
        CC3E: u1 = 0,
        CC3P: u1 = 0,
        _2: u1 = 0,
        CC3NP: u1 = 0,
        CC4E: u1 = 0,
        CC4P: u1 = 0,
        _3: u1 = 0,
        CC4NP: u1 = 0,
        _4: u16 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT_L: u16 = 0,
        CNT_H: u16 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR_L: u16 = 0,
        ARR_H: u16 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    CCR1: packed struct {
        CCR1_L: u16 = 0,
        CCR1_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR2: packed struct {
        CCR2_L: u16 = 0,
        CCR2_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR3: packed struct {
        CCR3_L: u16 = 0,
        CCR3_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR4: packed struct {
        CCR4_L: u16 = 0,
        CCR4_H: u16 = 0,

        pub const set = set_masked;
    },

    _1: u32 = 0,

    DCR: packed struct {
        DBA: u5 = 0,
        _0: u3 = 0,
        DBL: u5 = 0,
        _1: u19 = 0,

        pub const set = set_masked;
    },

    DMAR: packed struct {
        DMAB: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40000400);

pub const TIM4: @TypeOf(TIM3) = @ptrFromInt(0x40000800);

pub const TIM5: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        DIR: u1 = 0,
        CMS: u2 = 0,
        ARPE: u1 = 0,
        CKD: u2 = 0,
        _0: u1 = 0,
        UIFREMAP: u1 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        _0: u3 = 0,
        CCDS: u1 = 0,
        MMS: u3 = 0,
        TI1S: u1 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },

    SMCR: packed struct {
        SMS: u3 = 0,
        _0: u1 = 0,
        TS: u3 = 0,
        MSM: u1 = 0,
        ETF: u4 = 0,
        ETPS: u2 = 0,
        ECE: u1 = 0,
        ETP: u1 = 0,
        SMS_3: u1 = 0,
        _1: u15 = 0,

        pub const set = set_masked;
    },

    DIER: packed struct {
        UIE: u1 = 0,
        CC1IE: u1 = 0,
        CC2IE: u1 = 0,
        CC3IE: u1 = 0,
        CC4IE: u1 = 0,
        _0: u1 = 0,
        TIE: u1 = 0,
        _1: u1 = 0,
        UDE: u1 = 0,
        CC1DE: u1 = 0,
        CC2DE: u1 = 0,
        CC3DE: u1 = 0,
        CC4DE: u1 = 0,
        _2: u1 = 0,
        TDE: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        CC1IF: u1 = 0,
        CC2IF: u1 = 0,
        CC3IF: u1 = 0,
        CC4IF: u1 = 0,
        _0: u1 = 0,
        TIF: u1 = 0,
        _1: u2 = 0,
        CC1OF: u1 = 0,
        CC2OF: u1 = 0,
        CC3OF: u1 = 0,
        CC4OF: u1 = 0,
        _2: u19 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        CC1G: u1 = 0,
        CC2G: u1 = 0,
        CC3G: u1 = 0,
        CC4G: u1 = 0,
        _0: u1 = 0,
        TG: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    CCMR1: packed union {
        Output: packed struct {
            CC1S: u2 = 0,
            OC1FE: u1 = 0,
            OC1PE: u1 = 0,
            OC1M: u3 = 0,
            OC1CE: u1 = 0,
            CC2S: u2 = 0,
            OC2FE: u1 = 0,
            OC2PE: u1 = 0,
            OC2M: u3 = 0,
            OC2CE: u1 = 0,
            OC1M_3: u1 = 0,
            _0: u7 = 0,
            OC2M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC1S: u2 = 0,
            ICPCS: u2 = 0,
            IC1F: u4 = 0,
            CC2S: u2 = 0,
            IC2PCS: u2 = 0,
            IC2F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCMR2: packed union {
        Output: packed struct {
            CC3S: u2 = 0,
            OC3FE: u1 = 0,
            OC3PE: u1 = 0,
            OC3M: u3 = 0,
            OC3CE: u1 = 0,
            CC4S: u2 = 0,
            OC4FE: u1 = 0,
            OC4PE: u1 = 0,
            OC4M: u3 = 0,
            O24CE: u1 = 0,
            OC3M_3: u1 = 0,
            _0: u7 = 0,
            OC4M_3: u1 = 0,
            _1: u7 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC3S: u2 = 0,
            IC3PSC: u2 = 0,
            IC3F: u4 = 0,
            CC4S: u2 = 0,
            IC4PSC: u2 = 0,
            IC4F: u4 = 0,
            _0: u16 = 0,

            pub const set = set_masked;
        },
    },

    CCER: packed struct {
        CC1E: u1 = 0,
        CC1P: u1 = 0,
        _0: u1 = 0,
        CC1NP: u1 = 0,
        CC2E: u1 = 0,
        CC2P: u1 = 0,
        _1: u1 = 0,
        CC2NP: u1 = 0,
        CC3E: u1 = 0,
        CC3P: u1 = 0,
        _2: u1 = 0,
        CC3NP: u1 = 0,
        CC4E: u1 = 0,
        CC4P: u1 = 0,
        _3: u1 = 0,
        CC4NP: u1 = 0,
        _4: u16 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT_L: u16 = 0,
        CNT_H: u16 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR_L: u16 = 0,
        ARR_H: u16 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    CCR1: packed struct {
        CCR1_L: u16 = 0,
        CCR1_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR2: packed struct {
        CCR2_L: u16 = 0,
        CCR2_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR3: packed struct {
        CCR3_L: u16 = 0,
        CCR3_H: u16 = 0,

        pub const set = set_masked;
    },

    CCR4: packed struct {
        CCR4_L: u16 = 0,
        CCR4_H: u16 = 0,

        pub const set = set_masked;
    },

    _1: u32 = 0,

    DCR: packed struct {
        DBA: u5 = 0,
        _0: u3 = 0,
        DBL: u5 = 0,
        _1: u19 = 0,

        pub const set = set_masked;
    },

    DMAR: packed struct {
        DMAB: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OR: packed struct {
        _0: u6 = 0,
        TI4_RMP: u2 = 0,
        _1: u24 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40000c00);

pub const GPIOH: *volatile packed struct {
    MODER: packed struct {
        MODER0: u2 = 0,
        MODER1: u2 = 0,
        MODER2: u2 = 0,
        MODER3: u2 = 0,
        MODER4: u2 = 0,
        MODER5: u2 = 0,
        MODER6: u2 = 0,
        MODER7: u2 = 0,
        MODER8: u2 = 0,
        MODER9: u2 = 0,
        MODER10: u2 = 0,
        MODER11: u2 = 0,
        MODER12: u2 = 0,
        MODER13: u2 = 0,
        MODER14: u2 = 0,
        MODER15: u2 = 0,

        pub const set = set_masked;
    },

    OTYPER: packed struct {
        OT0: u1 = 0,
        OT1: u1 = 0,
        OT2: u1 = 0,
        OT3: u1 = 0,
        OT4: u1 = 0,
        OT5: u1 = 0,
        OT6: u1 = 0,
        OT7: u1 = 0,
        OT8: u1 = 0,
        OT9: u1 = 0,
        OT10: u1 = 0,
        OT11: u1 = 0,
        OT12: u1 = 0,
        OT13: u1 = 0,
        OT14: u1 = 0,
        OT15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OSPEEDR: packed struct {
        OSPEEDR0: u2 = 0,
        OSPEEDR1: u2 = 0,
        OSPEEDR2: u2 = 0,
        OSPEEDR3: u2 = 0,
        OSPEEDR4: u2 = 0,
        OSPEEDR5: u2 = 0,
        OSPEEDR6: u2 = 0,
        OSPEEDR7: u2 = 0,
        OSPEEDR8: u2 = 0,
        OSPEEDR9: u2 = 0,
        OSPEEDR10: u2 = 0,
        OSPEEDR11: u2 = 0,
        OSPEEDR12: u2 = 0,
        OSPEEDR13: u2 = 0,
        OSPEEDR14: u2 = 0,
        OSPEEDR15: u2 = 0,

        pub const set = set_masked;
    },

    PUPDR: packed struct {
        PUPDR0: u2 = 0,
        PUPDR1: u2 = 0,
        PUPDR2: u2 = 0,
        PUPDR3: u2 = 0,
        PUPDR4: u2 = 0,
        PUPDR5: u2 = 0,
        PUPDR6: u2 = 0,
        PUPDR7: u2 = 0,
        PUPDR8: u2 = 0,
        PUPDR9: u2 = 0,
        PUPDR10: u2 = 0,
        PUPDR11: u2 = 0,
        PUPDR12: u2 = 0,
        PUPDR13: u2 = 0,
        PUPDR14: u2 = 0,
        PUPDR15: u2 = 0,

        pub const set = set_masked;
    },

    IDR: packed struct {
        IDR0: u1 = 0,
        IDR1: u1 = 0,
        IDR2: u1 = 0,
        IDR3: u1 = 0,
        IDR4: u1 = 0,
        IDR5: u1 = 0,
        IDR6: u1 = 0,
        IDR7: u1 = 0,
        IDR8: u1 = 0,
        IDR9: u1 = 0,
        IDR10: u1 = 0,
        IDR11: u1 = 0,
        IDR12: u1 = 0,
        IDR13: u1 = 0,
        IDR14: u1 = 0,
        IDR15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ODR: packed struct {
        ODR0: u1 = 0,
        ODR1: u1 = 0,
        ODR2: u1 = 0,
        ODR3: u1 = 0,
        ODR4: u1 = 0,
        ODR5: u1 = 0,
        ODR6: u1 = 0,
        ODR7: u1 = 0,
        ODR8: u1 = 0,
        ODR9: u1 = 0,
        ODR10: u1 = 0,
        ODR11: u1 = 0,
        ODR12: u1 = 0,
        ODR13: u1 = 0,
        ODR14: u1 = 0,
        ODR15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    BSRR: packed struct {
        BS0: u1 = 0,
        BS1: u1 = 0,
        BS2: u1 = 0,
        BS3: u1 = 0,
        BS4: u1 = 0,
        BS5: u1 = 0,
        BS6: u1 = 0,
        BS7: u1 = 0,
        BS8: u1 = 0,
        BS9: u1 = 0,
        BS10: u1 = 0,
        BS11: u1 = 0,
        BS12: u1 = 0,
        BS13: u1 = 0,
        BS14: u1 = 0,
        BS15: u1 = 0,
        BR0: u1 = 0,
        BR1: u1 = 0,
        BR2: u1 = 0,
        BR3: u1 = 0,
        BR4: u1 = 0,
        BR5: u1 = 0,
        BR6: u1 = 0,
        BR7: u1 = 0,
        BR8: u1 = 0,
        BR9: u1 = 0,
        BR10: u1 = 0,
        BR11: u1 = 0,
        BR12: u1 = 0,
        BR13: u1 = 0,
        BR14: u1 = 0,
        BR15: u1 = 0,

        pub const set = set_masked;
    },

    LCKR: packed struct {
        LCK0: u1 = 0,
        LCK1: u1 = 0,
        LCK2: u1 = 0,
        LCK3: u1 = 0,
        LCK4: u1 = 0,
        LCK5: u1 = 0,
        LCK6: u1 = 0,
        LCK7: u1 = 0,
        LCK8: u1 = 0,
        LCK9: u1 = 0,
        LCK10: u1 = 0,
        LCK11: u1 = 0,
        LCK12: u1 = 0,
        LCK13: u1 = 0,
        LCK14: u1 = 0,
        LCK15: u1 = 0,
        LCKK: u1 = 0,
        _0: u15 = 0,

        pub const set = set_masked;
    },

    AFRL: packed struct {
        AFRL0: u4 = 0,
        AFRL1: u4 = 0,
        AFRL2: u4 = 0,
        AFRL3: u4 = 0,
        AFRL4: u4 = 0,
        AFRL5: u4 = 0,
        AFRL6: u4 = 0,
        AFRL7: u4 = 0,

        pub const set = set_masked;
    },

    AFRH: packed struct {
        AFRH8: u4 = 0,
        AFRH9: u4 = 0,
        AFRH10: u4 = 0,
        AFRH11: u4 = 0,
        AFRH12: u4 = 0,
        AFRH13: u4 = 0,
        AFRH14: u4 = 0,
        AFRH15: u4 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40021c00);

pub const GPIOF: @TypeOf(GPIOH) = @ptrFromInt(0x40021400);

pub const GPIOG: @TypeOf(GPIOH) = @ptrFromInt(0x40021800);

pub const GPIOI: @TypeOf(GPIOH) = @ptrFromInt(0x40022000);

pub const GPIOE: @TypeOf(GPIOH) = @ptrFromInt(0x40021000);

pub const GPIOD: @TypeOf(GPIOH) = @ptrFromInt(0x40020c00);

pub const GPIOC: @TypeOf(GPIOH) = @ptrFromInt(0x40020800);

pub const GPIOB: *volatile packed struct {
    MODER: packed struct {
        MODER0: u2 = 0,
        MODER1: u2 = 0,
        MODER2: u2 = 0,
        MODER3: u2 = 0,
        MODER4: u2 = 0,
        MODER5: u2 = 0,
        MODER6: u2 = 0,
        MODER7: u2 = 0,
        MODER8: u2 = 0,
        MODER9: u2 = 0,
        MODER10: u2 = 0,
        MODER11: u2 = 0,
        MODER12: u2 = 0,
        MODER13: u2 = 0,
        MODER14: u2 = 0,
        MODER15: u2 = 0,

        pub const set = set_masked;
    },

    OTYPER: packed struct {
        OT0: u1 = 0,
        OT1: u1 = 0,
        OT2: u1 = 0,
        OT3: u1 = 0,
        OT4: u1 = 0,
        OT5: u1 = 0,
        OT6: u1 = 0,
        OT7: u1 = 0,
        OT8: u1 = 0,
        OT9: u1 = 0,
        OT10: u1 = 0,
        OT11: u1 = 0,
        OT12: u1 = 0,
        OT13: u1 = 0,
        OT14: u1 = 0,
        OT15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OSPEEDR: packed struct {
        OSPEEDR0: u2 = 0,
        OSPEEDR1: u2 = 0,
        OSPEEDR2: u2 = 0,
        OSPEEDR3: u2 = 0,
        OSPEEDR4: u2 = 0,
        OSPEEDR5: u2 = 0,
        OSPEEDR6: u2 = 0,
        OSPEEDR7: u2 = 0,
        OSPEEDR8: u2 = 0,
        OSPEEDR9: u2 = 0,
        OSPEEDR10: u2 = 0,
        OSPEEDR11: u2 = 0,
        OSPEEDR12: u2 = 0,
        OSPEEDR13: u2 = 0,
        OSPEEDR14: u2 = 0,
        OSPEEDR15: u2 = 0,

        pub const set = set_masked;
    },

    PUPDR: packed struct {
        PUPDR0: u2 = 0,
        PUPDR1: u2 = 0,
        PUPDR2: u2 = 0,
        PUPDR3: u2 = 0,
        PUPDR4: u2 = 0,
        PUPDR5: u2 = 0,
        PUPDR6: u2 = 0,
        PUPDR7: u2 = 0,
        PUPDR8: u2 = 0,
        PUPDR9: u2 = 0,
        PUPDR10: u2 = 0,
        PUPDR11: u2 = 0,
        PUPDR12: u2 = 0,
        PUPDR13: u2 = 0,
        PUPDR14: u2 = 0,
        PUPDR15: u2 = 0,

        pub const set = set_masked;
    },

    IDR: packed struct {
        IDR0: u1 = 0,
        IDR1: u1 = 0,
        IDR2: u1 = 0,
        IDR3: u1 = 0,
        IDR4: u1 = 0,
        IDR5: u1 = 0,
        IDR6: u1 = 0,
        IDR7: u1 = 0,
        IDR8: u1 = 0,
        IDR9: u1 = 0,
        IDR10: u1 = 0,
        IDR11: u1 = 0,
        IDR12: u1 = 0,
        IDR13: u1 = 0,
        IDR14: u1 = 0,
        IDR15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ODR: packed struct {
        ODR0: u1 = 0,
        ODR1: u1 = 0,
        ODR2: u1 = 0,
        ODR3: u1 = 0,
        ODR4: u1 = 0,
        ODR5: u1 = 0,
        ODR6: u1 = 0,
        ODR7: u1 = 0,
        ODR8: u1 = 0,
        ODR9: u1 = 0,
        ODR10: u1 = 0,
        ODR11: u1 = 0,
        ODR12: u1 = 0,
        ODR13: u1 = 0,
        ODR14: u1 = 0,
        ODR15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    BSRR: packed struct {
        BS0: u1 = 0,
        BS1: u1 = 0,
        BS2: u1 = 0,
        BS3: u1 = 0,
        BS4: u1 = 0,
        BS5: u1 = 0,
        BS6: u1 = 0,
        BS7: u1 = 0,
        BS8: u1 = 0,
        BS9: u1 = 0,
        BS10: u1 = 0,
        BS11: u1 = 0,
        BS12: u1 = 0,
        BS13: u1 = 0,
        BS14: u1 = 0,
        BS15: u1 = 0,
        BR0: u1 = 0,
        BR1: u1 = 0,
        BR2: u1 = 0,
        BR3: u1 = 0,
        BR4: u1 = 0,
        BR5: u1 = 0,
        BR6: u1 = 0,
        BR7: u1 = 0,
        BR8: u1 = 0,
        BR9: u1 = 0,
        BR10: u1 = 0,
        BR11: u1 = 0,
        BR12: u1 = 0,
        BR13: u1 = 0,
        BR14: u1 = 0,
        BR15: u1 = 0,

        pub const set = set_masked;
    },

    LCKR: packed struct {
        LCK0: u1 = 0,
        LCK1: u1 = 0,
        LCK2: u1 = 0,
        LCK3: u1 = 0,
        LCK4: u1 = 0,
        LCK5: u1 = 0,
        LCK6: u1 = 0,
        LCK7: u1 = 0,
        LCK8: u1 = 0,
        LCK9: u1 = 0,
        LCK10: u1 = 0,
        LCK11: u1 = 0,
        LCK12: u1 = 0,
        LCK13: u1 = 0,
        LCK14: u1 = 0,
        LCK15: u1 = 0,
        LCKK: u1 = 0,
        _0: u15 = 0,

        pub const set = set_masked;
    },

    AFRL: packed struct {
        AFRL0: u4 = 0,
        AFRL1: u4 = 0,
        AFRL2: u4 = 0,
        AFRL3: u4 = 0,
        AFRL4: u4 = 0,
        AFRL5: u4 = 0,
        AFRL6: u4 = 0,
        AFRL7: u4 = 0,

        pub const set = set_masked;
    },

    AFRH: packed struct {
        AFRH8: u4 = 0,
        AFRH9: u4 = 0,
        AFRH10: u4 = 0,
        AFRH11: u4 = 0,
        AFRH12: u4 = 0,
        AFRH13: u4 = 0,
        AFRH14: u4 = 0,
        AFRH15: u4 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40020400);

pub const GPIOA: *volatile packed struct {
    MODER: packed struct {
        MODER0: u2 = 0,
        MODER1: u2 = 0,
        MODER2: u2 = 0,
        MODER3: u2 = 0,
        MODER4: u2 = 0,
        MODER5: u2 = 0,
        MODER6: u2 = 0,
        MODER7: u2 = 0,
        MODER8: u2 = 0,
        MODER9: u2 = 0,
        MODER10: u2 = 0,
        MODER11: u2 = 0,
        MODER12: u2 = 0,
        MODER13: u2 = 0,
        MODER14: u2 = 0,
        MODER15: u2 = 0,

        pub const set = set_masked;
    },

    OTYPER: packed struct {
        OT0: u1 = 0,
        OT1: u1 = 0,
        OT2: u1 = 0,
        OT3: u1 = 0,
        OT4: u1 = 0,
        OT5: u1 = 0,
        OT6: u1 = 0,
        OT7: u1 = 0,
        OT8: u1 = 0,
        OT9: u1 = 0,
        OT10: u1 = 0,
        OT11: u1 = 0,
        OT12: u1 = 0,
        OT13: u1 = 0,
        OT14: u1 = 0,
        OT15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OSPEEDR: packed struct {
        OSPEEDR0: u2 = 0,
        OSPEEDR1: u2 = 0,
        OSPEEDR2: u2 = 0,
        OSPEEDR3: u2 = 0,
        OSPEEDR4: u2 = 0,
        OSPEEDR5: u2 = 0,
        OSPEEDR6: u2 = 0,
        OSPEEDR7: u2 = 0,
        OSPEEDR8: u2 = 0,
        OSPEEDR9: u2 = 0,
        OSPEEDR10: u2 = 0,
        OSPEEDR11: u2 = 0,
        OSPEEDR12: u2 = 0,
        OSPEEDR13: u2 = 0,
        OSPEEDR14: u2 = 0,
        OSPEEDR15: u2 = 0,

        pub const set = set_masked;
    },

    PUPDR: packed struct {
        PUPDR0: u2 = 0,
        PUPDR1: u2 = 0,
        PUPDR2: u2 = 0,
        PUPDR3: u2 = 0,
        PUPDR4: u2 = 0,
        PUPDR5: u2 = 0,
        PUPDR6: u2 = 0,
        PUPDR7: u2 = 0,
        PUPDR8: u2 = 0,
        PUPDR9: u2 = 0,
        PUPDR10: u2 = 0,
        PUPDR11: u2 = 0,
        PUPDR12: u2 = 0,
        PUPDR13: u2 = 0,
        PUPDR14: u2 = 0,
        PUPDR15: u2 = 0,

        pub const set = set_masked;
    },

    IDR: packed struct {
        IDR0: u1 = 0,
        IDR1: u1 = 0,
        IDR2: u1 = 0,
        IDR3: u1 = 0,
        IDR4: u1 = 0,
        IDR5: u1 = 0,
        IDR6: u1 = 0,
        IDR7: u1 = 0,
        IDR8: u1 = 0,
        IDR9: u1 = 0,
        IDR10: u1 = 0,
        IDR11: u1 = 0,
        IDR12: u1 = 0,
        IDR13: u1 = 0,
        IDR14: u1 = 0,
        IDR15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ODR: packed struct {
        ODR0: u1 = 0,
        ODR1: u1 = 0,
        ODR2: u1 = 0,
        ODR3: u1 = 0,
        ODR4: u1 = 0,
        ODR5: u1 = 0,
        ODR6: u1 = 0,
        ODR7: u1 = 0,
        ODR8: u1 = 0,
        ODR9: u1 = 0,
        ODR10: u1 = 0,
        ODR11: u1 = 0,
        ODR12: u1 = 0,
        ODR13: u1 = 0,
        ODR14: u1 = 0,
        ODR15: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    BSRR: packed struct {
        BS0: u1 = 0,
        BS1: u1 = 0,
        BS2: u1 = 0,
        BS3: u1 = 0,
        BS4: u1 = 0,
        BS5: u1 = 0,
        BS6: u1 = 0,
        BS7: u1 = 0,
        BS8: u1 = 0,
        BS9: u1 = 0,
        BS10: u1 = 0,
        BS11: u1 = 0,
        BS12: u1 = 0,
        BS13: u1 = 0,
        BS14: u1 = 0,
        BS15: u1 = 0,
        BR0: u1 = 0,
        BR1: u1 = 0,
        BR2: u1 = 0,
        BR3: u1 = 0,
        BR4: u1 = 0,
        BR5: u1 = 0,
        BR6: u1 = 0,
        BR7: u1 = 0,
        BR8: u1 = 0,
        BR9: u1 = 0,
        BR10: u1 = 0,
        BR11: u1 = 0,
        BR12: u1 = 0,
        BR13: u1 = 0,
        BR14: u1 = 0,
        BR15: u1 = 0,

        pub const set = set_masked;
    },

    LCKR: packed struct {
        LCK0: u1 = 0,
        LCK1: u1 = 0,
        LCK2: u1 = 0,
        LCK3: u1 = 0,
        LCK4: u1 = 0,
        LCK5: u1 = 0,
        LCK6: u1 = 0,
        LCK7: u1 = 0,
        LCK8: u1 = 0,
        LCK9: u1 = 0,
        LCK10: u1 = 0,
        LCK11: u1 = 0,
        LCK12: u1 = 0,
        LCK13: u1 = 0,
        LCK14: u1 = 0,
        LCK15: u1 = 0,
        LCKK: u1 = 0,
        _0: u15 = 0,

        pub const set = set_masked;
    },

    AFRL: packed struct {
        AFRL0: u4 = 0,
        AFRL1: u4 = 0,
        AFRL2: u4 = 0,
        AFRL3: u4 = 0,
        AFRL4: u4 = 0,
        AFRL5: u4 = 0,
        AFRL6: u4 = 0,
        AFRL7: u4 = 0,

        pub const set = set_masked;
    },

    AFRH: packed struct {
        AFRH8: u4 = 0,
        AFRH9: u4 = 0,
        AFRH10: u4 = 0,
        AFRH11: u4 = 0,
        AFRH12: u4 = 0,
        AFRH13: u4 = 0,
        AFRH14: u4 = 0,
        AFRH15: u4 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40020000);

pub const TIM13: *volatile packed struct {
    CR1: packed struct {
        CEN: u1 = 0,
        UDIS: u1 = 0,
        URS: u1 = 0,
        OPM: u1 = 0,
        _0: u3 = 0,
        ARPE: u1 = 0,
        CKD: u2 = 0,
        _1: u22 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    SMCR: packed struct {
        Res: u32 = 0,

        pub const set = set_masked;
    },

    DIER: packed struct {
        UIE: u1 = 0,
        CC1IE: u1 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        UIF: u1 = 0,
        CC1IF: u1 = 0,
        _0: u7 = 0,
        CC1OF: u1 = 0,
        _1: u22 = 0,

        pub const set = set_masked;
    },

    EGR: packed struct {
        UG: u1 = 0,
        CC1G: u1 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    CCMR1: packed union {
        Output: packed struct {
            CC1S: u2 = 0,
            OC1FE: u1 = 0,
            OC1PE: u1 = 0,
            OC1M: u3 = 0,
            _0: u9 = 0,
            OC1M_3: u1 = 0,
            _1: u15 = 0,

            pub const set = set_masked;
        },

        Input: packed struct {
            CC1S: u2 = 0,
            ICPCS: u2 = 0,
            IC1F: u4 = 0,
            _0: u24 = 0,

            pub const set = set_masked;
        },
    },

    _1: u32 = 0,

    CCER: packed struct {
        CC1E: u1 = 0,
        CC1P: u1 = 0,
        _0: u1 = 0,
        CC1NP: u1 = 0,
        _1: u28 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    PSC: packed struct {
        PSC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _2: u32 = 0,

    CCR1: packed struct {
        CCR1: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _3: u192 = 0,

    OR: packed struct {
        TI1_RMP: u2 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40001c00);

pub const TIM14: @TypeOf(TIM13) = @ptrFromInt(0x40002000);

pub const TIM10: @TypeOf(TIM13) = @ptrFromInt(0x40014400);

pub const TIM11: @TypeOf(TIM13) = @ptrFromInt(0x40014800);

pub const IWDG: *volatile packed struct {
    KR: packed struct {
        KEY: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    PR: packed struct {
        PR: u3 = 0,
        _0: u29 = 0,

        pub const set = set_masked;
    },

    RLR: packed struct {
        RL: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        PVU: u1 = 0,
        RVU: u1 = 0,
        WVU: u1 = 0,
        _0: u29 = 0,

        pub const set = set_masked;
    },

    WINR: packed struct {
        WIN: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40003000);

pub const I2C1: *volatile packed struct {
    CR1: packed struct {
        PE: u1 = 0,
        TXIE: u1 = 0,
        RXIE: u1 = 0,
        ADDRIE: u1 = 0,
        NACKIE: u1 = 0,
        STOPIE: u1 = 0,
        TCIE: u1 = 0,
        ERRIE: u1 = 0,
        DNF: u4 = 0,
        ANFOFF: u1 = 0,
        _0: u1 = 0,
        TXDMAEN: u1 = 0,
        RXDMAEN: u1 = 0,
        SBC: u1 = 0,
        NOSTRETCH: u1 = 0,
        _1: u1 = 0,
        GCEN: u1 = 0,
        SMBHEN: u1 = 0,
        SMBDEN: u1 = 0,
        ALERTEN: u1 = 0,
        PECEN: u1 = 0,
        _2: u8 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        SADD: u10 = 0,
        RD_WRN: u1 = 0,
        ADD10: u1 = 0,
        HEAD10R: u1 = 0,
        START: u1 = 0,
        STOP: u1 = 0,
        NACK: u1 = 0,
        NBYTES: u8 = 0,
        RELOAD: u1 = 0,
        AUTOEND: u1 = 0,
        PECBYTE: u1 = 0,
        _0: u5 = 0,

        pub const set = set_masked;
    },

    OAR1: packed struct {
        OA1: u10 = 0,
        OA1MODE: u1 = 0,
        _0: u4 = 0,
        OA1EN: u1 = 0,
        _1: u16 = 0,

        pub const set = set_masked;
    },

    OAR2: packed struct {
        _0: u1 = 0,
        OA2: u7 = 0,
        OA2MSK: u3 = 0,
        _1: u4 = 0,
        OA2EN: u1 = 0,
        _2: u16 = 0,

        pub const set = set_masked;
    },

    TIMINGR: packed struct {
        SCLL: u8 = 0,
        SCLH: u8 = 0,
        SDADEL: u4 = 0,
        SCLDEL: u4 = 0,
        _0: u4 = 0,
        PRESC: u4 = 0,

        pub const set = set_masked;
    },

    TIMEOUTR: packed struct {
        TIMEOUTA: u12 = 0,
        TIDLE: u1 = 0,
        _0: u2 = 0,
        TIMOUTEN: u1 = 0,
        TIMEOUTB: u12 = 0,
        _1: u3 = 0,
        TEXTEN: u1 = 0,

        pub const set = set_masked;
    },

    ISR: packed struct {
        TXE: u1 = 0,
        TXIS: u1 = 0,
        RXNE: u1 = 0,
        ADDR: u1 = 0,
        NACKF: u1 = 0,
        STOPF: u1 = 0,
        TC: u1 = 0,
        TCR: u1 = 0,
        BERR: u1 = 0,
        ARLO: u1 = 0,
        OVR: u1 = 0,
        PECERR: u1 = 0,
        TIMEOUT: u1 = 0,
        ALERT: u1 = 0,
        _0: u1 = 0,
        BUSY: u1 = 0,
        DIR: u1 = 0,
        ADDCODE: u7 = 0,
        _1: u8 = 0,

        pub const set = set_masked;
    },

    ICR: packed struct {
        _0: u3 = 0,
        ADDRCF: u1 = 0,
        NACKCF: u1 = 0,
        STOPCF: u1 = 0,
        _1: u2 = 0,
        BERRCF: u1 = 0,
        ARLOCF: u1 = 0,
        OVRCF: u1 = 0,
        PECCF: u1 = 0,
        TIMOUTCF: u1 = 0,
        ALERTCF: u1 = 0,
        _2: u18 = 0,

        pub const set = set_masked;
    },

    PECR: packed struct {
        PEC: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    RXDR: packed struct {
        RXDATA: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    TXDR: packed struct {
        TXDATA: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40005400);

pub const I2C2: @TypeOf(I2C1) = @ptrFromInt(0x40005800);

pub const I2C3: @TypeOf(I2C1) = @ptrFromInt(0x40005c00);

pub const LPTIM1: *volatile packed struct {
    ISR: packed struct {
        CMPM: u1 = 0,
        ARRM: u1 = 0,
        EXTTRIG: u1 = 0,
        CMPOK: u1 = 0,
        ARROK: u1 = 0,
        UP: u1 = 0,
        DOWN: u1 = 0,
        _0: u25 = 0,

        pub const set = set_masked;
    },

    ICR: packed struct {
        CMPMCF: u1 = 0,
        ARRMCF: u1 = 0,
        EXTTRIGCF: u1 = 0,
        CMPOKCF: u1 = 0,
        ARROKCF: u1 = 0,
        UPCF: u1 = 0,
        DOWNCF: u1 = 0,
        _0: u25 = 0,

        pub const set = set_masked;
    },

    IER: packed struct {
        CMPMIE: u1 = 0,
        ARRMIE: u1 = 0,
        EXTTRIGIE: u1 = 0,
        CMPOKIE: u1 = 0,
        ARROKIE: u1 = 0,
        UPIE: u1 = 0,
        DOWNIE: u1 = 0,
        _0: u25 = 0,

        pub const set = set_masked;
    },

    CFGR: packed struct {
        CKSEL: u1 = 0,
        CKPOL: u2 = 0,
        CKFLT: u2 = 0,
        _0: u1 = 0,
        TRGFLT: u2 = 0,
        _1: u1 = 0,
        PRESC: u3 = 0,
        _2: u1 = 0,
        TRIGSEL: u3 = 0,
        _3: u1 = 0,
        TRIGEN: u2 = 0,
        TIMOUT: u1 = 0,
        WAVE: u1 = 0,
        WAVPOL: u1 = 0,
        PRELOAD: u1 = 0,
        COUNTMODE: u1 = 0,
        ENC: u1 = 0,
        _4: u7 = 0,

        pub const set = set_masked;
    },

    CR: packed struct {
        ENABLE: u1 = 0,
        SNGSTRT: u1 = 0,
        CNTSTRT: u1 = 0,
        _0: u29 = 0,

        pub const set = set_masked;
    },

    CMP: packed struct {
        CMP: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    ARR: packed struct {
        ARR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CNT: packed struct {
        CNT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40002400);

pub const PWR: *volatile packed struct {
    CR1: packed struct {
        LPDS: u1 = 0,
        PDDS: u1 = 0,
        _0: u1 = 0,
        CSBF: u1 = 0,
        PVDE: u1 = 0,
        PLS: u3 = 0,
        DBP: u1 = 0,
        FPDS: u1 = 0,
        LPUDS: u1 = 0,
        MRUDS: u1 = 0,
        _1: u1 = 0,
        ADCDC1: u1 = 0,
        VOS: u2 = 0,
        ODEN: u1 = 0,
        ODSWEN: u1 = 0,
        UDEN: u2 = 0,
        _2: u12 = 0,

        pub const set = set_masked;
    },

    CSR1: packed struct {
        WUIF: u1 = 0,
        SBF: u1 = 0,
        PVDO: u1 = 0,
        BRR: u1 = 0,
        _0: u4 = 0,
        EIWUP: u1 = 0,
        BRE: u1 = 0,
        _1: u4 = 0,
        VOSRDY: u1 = 0,
        _2: u1 = 0,
        ODRDY: u1 = 0,
        ODSWRDY: u1 = 0,
        UDRDY: u2 = 0,
        _3: u12 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        CWUPF1: u1 = 0,
        CWUPF2: u1 = 0,
        CWUPF3: u1 = 0,
        CWUPF4: u1 = 0,
        CWUPF5: u1 = 0,
        CWUPF6: u1 = 0,
        _0: u2 = 0,
        WUPP1: u1 = 0,
        WUPP2: u1 = 0,
        WUPP3: u1 = 0,
        WUPP4: u1 = 0,
        WUPP5: u1 = 0,
        WUPP6: u1 = 0,
        _1: u18 = 0,

        pub const set = set_masked;
    },

    CSR2: packed struct {
        WUPF1: u1 = 0,
        WUPF2: u1 = 0,
        WUPF3: u1 = 0,
        WUPF4: u1 = 0,
        WUPF5: u1 = 0,
        WUPF6: u1 = 0,
        _0: u2 = 0,
        EWUP1: u1 = 0,
        EWUP2: u1 = 0,
        EWUP3: u1 = 0,
        EWUP4: u1 = 0,
        EWUP5: u1 = 0,
        EWUP6: u1 = 0,
        _1: u18 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40007000);

pub const QUADSPI: *volatile packed struct {
    CR: packed struct {
        EN: u1 = 0,
        ABORT: u1 = 0,
        DMAEN: u1 = 0,
        TCEN: u1 = 0,
        SSHIFT: u1 = 0,
        _0: u1 = 0,
        DFM: u1 = 0,
        FSEL: u1 = 0,
        FTHRES: u5 = 0,
        _1: u3 = 0,
        TEIE: u1 = 0,
        TCIE: u1 = 0,
        FTIE: u1 = 0,
        SMIE: u1 = 0,
        TOIE: u1 = 0,
        _2: u1 = 0,
        APMS: u1 = 0,
        PMM: u1 = 0,
        PRESCALER: u8 = 0,

        pub const set = set_masked;
    },

    DCR: packed struct {
        CKMODE: u1 = 0,
        _0: u7 = 0,
        CSHT: u3 = 0,
        _1: u5 = 0,
        FSIZE: u5 = 0,
        _2: u11 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        TEF: u1 = 0,
        TCF: u1 = 0,
        FTF: u1 = 0,
        SMF: u1 = 0,
        TOF: u1 = 0,
        BUSY: u1 = 0,
        _0: u2 = 0,
        FLEVEL: u7 = 0,
        _1: u17 = 0,

        pub const set = set_masked;
    },

    FCR: packed struct {
        CTEF: u1 = 0,
        CTCF: u1 = 0,
        _0: u1 = 0,
        CSMF: u1 = 0,
        CTOF: u1 = 0,
        _1: u27 = 0,

        pub const set = set_masked;
    },

    DLR: packed struct {
        DL: u32 = 0,

        pub const set = set_masked;
    },

    CCR: packed struct {
        INSTRUCTION: u8 = 0,
        IMODE: u2 = 0,
        ADMODE: u2 = 0,
        ADSIZE: u2 = 0,
        ABMODE: u2 = 0,
        ABSIZE: u2 = 0,
        DCYC: u5 = 0,
        _0: u1 = 0,
        DMODE: u2 = 0,
        FMODE: u2 = 0,
        SIOO: u1 = 0,
        _1: u1 = 0,
        DHHC: u1 = 0,
        DDRM: u1 = 0,

        pub const set = set_masked;
    },

    AR: packed struct {
        ADDRESS: u32 = 0,

        pub const set = set_masked;
    },

    ABR: packed struct {
        ALTERNATE: u32 = 0,

        pub const set = set_masked;
    },

    DR: packed struct {
        DATA: u32 = 0,

        pub const set = set_masked;
    },

    PSMKR: packed struct {
        MASK: u32 = 0,

        pub const set = set_masked;
    },

    PSMAR: packed struct {
        MATCH: u32 = 0,

        pub const set = set_masked;
    },

    PIR: packed struct {
        INTERVAL: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    LPTR: packed struct {
        TIMEOUT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0xa0001000);

pub const RNG: *volatile packed struct {
    CR: packed struct {
        _0: u2 = 0,
        RNGEN: u1 = 0,
        IE: u1 = 0,
        _1: u28 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        DRDY: u1 = 0,
        CECS: u1 = 0,
        SECS: u1 = 0,
        _0: u2 = 0,
        CEIS: u1 = 0,
        SEIS: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    DR: packed struct {
        RNDATA: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x50060800);

pub const RTC: *volatile packed struct {
    TR: packed struct {
        SU: u4 = 0,
        ST: u3 = 0,
        _0: u1 = 0,
        MNU: u4 = 0,
        MNT: u3 = 0,
        _1: u1 = 0,
        HU: u4 = 0,
        HT: u2 = 0,
        PM: u1 = 0,
        _2: u9 = 0,

        pub const set = set_masked;
    },

    DR: packed struct {
        DU: u4 = 0,
        DT: u2 = 0,
        _0: u2 = 0,
        MU: u4 = 0,
        MT: u1 = 0,
        WDU: u3 = 0,
        YU: u4 = 0,
        YT: u4 = 0,
        _1: u8 = 0,

        pub const set = set_masked;
    },

    CR: packed struct {
        WCKSEL: u3 = 0,
        TSEDGE: u1 = 0,
        REFCKON: u1 = 0,
        BYPSHAD: u1 = 0,
        FMT: u1 = 0,
        _0: u1 = 0,
        ALRAE: u1 = 0,
        ALRBE: u1 = 0,
        WUTE: u1 = 0,
        TSE: u1 = 0,
        ALRAIE: u1 = 0,
        ALRBIE: u1 = 0,
        WUTIE: u1 = 0,
        TSIE: u1 = 0,
        ADD1H: u1 = 0,
        SUB1H: u1 = 0,
        BKP: u1 = 0,
        COSEL: u1 = 0,
        POL: u1 = 0,
        OSEL: u2 = 0,
        COE: u1 = 0,
        ITSE: u1 = 0,
        _1: u7 = 0,

        pub const set = set_masked;
    },

    ISR: packed struct {
        ALRAWF: u1 = 0,
        ALRBWF: u1 = 0,
        WUTWF: u1 = 0,
        SHPF: u1 = 0,
        INITS: u1 = 0,
        RSF: u1 = 0,
        INITF: u1 = 0,
        INIT: u1 = 0,
        ALRAF: u1 = 0,
        ALRBF: u1 = 0,
        WUTF: u1 = 0,
        TSF: u1 = 0,
        TSOVF: u1 = 0,
        TAMP1F: u1 = 0,
        TAMP2F: u1 = 0,
        TAMP3F: u1 = 0,
        RECALPF: u1 = 0,
        ITSF: u1 = 0,
        _0: u14 = 0,

        pub const set = set_masked;
    },

    PRER: packed struct {
        PREDIV_S: u15 = 0,
        _0: u1 = 0,
        PREDIV_A: u7 = 0,
        _1: u9 = 0,

        pub const set = set_masked;
    },

    WUTR: packed struct {
        WUT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    ALRMAR: packed struct {
        SU: u4 = 0,
        ST: u3 = 0,
        MSK1: u1 = 0,
        MNU: u4 = 0,
        MNT: u3 = 0,
        MSK2: u1 = 0,
        HU: u4 = 0,
        HT: u2 = 0,
        PM: u1 = 0,
        MSK3: u1 = 0,
        DU: u4 = 0,
        DT: u2 = 0,
        WDSEL: u1 = 0,
        MSK4: u1 = 0,

        pub const set = set_masked;
    },

    ALRMBR: packed struct {
        SU: u4 = 0,
        ST: u3 = 0,
        MSK1: u1 = 0,
        MNU: u4 = 0,
        MNT: u3 = 0,
        MSK2: u1 = 0,
        HU: u4 = 0,
        HT: u2 = 0,
        PM: u1 = 0,
        MSK3: u1 = 0,
        DU: u4 = 0,
        DT: u2 = 0,
        WDSEL: u1 = 0,
        MSK4: u1 = 0,

        pub const set = set_masked;
    },

    WPR: packed struct {
        KEY: u8 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    SSR: packed struct {
        SS: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    SHIFTR: packed struct {
        SUBFS: u15 = 0,
        _0: u16 = 0,
        ADD1S: u1 = 0,

        pub const set = set_masked;
    },

    TSTR: packed struct {
        SU: u4 = 0,
        ST: u3 = 0,
        _0: u1 = 0,
        MNU: u4 = 0,
        MNT: u3 = 0,
        _1: u1 = 0,
        HU: u4 = 0,
        HT: u2 = 0,
        PM: u1 = 0,
        _2: u9 = 0,

        pub const set = set_masked;
    },

    TSDR: packed struct {
        DU: u4 = 0,
        DT: u2 = 0,
        _0: u2 = 0,
        MU: u4 = 0,
        MT: u1 = 0,
        WDU: u3 = 0,
        _1: u16 = 0,

        pub const set = set_masked;
    },

    TSSSR: packed struct {
        SS: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CALR: packed struct {
        CALM: u9 = 0,
        _0: u4 = 0,
        CALW16: u1 = 0,
        CALW8: u1 = 0,
        CALP: u1 = 0,
        _1: u16 = 0,

        pub const set = set_masked;
    },

    TAMPCR: packed struct {
        TAMP1E: u1 = 0,
        TAMP1TRG: u1 = 0,
        TAMPIE: u1 = 0,
        TAMP2E: u1 = 0,
        TAMP2TRG: u1 = 0,
        TAMP3E: u1 = 0,
        TAMP3TRG: u1 = 0,
        TAMPTS: u1 = 0,
        TAMPFREQ: u3 = 0,
        TAMPFLT: u2 = 0,
        TAMPPRCH: u2 = 0,
        TAMPPUDIS: u1 = 0,
        TAMP1IE: u1 = 0,
        TAMP1NOERASE: u1 = 0,
        TAMP1MF: u1 = 0,
        TAMP2IE: u1 = 0,
        TAMP2NOERASE: u1 = 0,
        TAMP2MF: u1 = 0,
        TAMP3IE: u1 = 0,
        TAMP3NOERASE: u1 = 0,
        TAMP3MF: u1 = 0,
        _0: u7 = 0,

        pub const set = set_masked;
    },

    ALRMASSR: packed struct {
        SS: u15 = 0,
        _0: u9 = 0,
        MASKSS: u4 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    ALRMBSSR: packed struct {
        SS: u15 = 0,
        _0: u9 = 0,
        MASKSS: u4 = 0,
        _1: u4 = 0,

        pub const set = set_masked;
    },

    OR: packed struct {
        _0: u1 = 0,
        TSINSEL: u1 = 0,
        _1: u1 = 0,
        RTC_ALARM_TYPE: u1 = 0,
        _2: u28 = 0,

        pub const set = set_masked;
    },

    BKP0R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP1R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP2R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP3R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP4R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP5R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP6R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP7R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP8R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP9R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP10R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP11R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP12R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP13R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP14R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP15R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP16R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP17R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP18R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP19R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP20R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP21R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP22R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP23R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP24R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP25R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP26R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP27R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP28R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP29R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP30R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },

    BKP31R: packed struct {
        BKP: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40002800);

pub const RCC: *volatile packed struct {
    CR: packed struct {
        HSION: u1 = 0,
        HSIRDY: u1 = 0,
        _0: u1 = 0,
        HSITRIM: u5 = 0,
        HSICAL: u8 = 0,
        HSEON: u1 = 0,
        HSERDY: u1 = 0,
        HSEBYP: u1 = 0,
        CSSON: u1 = 0,
        _1: u4 = 0,
        PLLON: u1 = 0,
        PLLRDY: u1 = 0,
        PLLI2SON: u1 = 0,
        PLLI2SRDY: u1 = 0,
        PLLSAION: u1 = 0,
        PLLSAIRDY: u1 = 0,
        _2: u2 = 0,

        pub const set = set_masked;
    },

    PLLCFGR: packed struct {
        PLLM: u6 = 0,
        PLLN: u9 = 0,
        _0: u1 = 0,
        PLLP: u2 = 0,
        _1: u4 = 0,
        PLLSRC: u1 = 0,
        _2: u1 = 0,
        PLLQ: u4 = 0,
        _3: u4 = 0,

        pub const set = set_masked;
    },

    CFGR: packed struct {
        SW: u2 = 0,
        SWS: u2 = 0,
        HPRE: u4 = 0,
        _0: u2 = 0,
        PPRE1: u3 = 0,
        PPRE2: u3 = 0,
        RTCPRE: u5 = 0,
        MCO1: u2 = 0,
        I2SSRC: u1 = 0,
        MCO1PRE: u3 = 0,
        MCO2PRE: u3 = 0,
        MCO2: u2 = 0,

        pub const set = set_masked;
    },

    CIR: packed struct {
        LSIRDYF: u1 = 0,
        LSERDYF: u1 = 0,
        HSIRDYF: u1 = 0,
        HSERDYF: u1 = 0,
        PLLRDYF: u1 = 0,
        PLLI2SRDYF: u1 = 0,
        PLLSAIRDYF: u1 = 0,
        CSSF: u1 = 0,
        LSIRDYIE: u1 = 0,
        LSERDYIE: u1 = 0,
        HSIRDYIE: u1 = 0,
        HSERDYIE: u1 = 0,
        PLLRDYIE: u1 = 0,
        PLLI2SRDYIE: u1 = 0,
        PLLSAIRDYIE: u1 = 0,
        _0: u1 = 0,
        LSIRDYC: u1 = 0,
        LSERDYC: u1 = 0,
        HSIRDYC: u1 = 0,
        HSERDYC: u1 = 0,
        PLLRDYC: u1 = 0,
        PLLI2SRDYC: u1 = 0,
        PLLSAIRDYC: u1 = 0,
        CSSC: u1 = 0,
        _1: u8 = 0,

        pub const set = set_masked;
    },

    AHB1RSTR: packed struct {
        GPIOARST: u1 = 0,
        GPIOBRST: u1 = 0,
        GPIOCRST: u1 = 0,
        GPIODRST: u1 = 0,
        GPIOERST: u1 = 0,
        GPIOFRST: u1 = 0,
        GPIOGRST: u1 = 0,
        GPIOHRST: u1 = 0,
        GPIOIRST: u1 = 0,
        _0: u3 = 0,
        CRCRST: u1 = 0,
        _1: u8 = 0,
        DMA1RST: u1 = 0,
        DMA2RST: u1 = 0,
        _2: u6 = 0,
        OTGHSRST: u1 = 0,
        _3: u2 = 0,

        pub const set = set_masked;
    },

    AHB2RSTR: packed struct {
        _0: u4 = 0,
        AESRST: u1 = 0,
        _1: u1 = 0,
        RNGRST: u1 = 0,
        OTGFSRST: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    AHB3RSTR: packed struct {
        FMCRST: u1 = 0,
        QSPIRST: u1 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    APB1RSTR: packed struct {
        TIM2RST: u1 = 0,
        TIM3RST: u1 = 0,
        TIM4RST: u1 = 0,
        TIM5RST: u1 = 0,
        TIM6RST: u1 = 0,
        TIM7RST: u1 = 0,
        TIM12RST: u1 = 0,
        TIM13RST: u1 = 0,
        TIM14RST: u1 = 0,
        LPTIM1RST: u1 = 0,
        _0: u1 = 0,
        WWDGRST: u1 = 0,
        _1: u2 = 0,
        SPI2RST: u1 = 0,
        SPI3RST: u1 = 0,
        _2: u1 = 0,
        UART2RST: u1 = 0,
        UART3RST: u1 = 0,
        UART4RST: u1 = 0,
        UART5RST: u1 = 0,
        I2C1RST: u1 = 0,
        I2C2RST: u1 = 0,
        I2C3RST: u1 = 0,
        _3: u1 = 0,
        CAN1RST: u1 = 0,
        _4: u1 = 0,
        CECRST: u1 = 0,
        PWRRST: u1 = 0,
        DACRST: u1 = 0,
        UART7RST: u1 = 0,
        UART8RST: u1 = 0,

        pub const set = set_masked;
    },

    APB2RSTR: packed struct {
        TIM1RST: u1 = 0,
        TIM8RST: u1 = 0,
        _0: u2 = 0,
        USART1RST: u1 = 0,
        USART6RST: u1 = 0,
        _1: u1 = 0,
        SDMMC2RST: u1 = 0,
        ADCRST: u1 = 0,
        _2: u2 = 0,
        SDMMC1RST: u1 = 0,
        SPI1RST: u1 = 0,
        SPI4RST: u1 = 0,
        SYSCFGRST: u1 = 0,
        _3: u1 = 0,
        TIM9RST: u1 = 0,
        TIM10RST: u1 = 0,
        TIM11RST: u1 = 0,
        _4: u1 = 0,
        SPI5RST: u1 = 0,
        _5: u1 = 0,
        SAI1RST: u1 = 0,
        SAI2RST: u1 = 0,
        _6: u7 = 0,
        USBPHYCRST: u1 = 0,

        pub const set = set_masked;
    },

    _1: u64 = 0,

    AHB1ENR: packed struct {
        GPIOAEN: u1 = 0,
        GPIOBEN: u1 = 0,
        GPIOCEN: u1 = 0,
        GPIODEN: u1 = 0,
        GPIOEEN: u1 = 0,
        GPIOFEN: u1 = 0,
        GPIOGEN: u1 = 0,
        GPIOHEN: u1 = 0,
        GPIOIEN: u1 = 0,
        _0: u3 = 0,
        CRCEN: u1 = 0,
        _1: u5 = 0,
        BKPSRAMEN: u1 = 0,
        _2: u1 = 0,
        DTCMRAMEN: u1 = 0,
        DMA1EN: u1 = 0,
        DMA2EN: u1 = 0,
        _3: u6 = 0,
        OTGHSEN: u1 = 0,
        OTGHSULPIEN: u1 = 0,
        _4: u1 = 0,

        pub const set = set_masked;
    },

    AHB2ENR: packed struct {
        _0: u4 = 0,
        AESEN: u1 = 0,
        _1: u1 = 0,
        RNGEN: u1 = 0,
        OTGFSEN: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    AHB3ENR: packed struct {
        FMCEN: u1 = 0,
        QSPIEN: u1 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    _2: u32 = 0,

    APB1ENR: packed struct {
        TIM2EN: u1 = 0,
        TIM3EN: u1 = 0,
        TIM4EN: u1 = 0,
        TIM5EN: u1 = 0,
        TIM6EN: u1 = 0,
        TIM7EN: u1 = 0,
        TIM12EN: u1 = 0,
        TIM13EN: u1 = 0,
        TIM14EN: u1 = 0,
        LPTIM1EN: u1 = 0,
        RTCAPBEN: u1 = 0,
        WWDGEN: u1 = 0,
        _0: u2 = 0,
        SPI2EN: u1 = 0,
        SPI3EN: u1 = 0,
        _1: u1 = 0,
        USART2EN: u1 = 0,
        USART3EN: u1 = 0,
        UART4EN: u1 = 0,
        UART5EN: u1 = 0,
        I2C1EN: u1 = 0,
        I2C2EN: u1 = 0,
        I2C3EN: u1 = 0,
        _2: u1 = 0,
        CAN1EN: u1 = 0,
        _3: u2 = 0,
        PWREN: u1 = 0,
        DACEN: u1 = 0,
        UART7EN: u1 = 0,
        UART8EN: u1 = 0,

        pub const set = set_masked;
    },

    APB2ENR: packed struct {
        TIM1EN: u1 = 0,
        TIM8EN: u1 = 0,
        _0: u2 = 0,
        USART1EN: u1 = 0,
        USART6EN: u1 = 0,
        _1: u1 = 0,
        SDMMC2EN: u1 = 0,
        ADC1EN: u1 = 0,
        ADC2EN: u1 = 0,
        ADC3EN: u1 = 0,
        SDMMC1EN: u1 = 0,
        SPI1EN: u1 = 0,
        SPI4EN: u1 = 0,
        SYSCFGEN: u1 = 0,
        _2: u1 = 0,
        TIM9EN: u1 = 0,
        TIM10EN: u1 = 0,
        TIM11EN: u1 = 0,
        _3: u1 = 0,
        SPI5EN: u1 = 0,
        _4: u1 = 0,
        SAI1EN: u1 = 0,
        SAI2EN: u1 = 0,
        _5: u7 = 0,
        USBPHYCEN: u1 = 0,

        pub const set = set_masked;
    },

    _3: u64 = 0,

    AHB1LPENR: packed struct {
        GPIOALPEN: u1 = 0,
        GPIOBLPEN: u1 = 0,
        GPIOCLPEN: u1 = 0,
        GPIODLPEN: u1 = 0,
        GPIOELPEN: u1 = 0,
        GPIOFLPEN: u1 = 0,
        GPIOGLPEN: u1 = 0,
        GPIOHLPEN: u1 = 0,
        GPIOILPEN: u1 = 0,
        GPIOJLPEN: u1 = 0,
        GPIOKLPEN: u1 = 0,
        _0: u1 = 0,
        CRCLPEN: u1 = 0,
        AXILPEN: u1 = 0,
        _1: u1 = 0,
        FLITFLPEN: u1 = 0,
        SRAM1LPEN: u1 = 0,
        SRAM2LPEN: u1 = 0,
        BKPSRAMLPEN: u1 = 0,
        SRAM3LPEN: u1 = 0,
        DTCMLPEN: u1 = 0,
        DMA1LPEN: u1 = 0,
        DMA2LPEN: u1 = 0,
        DMA2DLPEN: u1 = 0,
        _2: u1 = 0,
        ETHMACLPEN: u1 = 0,
        ETHMACTXLPEN: u1 = 0,
        ETHMACRXLPEN: u1 = 0,
        ETHMACPTPLPEN: u1 = 0,
        OTGHSLPEN: u1 = 0,
        OTGHSULPILPEN: u1 = 0,
        _3: u1 = 0,

        pub const set = set_masked;
    },

    AHB2LPENR: packed struct {
        _0: u4 = 0,
        AESLPEN: u1 = 0,
        _1: u1 = 0,
        RNGLPEN: u1 = 0,
        OTGFSLPEN: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    AHB3LPENR: packed struct {
        FMCLPEN: u1 = 0,
        QSPILPEN: u1 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    _4: u32 = 0,

    APB1LPENR: packed struct {
        TIM2LPEN: u1 = 0,
        TIM3LPEN: u1 = 0,
        TIM4LPEN: u1 = 0,
        TIM5LPEN: u1 = 0,
        TIM6LPEN: u1 = 0,
        TIM7LPEN: u1 = 0,
        TIM12LPEN: u1 = 0,
        TIM13LPEN: u1 = 0,
        TIM14LPEN: u1 = 0,
        LPTIM1LPEN: u1 = 0,
        _0: u1 = 0,
        WWDGLPEN: u1 = 0,
        _1: u2 = 0,
        SPI2LPEN: u1 = 0,
        SPI3LPEN: u1 = 0,
        _2: u1 = 0,
        USART2LPEN: u1 = 0,
        USART3LPEN: u1 = 0,
        UART4LPEN: u1 = 0,
        UART5LPEN: u1 = 0,
        I2C1LPEN: u1 = 0,
        I2C2LPEN: u1 = 0,
        I2C3LPEN: u1 = 0,
        _3: u1 = 0,
        CAN1LPEN: u1 = 0,
        CAN2LPEN: u1 = 0,
        _4: u1 = 0,
        PWRLPEN: u1 = 0,
        DACLPEN: u1 = 0,
        UART7LPEN: u1 = 0,
        UART8LPEN: u1 = 0,

        pub const set = set_masked;
    },

    APB2LPENR: packed struct {
        TIM1LPEN: u1 = 0,
        TIM8LPEN: u1 = 0,
        _0: u2 = 0,
        USART1LPEN: u1 = 0,
        USART6LPEN: u1 = 0,
        _1: u1 = 0,
        SDMMC2LPEN: u1 = 0,
        ADC1LPEN: u1 = 0,
        ADC2LPEN: u1 = 0,
        ADC3LPEN: u1 = 0,
        SDMMC1LPEN: u1 = 0,
        SPI1LPEN: u1 = 0,
        SPI4LPEN: u1 = 0,
        SYSCFGLPEN: u1 = 0,
        _2: u1 = 0,
        TIM9LPEN: u1 = 0,
        TIM10LPEN: u1 = 0,
        TIM11LPEN: u1 = 0,
        _3: u1 = 0,
        SPI5LPEN: u1 = 0,
        _4: u1 = 0,
        SAI1LPEN: u1 = 0,
        SAI2LPEN: u1 = 0,
        _5: u8 = 0,

        pub const set = set_masked;
    },

    _5: u64 = 0,

    BDCR: packed struct {
        LSEON: u1 = 0,
        LSERDY: u1 = 0,
        LSEBYP: u1 = 0,
        _0: u5 = 0,
        RTCSEL0: u1 = 0,
        RTCSEL1: u1 = 0,
        _1: u5 = 0,
        RTCEN: u1 = 0,
        BDRST: u1 = 0,
        _2: u15 = 0,

        pub const set = set_masked;
    },

    CSR: packed struct {
        LSION: u1 = 0,
        LSIRDY: u1 = 0,
        _0: u22 = 0,
        RMVF: u1 = 0,
        BORRSTF: u1 = 0,
        PADRSTF: u1 = 0,
        PORRSTF: u1 = 0,
        SFTRSTF: u1 = 0,
        WDGRSTF: u1 = 0,
        WWDGRSTF: u1 = 0,
        LPWRRSTF: u1 = 0,

        pub const set = set_masked;
    },

    _6: u64 = 0,

    SSCGR: packed struct {
        MODPER: u13 = 0,
        INCSTEP: u15 = 0,
        _0: u2 = 0,
        SPREADSEL: u1 = 0,
        SSCGEN: u1 = 0,

        pub const set = set_masked;
    },

    PLLI2SCFGR: packed struct {
        _0: u6 = 0,
        PLLI2SN: u9 = 0,
        _1: u9 = 0,
        PLLI2SQ: u4 = 0,
        PLLI2SR: u3 = 0,
        _2: u1 = 0,

        pub const set = set_masked;
    },

    PLLSAICFGR: packed struct {
        _0: u6 = 0,
        PLLSAIN: u9 = 0,
        _1: u1 = 0,
        PLLSAIP: u2 = 0,
        _2: u6 = 0,
        PLLSAIQ: u4 = 0,
        _3: u4 = 0,

        pub const set = set_masked;
    },

    DCKCFGR1: packed struct {
        PLLI2SDIV: u5 = 0,
        _0: u3 = 0,
        PLLSAIDIVQ: u5 = 0,
        _1: u7 = 0,
        SAI1SEL: u2 = 0,
        SAI2SEL: u2 = 0,
        TIMPRE: u1 = 0,
        _2: u7 = 0,

        pub const set = set_masked;
    },

    DCKCFGR2: packed struct {
        UART1SEL: u2 = 0,
        UART2SEL: u2 = 0,
        UART3SEL: u2 = 0,
        UART4SEL: u2 = 0,
        UART5SEL: u2 = 0,
        UART6SEL: u2 = 0,
        UART7SEL: u2 = 0,
        UART8SEL: u2 = 0,
        I2C1SEL: u2 = 0,
        I2C2SEL: u2 = 0,
        I2C3SEL: u2 = 0,
        _0: u2 = 0,
        LPTIM1SEL: u2 = 0,
        _1: u1 = 0,
        CK48MSEL: u1 = 0,
        SDMMC1SEL: u1 = 0,
        SDMMC2SEL: u1 = 0,
        _2: u2 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40023800);

pub const SDMMC1: *volatile packed struct {
    POWER: packed struct {
        PWRCTRL: u2 = 0,
        _0: u30 = 0,

        pub const set = set_masked;
    },

    CLKCR: packed struct {
        CLKDIV: u8 = 0,
        CLKEN: u1 = 0,
        PWRSAV: u1 = 0,
        BYPASS: u1 = 0,
        WIDBUS: u2 = 0,
        NEGEDGE: u1 = 0,
        HWFC_EN: u1 = 0,
        _0: u17 = 0,

        pub const set = set_masked;
    },

    ARG: packed struct {
        CMDARG: u32 = 0,

        pub const set = set_masked;
    },

    CMD: packed struct {
        CMDINDEX: u6 = 0,
        WAITRESP: u2 = 0,
        WAITINT: u1 = 0,
        WAITPEND: u1 = 0,
        CPSMEN: u1 = 0,
        SDIOSuspend: u1 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    RESPCMD: packed struct {
        RESPCMD: u6 = 0,
        _0: u26 = 0,

        pub const set = set_masked;
    },

    RESP1: packed struct {
        CARDSTATUS1: u32 = 0,

        pub const set = set_masked;
    },

    RESP2: packed struct {
        CARDSTATUS2: u32 = 0,

        pub const set = set_masked;
    },

    RESP3: packed struct {
        CARDSTATUS3: u32 = 0,

        pub const set = set_masked;
    },

    RESP4: packed struct {
        CARDSTATUS4: u32 = 0,

        pub const set = set_masked;
    },

    DTIMER: packed struct {
        DATATIME: u32 = 0,

        pub const set = set_masked;
    },

    DLEN: packed struct {
        DATALENGTH: u25 = 0,
        _0: u7 = 0,

        pub const set = set_masked;
    },

    DCTRL: packed struct {
        DTEN: u1 = 0,
        DTDIR: u1 = 0,
        DTMODE: u1 = 0,
        DMAEN: u1 = 0,
        DBLOCKSIZE: u4 = 0,
        RWSTART: u1 = 0,
        RWSTOP: u1 = 0,
        RWMOD: u1 = 0,
        SDIOEN: u1 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    DCOUNT: packed struct {
        DATACOUNT: u25 = 0,
        _0: u7 = 0,

        pub const set = set_masked;
    },

    STA: packed struct {
        CCRCFAIL: u1 = 0,
        DCRCFAIL: u1 = 0,
        CTIMEOUT: u1 = 0,
        DTIMEOUT: u1 = 0,
        TXUNDERR: u1 = 0,
        RXOVERR: u1 = 0,
        CMDREND: u1 = 0,
        CMDSENT: u1 = 0,
        DATAEND: u1 = 0,
        _0: u1 = 0,
        DBCKEND: u1 = 0,
        CMDACT: u1 = 0,
        TXACT: u1 = 0,
        RXACT: u1 = 0,
        TXFIFOHE: u1 = 0,
        RXFIFOHF: u1 = 0,
        TXFIFOF: u1 = 0,
        RXFIFOF: u1 = 0,
        TXFIFOE: u1 = 0,
        RXFIFOE: u1 = 0,
        TXDAVL: u1 = 0,
        RXDAVL: u1 = 0,
        SDIOIT: u1 = 0,
        _1: u9 = 0,

        pub const set = set_masked;
    },

    ICR: packed struct {
        CCRCFAILC: u1 = 0,
        DCRCFAILC: u1 = 0,
        CTIMEOUTC: u1 = 0,
        DTIMEOUTC: u1 = 0,
        TXUNDERRC: u1 = 0,
        RXOVERRC: u1 = 0,
        CMDRENDC: u1 = 0,
        CMDSENTC: u1 = 0,
        DATAENDC: u1 = 0,
        _0: u1 = 0,
        DBCKENDC: u1 = 0,
        _1: u11 = 0,
        SDIOITC: u1 = 0,
        _2: u9 = 0,

        pub const set = set_masked;
    },

    MASK: packed struct {
        CCRCFAILIE: u1 = 0,
        DCRCFAILIE: u1 = 0,
        CTIMEOUTIE: u1 = 0,
        DTIMEOUTIE: u1 = 0,
        TXUNDERRIE: u1 = 0,
        RXOVERRIE: u1 = 0,
        CMDRENDIE: u1 = 0,
        CMDSENTIE: u1 = 0,
        DATAENDIE: u1 = 0,
        _0: u1 = 0,
        DBCKENDIE: u1 = 0,
        CMDACTIE: u1 = 0,
        TXACTIE: u1 = 0,
        RXACTIE: u1 = 0,
        TXFIFOHEIE: u1 = 0,
        RXFIFOHFIE: u1 = 0,
        TXFIFOFIE: u1 = 0,
        RXFIFOFIE: u1 = 0,
        TXFIFOEIE: u1 = 0,
        RXFIFOEIE: u1 = 0,
        TXDAVLIE: u1 = 0,
        RXDAVLIE: u1 = 0,
        SDIOITIE: u1 = 0,
        _1: u9 = 0,

        pub const set = set_masked;
    },

    _0: u64 = 0,

    FIFOCNT: packed struct {
        FIFOCOUNT: u24 = 0,
        _0: u8 = 0,

        pub const set = set_masked;
    },

    _1: u416 = 0,

    FIFO: packed struct {
        FIFOData: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40012c00);

pub const SDMMC2: @TypeOf(SDMMC1) = @ptrFromInt(0x40011c00);

pub const SAI1: *volatile packed struct {
    GCR: packed struct {
        SYNCIN: u2 = 0,
        _0: u2 = 0,
        SYNCOUT: u2 = 0,
        _1: u26 = 0,

        pub const set = set_masked;
    },

    ACR1: packed struct {
        MODE: u2 = 0,
        PRTCFG: u2 = 0,
        _0: u1 = 0,
        DS: u3 = 0,
        LSBFIRST: u1 = 0,
        CKSTR: u1 = 0,
        SYNCEN: u2 = 0,
        MONO: u1 = 0,
        OUTDRIV: u1 = 0,
        _1: u2 = 0,
        SAIXEN: u1 = 0,
        DMAEN: u1 = 0,
        _2: u1 = 0,
        NODIV: u1 = 0,
        MCKDIV: u4 = 0,
        _3: u8 = 0,

        pub const set = set_masked;
    },

    ACR2: packed struct {
        FTH: u3 = 0,
        FFLUS: u1 = 0,
        TRIS: u1 = 0,
        MUTE: u1 = 0,
        MUTEVAL: u1 = 0,
        MUTECN: u6 = 0,
        CPL: u1 = 0,
        COMP: u2 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    AFRCR: packed struct {
        FRL: u8 = 0,
        FSALL: u7 = 0,
        _0: u1 = 0,
        FSDEF: u1 = 0,
        FSPOL: u1 = 0,
        FSOFF: u1 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    ASLOTR: packed struct {
        FBOFF: u5 = 0,
        _0: u1 = 0,
        SLOTSZ: u2 = 0,
        NBSLOT: u4 = 0,
        _1: u4 = 0,
        SLOTEN: u16 = 0,

        pub const set = set_masked;
    },

    AIM: packed struct {
        OVRUDRIE: u1 = 0,
        MUTEDETIE: u1 = 0,
        WCKCFGIE: u1 = 0,
        FREQIE: u1 = 0,
        CNRDYIE: u1 = 0,
        AFSDETIE: u1 = 0,
        LFSDETIE: u1 = 0,
        _0: u25 = 0,

        pub const set = set_masked;
    },

    ASR: packed struct {
        OVRUDR: u1 = 0,
        MUTEDET: u1 = 0,
        WCKCFG: u1 = 0,
        FREQ: u1 = 0,
        CNRDY: u1 = 0,
        AFSDET: u1 = 0,
        LFSDET: u1 = 0,
        _0: u9 = 0,
        FLVL: u3 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    ACLRFR: packed struct {
        COVRUDR: u1 = 0,
        CMUTEDET: u1 = 0,
        CWCKCFG: u1 = 0,
        _0: u1 = 0,
        CCNRDY: u1 = 0,
        CAFSDET: u1 = 0,
        CLFSDET: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    ADR: packed struct {
        DATA: u32 = 0,

        pub const set = set_masked;
    },

    BCR1: packed struct {
        MODE: u2 = 0,
        PRTCFG: u2 = 0,
        _0: u1 = 0,
        DS: u3 = 0,
        LSBFIRST: u1 = 0,
        CKSTR: u1 = 0,
        SYNCEN: u2 = 0,
        MONO: u1 = 0,
        OUTDRIV: u1 = 0,
        _1: u2 = 0,
        SAIXEN: u1 = 0,
        DMAEN: u1 = 0,
        _2: u1 = 0,
        NODIV: u1 = 0,
        MCKDIV: u4 = 0,
        _3: u8 = 0,

        pub const set = set_masked;
    },

    BCR2: packed struct {
        FTH: u3 = 0,
        FFLUS: u1 = 0,
        TRIS: u1 = 0,
        MUTE: u1 = 0,
        MUTEVAL: u1 = 0,
        MUTECN: u6 = 0,
        CPL: u1 = 0,
        COMP: u2 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    BFRCR: packed struct {
        FRL: u8 = 0,
        FSALL: u7 = 0,
        _0: u1 = 0,
        FSDEF: u1 = 0,
        FSPOL: u1 = 0,
        FSOFF: u1 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    BSLOTR: packed struct {
        FBOFF: u5 = 0,
        _0: u1 = 0,
        SLOTSZ: u2 = 0,
        NBSLOT: u4 = 0,
        _1: u4 = 0,
        SLOTEN: u16 = 0,

        pub const set = set_masked;
    },

    BIM: packed struct {
        OVRUDRIE: u1 = 0,
        MUTEDETIE: u1 = 0,
        WCKCFGIE: u1 = 0,
        FREQIE: u1 = 0,
        CNRDYIE: u1 = 0,
        AFSDETIE: u1 = 0,
        LFSDETIE: u1 = 0,
        _0: u25 = 0,

        pub const set = set_masked;
    },

    BSR: packed struct {
        OVRUDR: u1 = 0,
        MUTEDET: u1 = 0,
        WCKCFG: u1 = 0,
        FREQ: u1 = 0,
        CNRDY: u1 = 0,
        AFSDET: u1 = 0,
        LFSDET: u1 = 0,
        _0: u9 = 0,
        FLVL: u3 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    BCLRFR: packed struct {
        COVRUDR: u1 = 0,
        CMUTEDET: u1 = 0,
        CWCKCFG: u1 = 0,
        _0: u1 = 0,
        CCNRDY: u1 = 0,
        CAFSDET: u1 = 0,
        CLFSDET: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    BDR: packed struct {
        DATA: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40015800);

pub const SAI2: @TypeOf(SAI1) = @ptrFromInt(0x40015c00);

pub const SPI5: *volatile packed struct {
    CR1: packed struct {
        CPHA: u1 = 0,
        CPOL: u1 = 0,
        MSTR: u1 = 0,
        BR: u3 = 0,
        SPE: u1 = 0,
        LSBFIRST: u1 = 0,
        SSI: u1 = 0,
        SSM: u1 = 0,
        RXONLY: u1 = 0,
        CRCL: u1 = 0,
        CRCNEXT: u1 = 0,
        CRCEN: u1 = 0,
        BIDIOE: u1 = 0,
        BIDIMODE: u1 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        RXDMAEN: u1 = 0,
        TXDMAEN: u1 = 0,
        SSOE: u1 = 0,
        NSSP: u1 = 0,
        FRF: u1 = 0,
        ERRIE: u1 = 0,
        RXNEIE: u1 = 0,
        TXEIE: u1 = 0,
        DS: u4 = 0,
        FRXTH: u1 = 0,
        LDMA_RX: u1 = 0,
        LDMA_TX: u1 = 0,
        _0: u17 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        RXNE: u1 = 0,
        TXE: u1 = 0,
        CHSIDE: u1 = 0,
        UDR: u1 = 0,
        CRCERR: u1 = 0,
        MODF: u1 = 0,
        OVR: u1 = 0,
        BSY: u1 = 0,
        FRE: u1 = 0,
        FRLVL: u2 = 0,
        FTLVL: u2 = 0,
        _0: u19 = 0,

        pub const set = set_masked;
    },

    DR: packed struct {
        DR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    CRCPR: packed struct {
        CRCPOLY: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    RXCRCR: packed struct {
        RxCRC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    TXCRCR: packed struct {
        TxCRC: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    I2SCFGR: packed struct {
        CHLEN: u1 = 0,
        DATLEN: u2 = 0,
        CKPOL: u1 = 0,
        I2SSTD: u2 = 0,
        _0: u1 = 0,
        PCMSYNC: u1 = 0,
        I2SCFG: u2 = 0,
        I2SE: u1 = 0,
        I2SMOD: u1 = 0,
        ASTRTEN: u1 = 0,
        _1: u19 = 0,

        pub const set = set_masked;
    },

    I2SPR: packed struct {
        I2SDIV: u8 = 0,
        ODD: u1 = 0,
        MCKOE: u1 = 0,
        _0: u22 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40015000);

pub const SPI1: @TypeOf(SPI5) = @ptrFromInt(0x40013000);

pub const SPI2: @TypeOf(SPI5) = @ptrFromInt(0x40003800);

pub const SPI4: @TypeOf(SPI5) = @ptrFromInt(0x40013400);

pub const SPI3: @TypeOf(SPI5) = @ptrFromInt(0x40003c00);

pub const SYSCFG: *volatile packed struct {
    MEMRMP: packed struct {
        MEM_BOOT: u1 = 0,
        _0: u9 = 0,
        SWP_FMC: u2 = 0,
        _1: u20 = 0,

        pub const set = set_masked;
    },

    PMC: packed struct {
        I2C1_FMP: u1 = 0,
        I2C2_FMP: u1 = 0,
        I2C3_FMP: u1 = 0,
        _0: u1 = 0,
        PB6_FMP: u1 = 0,
        PB7_FMP: u1 = 0,
        PB8_FMP: u1 = 0,
        PB9_FMP: u1 = 0,
        _1: u8 = 0,
        ADCDC2: u3 = 0,
        _2: u13 = 0,

        pub const set = set_masked;
    },

    EXTICR1: packed struct {
        EXTI0: u4 = 0,
        EXTI1: u4 = 0,
        EXTI2: u4 = 0,
        EXTI3: u4 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    EXTICR2: packed struct {
        EXTI4: u4 = 0,
        EXTI5: u4 = 0,
        EXTI6: u4 = 0,
        EXTI7: u4 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    EXTICR3: packed struct {
        EXTI8: u4 = 0,
        EXTI9: u4 = 0,
        EXTI10: u4 = 0,
        EXTI11: u4 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    EXTICR4: packed struct {
        EXTI12: u4 = 0,
        EXTI13: u4 = 0,
        EXTI14: u4 = 0,
        EXTI15: u4 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _0: u64 = 0,

    CMPCR: packed struct {
        CMP_PD: u1 = 0,
        _0: u7 = 0,
        READY: u1 = 0,
        _1: u23 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40013800);

pub const USART3: *volatile packed struct {
    CR1: packed struct {
        UE: u1 = 0,
        _0: u1 = 0,
        RE: u1 = 0,
        TE: u1 = 0,
        IDLEIE: u1 = 0,
        RXNEIE: u1 = 0,
        TCIE: u1 = 0,
        TXEIE: u1 = 0,
        PEIE: u1 = 0,
        PS: u1 = 0,
        PCE: u1 = 0,
        WAKE: u1 = 0,
        M0: u1 = 0,
        MME: u1 = 0,
        CMIE: u1 = 0,
        OVER8: u1 = 0,
        DEDT0: u1 = 0,
        DEDT1: u1 = 0,
        DEDT2: u1 = 0,
        DEDT3: u1 = 0,
        DEDT4: u1 = 0,
        DEAT0: u1 = 0,
        DEAT1: u1 = 0,
        DEAT2: u1 = 0,
        DEAT3: u1 = 0,
        DEAT4: u1 = 0,
        RTOIE: u1 = 0,
        EOBIE: u1 = 0,
        M1: u1 = 0,
        _1: u3 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        _0: u4 = 0,
        ADDM7: u1 = 0,
        LBDL: u1 = 0,
        LBDIE: u1 = 0,
        _1: u1 = 0,
        LBCL: u1 = 0,
        CPHA: u1 = 0,
        CPOL: u1 = 0,
        CLKEN: u1 = 0,
        STOP: u2 = 0,
        LINEN: u1 = 0,
        SWAP: u1 = 0,
        RXINV: u1 = 0,
        TXINV: u1 = 0,
        TAINV: u1 = 0,
        MSBFIRST: u1 = 0,
        ABREN: u1 = 0,
        ABRMOD0: u1 = 0,
        ABRMOD1: u1 = 0,
        RTOEN: u1 = 0,
        ADD0_3: u4 = 0,
        ADD4_7: u4 = 0,

        pub const set = set_masked;
    },

    CR3: packed struct {
        EIE: u1 = 0,
        IREN: u1 = 0,
        IRLP: u1 = 0,
        HDSEL: u1 = 0,
        NACK: u1 = 0,
        SCEN: u1 = 0,
        DMAR: u1 = 0,
        DMAT: u1 = 0,
        RTSE: u1 = 0,
        CTSE: u1 = 0,
        CTSIE: u1 = 0,
        ONEBIT: u1 = 0,
        OVRDIS: u1 = 0,
        DDRE: u1 = 0,
        DEM: u1 = 0,
        DEP: u1 = 0,
        _0: u1 = 0,
        SCARCNT: u3 = 0,
        _1: u4 = 0,
        TCBGTIE: u1 = 0,
        _2: u7 = 0,

        pub const set = set_masked;
    },

    BRR: packed struct {
        BRR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    GTPR: packed struct {
        PSC: u8 = 0,
        GT: u8 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    RTOR: packed struct {
        RTO: u24 = 0,
        BLEN: u8 = 0,

        pub const set = set_masked;
    },

    RQR: packed struct {
        ABRRQ: u1 = 0,
        SBKRQ: u1 = 0,
        MMRQ: u1 = 0,
        RXFRQ: u1 = 0,
        TXFRQ: u1 = 0,
        _0: u27 = 0,

        pub const set = set_masked;
    },

    ISR: packed struct {
        PE: u1 = 0,
        FE: u1 = 0,
        NF: u1 = 0,
        ORE: u1 = 0,
        IDLE: u1 = 0,
        RXNE: u1 = 0,
        TC: u1 = 0,
        TXE: u1 = 0,
        LBDF: u1 = 0,
        CTSIF: u1 = 0,
        CTS: u1 = 0,
        RTOF: u1 = 0,
        EOBF: u1 = 0,
        _0: u1 = 0,
        ABRE: u1 = 0,
        ABRF: u1 = 0,
        BUSY: u1 = 0,
        CMF: u1 = 0,
        SBKF: u1 = 0,
        _1: u2 = 0,
        TEACK: u1 = 0,
        _2: u3 = 0,
        TCBGT: u1 = 0,
        _3: u6 = 0,

        pub const set = set_masked;
    },

    ICR: packed struct {
        PECF: u1 = 0,
        FECF: u1 = 0,
        NCF: u1 = 0,
        ORECF: u1 = 0,
        IDLECF: u1 = 0,
        _0: u1 = 0,
        TCCF: u1 = 0,
        TCBGTCF: u1 = 0,
        LBDCF: u1 = 0,
        CTSCF: u1 = 0,
        _1: u1 = 0,
        RTOCF: u1 = 0,
        EOBCF: u1 = 0,
        _2: u4 = 0,
        CMCF: u1 = 0,
        _3: u14 = 0,

        pub const set = set_masked;
    },

    RDR: packed struct {
        RDR: u9 = 0,
        _0: u23 = 0,

        pub const set = set_masked;
    },

    TDR: packed struct {
        TDR: u9 = 0,
        _0: u23 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40004800);

pub const USART6: @TypeOf(USART3) = @ptrFromInt(0x40011400);

pub const UART8: @TypeOf(USART3) = @ptrFromInt(0x40007c00);

pub const USART2: @TypeOf(USART3) = @ptrFromInt(0x40004400);

pub const UART7: @TypeOf(USART3) = @ptrFromInt(0x40007800);

pub const UART4: @TypeOf(USART3) = @ptrFromInt(0x40004c00);

pub const UART5: @TypeOf(USART3) = @ptrFromInt(0x40005000);

pub const USART1: *volatile packed struct {
    CR1: packed struct {
        UE: u1 = 0,
        _0: u1 = 0,
        RE: u1 = 0,
        TE: u1 = 0,
        IDLEIE: u1 = 0,
        RXNEIE: u1 = 0,
        TCIE: u1 = 0,
        TXEIE: u1 = 0,
        PEIE: u1 = 0,
        PS: u1 = 0,
        PCE: u1 = 0,
        WAKE: u1 = 0,
        M0: u1 = 0,
        MME: u1 = 0,
        CMIE: u1 = 0,
        OVER8: u1 = 0,
        DEDT0: u1 = 0,
        DEDT1: u1 = 0,
        DEDT2: u1 = 0,
        DEDT3: u1 = 0,
        DEDT4: u1 = 0,
        DEAT0: u1 = 0,
        DEAT1: u1 = 0,
        DEAT2: u1 = 0,
        DEAT3: u1 = 0,
        DEAT4: u1 = 0,
        RTOIE: u1 = 0,
        EOBIE: u1 = 0,
        M1: u1 = 0,
        _1: u3 = 0,

        pub const set = set_masked;
    },

    CR2: packed struct {
        _0: u4 = 0,
        ADDM7: u1 = 0,
        LBDL: u1 = 0,
        LBDIE: u1 = 0,
        _1: u1 = 0,
        LBCL: u1 = 0,
        CPHA: u1 = 0,
        CPOL: u1 = 0,
        CLKEN: u1 = 0,
        STOP: u2 = 0,
        LINEN: u1 = 0,
        SWAP: u1 = 0,
        RXINV: u1 = 0,
        TXINV: u1 = 0,
        DATAINV: u1 = 0,
        MSBFIRST: u1 = 0,
        ABREN: u1 = 0,
        ABRMOD0: u1 = 0,
        ABRMOD1: u1 = 0,
        RTOEN: u1 = 0,
        ADD0_3: u4 = 0,
        ADD4_7: u4 = 0,

        pub const set = set_masked;
    },

    CR3: packed struct {
        EIE: u1 = 0,
        IREN: u1 = 0,
        IRLP: u1 = 0,
        HDSEL: u1 = 0,
        NACK: u1 = 0,
        SCEN: u1 = 0,
        DMAR: u1 = 0,
        DMAT: u1 = 0,
        RTSE: u1 = 0,
        CTSE: u1 = 0,
        CTSIE: u1 = 0,
        ONEBIT: u1 = 0,
        OVRDIS: u1 = 0,
        DDRE: u1 = 0,
        DEM: u1 = 0,
        DEP: u1 = 0,
        _0: u1 = 0,
        SCARCNT: u3 = 0,
        _1: u4 = 0,
        TCBGTIE: u1 = 0,
        _2: u7 = 0,

        pub const set = set_masked;
    },

    BRR: packed struct {
        BRR: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    GTPR: packed struct {
        PSC: u8 = 0,
        GT: u8 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    RTOR: packed struct {
        RTO: u24 = 0,
        BLEN: u8 = 0,

        pub const set = set_masked;
    },

    RQR: packed struct {
        ABRRQ: u1 = 0,
        SBKRQ: u1 = 0,
        MMRQ: u1 = 0,
        RXFRQ: u1 = 0,
        TXFRQ: u1 = 0,
        _0: u27 = 0,

        pub const set = set_masked;
    },

    ISR: packed struct {
        PE: u1 = 0,
        FE: u1 = 0,
        NF: u1 = 0,
        ORE: u1 = 0,
        IDLE: u1 = 0,
        RXNE: u1 = 0,
        TC: u1 = 0,
        TXE: u1 = 0,
        LBDF: u1 = 0,
        CTSIF: u1 = 0,
        CTS: u1 = 0,
        RTOF: u1 = 0,
        EOBF: u1 = 0,
        _0: u1 = 0,
        ABRE: u1 = 0,
        ABRF: u1 = 0,
        BUSY: u1 = 0,
        CMF: u1 = 0,
        SBKF: u1 = 0,
        _1: u2 = 0,
        TEACK: u1 = 0,
        _2: u3 = 0,
        TCBGT: u1 = 0,
        _3: u6 = 0,

        pub const set = set_masked;
    },

    ICR: packed struct {
        PECF: u1 = 0,
        FECF: u1 = 0,
        NCF: u1 = 0,
        ORECF: u1 = 0,
        IDLECF: u1 = 0,
        _0: u1 = 0,
        TCCF: u1 = 0,
        TCBGTCF: u1 = 0,
        LBDCF: u1 = 0,
        CTSCF: u1 = 0,
        _1: u1 = 0,
        RTOCF: u1 = 0,
        EOBCF: u1 = 0,
        _2: u4 = 0,
        CMCF: u1 = 0,
        _3: u14 = 0,

        pub const set = set_masked;
    },

    RDR: packed struct {
        RDR: u9 = 0,
        _0: u23 = 0,

        pub const set = set_masked;
    },

    TDR: packed struct {
        TDR: u9 = 0,
        _0: u23 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40011000);

pub const OTG_FS_GLOBAL: *volatile packed struct {
    OTG_FS_GOTGCTL: packed struct {
        SRQSCS: u1 = 0,
        SRQ: u1 = 0,
        VBVALOEN: u1 = 0,
        VBVALOVAL: u1 = 0,
        AVALOEN: u1 = 0,
        AVALOVAL: u1 = 0,
        BVALOEN: u1 = 0,
        BVALOVAL: u1 = 0,
        HNGSCS: u1 = 0,
        HNPRQ: u1 = 0,
        HSHNPEN: u1 = 0,
        DHNPEN: u1 = 0,
        EHEN: u1 = 0,
        _0: u3 = 0,
        CIDSTS: u1 = 0,
        DBCT: u1 = 0,
        ASVLD: u1 = 0,
        BSVLD: u1 = 0,
        OTGVER: u1 = 0,
        _1: u11 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GOTGINT: packed struct {
        _0: u2 = 0,
        SEDET: u1 = 0,
        _1: u5 = 0,
        SRSSCHG: u1 = 0,
        HNSSCHG: u1 = 0,
        _2: u7 = 0,
        HNGDET: u1 = 0,
        ADTOCHG: u1 = 0,
        DBCDNE: u1 = 0,
        IDCHNG: u1 = 0,
        _3: u11 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GAHBCFG: packed struct {
        GINT: u1 = 0,
        _0: u6 = 0,
        TXFELVL: u1 = 0,
        PTXFELVL: u1 = 0,
        _1: u23 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GUSBCFG: packed struct {
        TOCAL: u3 = 0,
        _0: u3 = 0,
        PHYSEL: u1 = 0,
        _1: u1 = 0,
        SRPCAP: u1 = 0,
        HNPCAP: u1 = 0,
        TRDT: u4 = 0,
        _2: u15 = 0,
        FHMOD: u1 = 0,
        FDMOD: u1 = 0,
        _3: u1 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GRSTCTL: packed struct {
        CSRST: u1 = 0,
        HSRST: u1 = 0,
        FCRST: u1 = 0,
        _0: u1 = 0,
        RXFFLSH: u1 = 0,
        TXFFLSH: u1 = 0,
        TXFNUM: u5 = 0,
        _1: u20 = 0,
        AHBIDL: u1 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GINTSTS: packed struct {
        CMOD: u1 = 0,
        MMIS: u1 = 0,
        OTGINT: u1 = 0,
        SOF: u1 = 0,
        RXFLVL: u1 = 0,
        NPTXFE: u1 = 0,
        GINAKEFF: u1 = 0,
        GOUTNAKEFF: u1 = 0,
        _0: u2 = 0,
        ESUSP: u1 = 0,
        USBSUSP: u1 = 0,
        USBRST: u1 = 0,
        ENUMDNE: u1 = 0,
        ISOODRP: u1 = 0,
        EOPF: u1 = 0,
        _1: u2 = 0,
        IEPINT: u1 = 0,
        OEPINT: u1 = 0,
        IISOIXFR: u1 = 0,
        IPXFR_INCOMPISOOUT: u1 = 0,
        _2: u1 = 0,
        RSTDET: u1 = 0,
        HPRTINT: u1 = 0,
        HCINT: u1 = 0,
        PTXFE: u1 = 0,
        _3: u1 = 0,
        CIDSCHG: u1 = 0,
        DISCINT: u1 = 0,
        SRQINT: u1 = 0,
        WKUPINT: u1 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GINTMSK: packed struct {
        _0: u1 = 0,
        MMISM: u1 = 0,
        OTGINT: u1 = 0,
        SOFM: u1 = 0,
        RXFLVLM: u1 = 0,
        NPTXFEM: u1 = 0,
        GINAKEFFM: u1 = 0,
        GONAKEFFM: u1 = 0,
        _1: u2 = 0,
        ESUSPM: u1 = 0,
        USBSUSPM: u1 = 0,
        USBRST: u1 = 0,
        ENUMDNEM: u1 = 0,
        ISOODRPM: u1 = 0,
        EOPFM: u1 = 0,
        _2: u2 = 0,
        IEPINT: u1 = 0,
        OEPINT: u1 = 0,
        IISOIXFRM: u1 = 0,
        IPXFRM_IISOOXFRM: u1 = 0,
        _3: u1 = 0,
        RSTDETM: u1 = 0,
        PRTIM: u1 = 0,
        HCIM: u1 = 0,
        PTXFEM: u1 = 0,
        LPMIN: u1 = 0,
        CIDSCHGM: u1 = 0,
        DISCINT: u1 = 0,
        SRQIM: u1 = 0,
        WUIM: u1 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GRXSTSR: packed union {
        Device: packed struct {
            EPNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            FRMNUM: u4 = 0,
            _0: u7 = 0,

            pub const set = set_masked;
        },

        Host: packed struct {
            CHNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            _0: u11 = 0,

            pub const set = set_masked;
        },
    },

    OTG_FS_GRXSTSP: packed union {
        Device: packed struct {
            EPNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            FRMNUM: u4 = 0,
            _0: u7 = 0,

            pub const set = set_masked;
        },

        Host: packed struct {
            CHNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            _0: u11 = 0,

            pub const set = set_masked;
        },
    },

    OTG_FS_GRXFSIZ: packed struct {
        RXFD: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS: packed union {
        DIEPTXF0_Device: packed struct {
            TX0FSA: u16 = 0,
            TX0FD: u16 = 0,

            pub const set = set_masked;
        },

        HNPTXFSIZ_Host: packed struct {
            NPTXFSA: u16 = 0,
            NPTXFD: u16 = 0,

            pub const set = set_masked;
        },
    },

    OTG_FS_HNPTXSTS: packed struct {
        NPTXFSAV: u16 = 0,
        NPTQXSAV: u8 = 0,
        NPTXQTOP: u7 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_FS_GI2CCTL: packed struct {
        RWDATA: u8 = 0,
        REGADDR: u8 = 0,
        ADDR: u7 = 0,
        I2CEN: u1 = 0,
        ACK: u1 = 0,
        _0: u1 = 0,
        I2CDEVADR: u2 = 0,
        I2CDATSE0: u1 = 0,
        _1: u1 = 0,
        RW: u1 = 0,
        BSYDNE: u1 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    OTG_FS_GCCFG: packed struct {
        DCDET: u1 = 0,
        PDET: u1 = 0,
        SDET: u1 = 0,
        PS2DET: u1 = 0,
        _0: u12 = 0,
        PWRDWN: u1 = 0,
        BCDEN: u1 = 0,
        DCDEN: u1 = 0,
        PDEN: u1 = 0,
        SDEN: u1 = 0,
        VBDEN: u1 = 0,
        _1: u10 = 0,

        pub const set = set_masked;
    },

    OTG_FS_CID: packed struct {
        PRODUCT_ID: u32 = 0,

        pub const set = set_masked;
    },

    _1: u160 = 0,

    OTG_FS_GLPMCFG: packed struct {
        LPMEN: u1 = 0,
        LPMACK: u1 = 0,
        BESL: u4 = 0,
        REMWAKE: u1 = 0,
        L1SSEN: u1 = 0,
        BESLTHRS: u4 = 0,
        L1DSEN: u1 = 0,
        LPMRST: u2 = 0,
        SLPSTS: u1 = 0,
        L1RSMOK: u1 = 0,
        LPMCHIDX: u4 = 0,
        LPMRCNT: u3 = 0,
        SNDLPM: u1 = 0,
        LPMRCNTSTS: u3 = 0,
        ENBESL: u1 = 0,
        _0: u3 = 0,

        pub const set = set_masked;
    },

    _2: u1344 = 0,

    OTG_FS_HPTXFSIZ: packed struct {
        PTXSA: u16 = 0,
        PTXFSIZ: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DIEPTXF1: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DIEPTXF2: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DIEPTXF3: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DIEPTXF4: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DIEPTXF5: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x50000000);

pub const OTG_FS_HOST: *volatile packed struct {
    OTG_FS_HCFG: packed struct {
        FSLSPCS: u2 = 0,
        FSLSS: u1 = 0,
        _0: u29 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HFIR: packed struct {
        FRIVL: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HFNUM: packed struct {
        FRNUM: u16 = 0,
        FTREM: u16 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    OTG_FS_HPTXSTS: packed struct {
        PTXFSAVL: u16 = 0,
        PTXQSAV: u8 = 0,
        PTXQTOP: u8 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HAINT: packed struct {
        HAINT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HAINTMSK: packed struct {
        HAINTM: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _1: u288 = 0,

    OTG_FS_HPRT: packed struct {
        PCSTS: u1 = 0,
        PCDET: u1 = 0,
        PENA: u1 = 0,
        PENCHNG: u1 = 0,
        POCA: u1 = 0,
        POCCHNG: u1 = 0,
        PRES: u1 = 0,
        PSUSP: u1 = 0,
        PRST: u1 = 0,
        _0: u1 = 0,
        PLSTS: u2 = 0,
        PPWR: u1 = 0,
        PTCTL: u4 = 0,
        PSPD: u2 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    _2: u1504 = 0,

    OTG_FS_HCCHAR0: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _3: u32 = 0,

    OTG_FS_HCINT0: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK0: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ0: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _4: u96 = 0,

    OTG_FS_HCCHAR1: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _5: u32 = 0,

    OTG_FS_HCINT1: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK1: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ1: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _6: u96 = 0,

    OTG_FS_HCCHAR2: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _7: u32 = 0,

    OTG_FS_HCINT2: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK2: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ2: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _8: u96 = 0,

    OTG_FS_HCCHAR3: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _9: u32 = 0,

    OTG_FS_HCINT3: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK3: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ3: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _10: u96 = 0,

    OTG_FS_HCCHAR4: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _11: u32 = 0,

    OTG_FS_HCINT4: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK4: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ4: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _12: u96 = 0,

    OTG_FS_HCCHAR5: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _13: u32 = 0,

    OTG_FS_HCINT5: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK5: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ5: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _14: u96 = 0,

    OTG_FS_HCCHAR6: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _15: u32 = 0,

    OTG_FS_HCINT6: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK6: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ6: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _16: u96 = 0,

    OTG_FS_HCCHAR7: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _17: u32 = 0,

    OTG_FS_HCINT7: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK7: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ7: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _18: u96 = 0,

    OTG_FS_HCCHAR8: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _19: u32 = 0,

    OTG_FS_HCINT8: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK8: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ8: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _20: u96 = 0,

    OTG_FS_HCCHAR9: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _21: u32 = 0,

    OTG_FS_HCINT9: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK9: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ9: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _22: u96 = 0,

    OTG_FS_HCCHAR10: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _23: u32 = 0,

    OTG_FS_HCINT10: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK10: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ10: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _24: u96 = 0,

    OTG_FS_HCCHAR11: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MCNT: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    _25: u32 = 0,

    OTG_FS_HCINT11: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        _0: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        _1: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _2: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCINTMSK11: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        _0: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _1: u21 = 0,

        pub const set = set_masked;
    },

    OTG_FS_HCTSIZ11: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x50000400);

pub const OTG_FS_DEVICE: *volatile packed struct {
    OTG_FS_DCFG: packed struct {
        DSPD: u2 = 0,
        NZLSOHSK: u1 = 0,
        _0: u1 = 0,
        DAD: u7 = 0,
        PFIVL: u2 = 0,
        _1: u19 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DCTL: packed struct {
        RWUSIG: u1 = 0,
        SDIS: u1 = 0,
        GINSTS: u1 = 0,
        GONSTS: u1 = 0,
        TCTL: u3 = 0,
        SGINAK: u1 = 0,
        CGINAK: u1 = 0,
        SGONAK: u1 = 0,
        CGONAK: u1 = 0,
        POPRGDNE: u1 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DSTS: packed struct {
        SUSPSTS: u1 = 0,
        ENUMSPD: u2 = 0,
        EERR: u1 = 0,
        _0: u4 = 0,
        FNSOF: u14 = 0,
        _1: u10 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    OTG_FS_DIEPMSK: packed struct {
        XFRCM: u1 = 0,
        EPDM: u1 = 0,
        _0: u1 = 0,
        TOM: u1 = 0,
        ITTXFEMSK: u1 = 0,
        INEPNMM: u1 = 0,
        INEPNEM: u1 = 0,
        _1: u25 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DOEPMSK: packed struct {
        XFRCM: u1 = 0,
        EPDM: u1 = 0,
        _0: u1 = 0,
        STUPM: u1 = 0,
        OTEPDM: u1 = 0,
        _1: u27 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DAINT: packed struct {
        IEPINT: u16 = 0,
        OEPINT: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DAINTMSK: packed struct {
        IEPM: u16 = 0,
        OEPINT: u16 = 0,

        pub const set = set_masked;
    },

    _1: u64 = 0,

    OTG_FS_DVBUSDIS: packed struct {
        VBUSDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_FS_DVBUSPULSE: packed struct {
        DVBUSP: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    _2: u32 = 0,

    OTG_FS_DIEPEMPMSK: packed struct {
        INEPTXFEM: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _3: u1600 = 0,

    OTG_FS_DIEPCTL0: packed struct {
        MPSIZ: u2 = 0,
        _0: u13 = 0,
        USBAEP: u1 = 0,
        _1: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _2: u1 = 0,
        STALL: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        _3: u2 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _4: u32 = 0,

    OTG_FS_DIEPINT0: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    _5: u32 = 0,

    OTG_FS_DIEPTSIZ0: packed struct {
        XFRSIZ: u7 = 0,
        _0: u12 = 0,
        PKTCNT: u2 = 0,
        _1: u11 = 0,

        pub const set = set_masked;
    },

    _6: u32 = 0,

    OTG_FS_DTXFSTS0: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _7: u32 = 0,

    OTG_FS_DIEPCTL1: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM_SD1PID: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _8: u32 = 0,

    OTG_FS_DIEPINT1: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    _9: u32 = 0,

    OTG_FS_DIEPTSIZ1: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _10: u32 = 0,

    OTG_FS_DTXFSTS1: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _11: u32 = 0,

    OTG_FS_DIEPCTL2: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _12: u32 = 0,

    OTG_FS_DIEPINT2: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    _13: u32 = 0,

    OTG_FS_DIEPTSIZ2: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _14: u32 = 0,

    OTG_FS_DTXFSTS2: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _15: u32 = 0,

    OTG_FS_DIEPCTL3: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _16: u32 = 0,

    OTG_FS_DIEPINT3: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    _17: u32 = 0,

    OTG_FS_DIEPTSIZ3: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _18: u32 = 0,

    OTG_FS_DTXFSTS3: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _19: u32 = 0,

    OTG_FS_DIEPCTL4: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _20: u32 = 0,

    OTG_FS_DIEPINT4: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    _21: u32 = 0,

    OTG_FS_DIEPTSIZ4: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _22: u32 = 0,

    OTG_FS_DTXFSTS4: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _23: u32 = 0,

    OTG_FS_DIEPCTL5: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _24: u32 = 0,

    OTG_FS_DIEPINT5: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        _2: u24 = 0,

        pub const set = set_masked;
    },

    _25: u32 = 0,

    OTG_FS_DIEPTSIZ5: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _26: u32 = 0,

    OTG_FS_DTXFSTS5: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _27: u2592 = 0,

    OTG_FS_DOEPCTL0: packed struct {
        MPSIZ: u2 = 0,
        _0: u13 = 0,
        USBAEP: u1 = 0,
        _1: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _2: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        _3: u2 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _28: u32 = 0,

    OTG_FS_DOEPINT0: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u25 = 0,

        pub const set = set_masked;
    },

    _29: u32 = 0,

    OTG_FS_DOEPTSIZ0: packed struct {
        XFRSIZ: u7 = 0,
        _0: u12 = 0,
        PKTCNT: u1 = 0,
        _1: u9 = 0,
        STUPCNT: u2 = 0,
        _2: u1 = 0,

        pub const set = set_masked;
    },

    _30: u96 = 0,

    OTG_FS_DOEPCTL1: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _31: u32 = 0,

    OTG_FS_DOEPINT1: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u25 = 0,

        pub const set = set_masked;
    },

    _32: u32 = 0,

    OTG_FS_DOEPTSIZ1: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _33: u96 = 0,

    OTG_FS_DOEPCTL2: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _34: u32 = 0,

    OTG_FS_DOEPINT2: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u25 = 0,

        pub const set = set_masked;
    },

    _35: u32 = 0,

    OTG_FS_DOEPTSIZ2: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _36: u96 = 0,

    OTG_FS_DOEPCTL3: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _37: u32 = 0,

    OTG_FS_DOEPINT3: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u25 = 0,

        pub const set = set_masked;
    },

    _38: u32 = 0,

    OTG_FS_DOEPTSIZ3: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _39: u96 = 0,

    OTG_FS_DOEPCTL4: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _40: u32 = 0,

    OTG_FS_DOEPINT4: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u25 = 0,

        pub const set = set_masked;
    },

    _41: u32 = 0,

    OTG_FS_DOEPTSIZ4: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    _42: u96 = 0,

    OTG_FS_DOEPCTL5: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _43: u32 = 0,

    OTG_FS_DOEPINT5: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u25 = 0,

        pub const set = set_masked;
    },

    _44: u32 = 0,

    OTG_FS_DOEPTSIZ5: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x50000800);

pub const OTG_FS_PWRCLK: *volatile packed struct {
    OTG_FS_PCGCCTL: packed struct {
        STPPCLK: u1 = 0,
        GATEHCLK: u1 = 0,
        _0: u2 = 0,
        PHYSUSP: u1 = 0,
        _1: u27 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x50000e00);

pub const OTG_HS_HOST: *volatile packed struct {
    OTG_HS_HCFG: packed struct {
        FSLSPCS: u2 = 0,
        FSLSS: u1 = 0,
        _0: u29 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HFIR: packed struct {
        FRIVL: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HFNUM: packed struct {
        FRNUM: u16 = 0,
        FTREM: u16 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    OTG_HS_HPTXSTS: packed struct {
        PTXFSAVL: u16 = 0,
        PTXQSAV: u8 = 0,
        PTXQTOP: u8 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HAINT: packed struct {
        HAINT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HAINTMSK: packed struct {
        HAINTM: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _1: u288 = 0,

    OTG_HS_HPRT: packed struct {
        PCSTS: u1 = 0,
        PCDET: u1 = 0,
        PENA: u1 = 0,
        PENCHNG: u1 = 0,
        POCA: u1 = 0,
        POCCHNG: u1 = 0,
        PRES: u1 = 0,
        PSUSP: u1 = 0,
        PRST: u1 = 0,
        _0: u1 = 0,
        PLSTS: u2 = 0,
        PPWR: u1 = 0,
        PTCTL: u4 = 0,
        PSPD: u2 = 0,
        _1: u13 = 0,

        pub const set = set_masked;
    },

    _2: u1504 = 0,

    OTG_HS_HCCHAR0: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT0: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT0: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK0: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ0: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA0: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _3: u64 = 0,

    OTG_HS_HCCHAR1: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT1: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT1: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK1: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ1: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA1: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _4: u64 = 0,

    OTG_HS_HCCHAR2: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT2: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT2: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK2: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ2: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA2: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _5: u64 = 0,

    OTG_HS_HCCHAR3: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT3: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT3: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK3: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ3: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA3: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _6: u64 = 0,

    OTG_HS_HCCHAR4: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT4: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT4: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK4: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ4: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA4: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _7: u64 = 0,

    OTG_HS_HCCHAR5: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT5: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT5: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK5: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ5: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA5: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _8: u64 = 0,

    OTG_HS_HCCHAR6: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT6: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT6: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK6: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ6: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA6: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _9: u64 = 0,

    OTG_HS_HCCHAR7: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT7: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT7: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK7: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ7: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA7: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _10: u64 = 0,

    OTG_HS_HCCHAR8: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT8: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT8: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK8: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ8: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA8: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _11: u64 = 0,

    OTG_HS_HCCHAR9: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT9: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT9: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK9: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ9: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA9: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _12: u64 = 0,

    OTG_HS_HCCHAR10: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT10: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT10: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK10: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ10: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA10: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _13: u64 = 0,

    OTG_HS_HCCHAR11: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT11: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT11: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK11: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ11: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA11: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _14: u64 = 0,

    OTG_HS_HCCHAR12: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT12: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT12: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK12: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ12: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA12: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _15: u64 = 0,

    OTG_HS_HCCHAR13: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT13: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT13: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK13: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ13: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA13: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _16: u64 = 0,

    OTG_HS_HCCHAR14: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT14: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT14: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK14: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALLM: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ14: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA14: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    _17: u64 = 0,

    OTG_HS_HCCHAR15: packed struct {
        MPSIZ: u11 = 0,
        EPNUM: u4 = 0,
        EPDIR: u1 = 0,
        _0: u1 = 0,
        LSDEV: u1 = 0,
        EPTYP: u2 = 0,
        MC: u2 = 0,
        DAD: u7 = 0,
        ODDFRM: u1 = 0,
        CHDIS: u1 = 0,
        CHENA: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCSPLT15: packed struct {
        PRTADDR: u7 = 0,
        HUBADDR: u7 = 0,
        XACTPOS: u2 = 0,
        COMPLSPLT: u1 = 0,
        _0: u14 = 0,
        SPLITEN: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINT15: packed struct {
        XFRC: u1 = 0,
        CHH: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAK: u1 = 0,
        ACK: u1 = 0,
        NYET: u1 = 0,
        TXERR: u1 = 0,
        BBERR: u1 = 0,
        FRMOR: u1 = 0,
        DTERR: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCINTMSK15: packed struct {
        XFRCM: u1 = 0,
        CHHM: u1 = 0,
        AHBERR: u1 = 0,
        STALL: u1 = 0,
        NAKM: u1 = 0,
        ACKM: u1 = 0,
        NYET: u1 = 0,
        TXERRM: u1 = 0,
        BBERRM: u1 = 0,
        FRMORM: u1 = 0,
        DTERRM: u1 = 0,
        _0: u21 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCTSIZ15: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        DPID: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_HCDMA15: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40040400);

pub const OTG_HS_GLOBAL: *volatile packed struct {
    OTG_HS_GOTGCTL: packed struct {
        SRQSCS: u1 = 0,
        SRQ: u1 = 0,
        _0: u6 = 0,
        HNGSCS: u1 = 0,
        HNPRQ: u1 = 0,
        HSHNPEN: u1 = 0,
        DHNPEN: u1 = 0,
        EHEN: u1 = 0,
        _1: u3 = 0,
        CIDSTS: u1 = 0,
        DBCT: u1 = 0,
        ASVLD: u1 = 0,
        BSVLD: u1 = 0,
        _2: u12 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GOTGINT: packed struct {
        _0: u2 = 0,
        SEDET: u1 = 0,
        _1: u5 = 0,
        SRSSCHG: u1 = 0,
        HNSSCHG: u1 = 0,
        _2: u7 = 0,
        HNGDET: u1 = 0,
        ADTOCHG: u1 = 0,
        DBCDNE: u1 = 0,
        IDCHNG: u1 = 0,
        _3: u11 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GAHBCFG: packed struct {
        GINT: u1 = 0,
        HBSTLEN: u4 = 0,
        DMAEN: u1 = 0,
        _0: u1 = 0,
        TXFELVL: u1 = 0,
        PTXFELVL: u1 = 0,
        _1: u23 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GUSBCFG: packed struct {
        TOCAL: u3 = 0,
        _0: u3 = 0,
        PHYSEL: u1 = 0,
        _1: u1 = 0,
        SRPCAP: u1 = 0,
        HNPCAP: u1 = 0,
        TRDT: u4 = 0,
        _2: u1 = 0,
        PHYLPCS: u1 = 0,
        _3: u1 = 0,
        ULPIFSLS: u1 = 0,
        ULPIAR: u1 = 0,
        ULPICSM: u1 = 0,
        ULPIEVBUSD: u1 = 0,
        ULPIEVBUSI: u1 = 0,
        TSDPS: u1 = 0,
        PCCI: u1 = 0,
        PTCI: u1 = 0,
        ULPIIPD: u1 = 0,
        _4: u3 = 0,
        FHMOD: u1 = 0,
        FDMOD: u1 = 0,
        _5: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GRSTCTL: packed struct {
        CSRST: u1 = 0,
        HSRST: u1 = 0,
        FCRST: u1 = 0,
        _0: u1 = 0,
        RXFFLSH: u1 = 0,
        TXFFLSH: u1 = 0,
        TXFNUM: u5 = 0,
        _1: u19 = 0,
        DMAREQ: u1 = 0,
        AHBIDL: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GINTSTS: packed struct {
        CMOD: u1 = 0,
        MMIS: u1 = 0,
        OTGINT: u1 = 0,
        SOF: u1 = 0,
        RXFLVL: u1 = 0,
        NPTXFE: u1 = 0,
        GINAKEFF: u1 = 0,
        BOUTNAKEFF: u1 = 0,
        _0: u2 = 0,
        ESUSP: u1 = 0,
        USBSUSP: u1 = 0,
        USBRST: u1 = 0,
        ENUMDNE: u1 = 0,
        ISOODRP: u1 = 0,
        EOPF: u1 = 0,
        _1: u2 = 0,
        IEPINT: u1 = 0,
        OEPINT: u1 = 0,
        IISOIXFR: u1 = 0,
        PXFR_INCOMPISOOUT: u1 = 0,
        DATAFSUSP: u1 = 0,
        _2: u1 = 0,
        HPRTINT: u1 = 0,
        HCINT: u1 = 0,
        PTXFE: u1 = 0,
        _3: u1 = 0,
        CIDSCHG: u1 = 0,
        DISCINT: u1 = 0,
        SRQINT: u1 = 0,
        WKUINT: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GINTMSK: packed struct {
        _0: u1 = 0,
        MMISM: u1 = 0,
        OTGINT: u1 = 0,
        SOFM: u1 = 0,
        RXFLVLM: u1 = 0,
        NPTXFEM: u1 = 0,
        GINAKEFFM: u1 = 0,
        GONAKEFFM: u1 = 0,
        _1: u2 = 0,
        ESUSPM: u1 = 0,
        USBSUSPM: u1 = 0,
        USBRST: u1 = 0,
        ENUMDNEM: u1 = 0,
        ISOODRPM: u1 = 0,
        EOPFM: u1 = 0,
        _2: u2 = 0,
        IEPINT: u1 = 0,
        OEPINT: u1 = 0,
        IISOIXFRM: u1 = 0,
        PXFRM_IISOOXFRM: u1 = 0,
        FSUSPM: u1 = 0,
        RSTDE: u1 = 0,
        PRTIM: u1 = 0,
        HCIM: u1 = 0,
        PTXFEM: u1 = 0,
        LPMINTM: u1 = 0,
        CIDSCHGM: u1 = 0,
        DISCINT: u1 = 0,
        SRQIM: u1 = 0,
        WUIM: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GRXSTSR: packed union {
        Host: packed struct {
            CHNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            _0: u11 = 0,

            pub const set = set_masked;
        },

        Device: packed struct {
            EPNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            FRMNUM: u4 = 0,
            _0: u7 = 0,

            pub const set = set_masked;
        },
    },

    OTG_HS_GRXSTSP: packed union {
        Host: packed struct {
            CHNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            _0: u11 = 0,

            pub const set = set_masked;
        },

        Device: packed struct {
            EPNUM: u4 = 0,
            BCNT: u11 = 0,
            DPID: u2 = 0,
            PKTSTS: u4 = 0,
            FRMNUM: u4 = 0,
            _0: u7 = 0,

            pub const set = set_masked;
        },
    },

    OTG_HS_GRXFSIZ: packed struct {
        RXFD: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS: packed union {
        HNPTXFSIZ_Host: packed struct {
            NPTXFSA: u16 = 0,
            NPTXFD: u16 = 0,

            pub const set = set_masked;
        },

        DIEPTXF0_Device: packed struct {
            TX0FSA: u16 = 0,
            TX0FD: u16 = 0,

            pub const set = set_masked;
        },
    },

    OTG_HS_HNPTXSTS: packed struct {
        NPTXFSAV: u16 = 0,
        NPTQXSAV: u8 = 0,
        NPTXQTOP: u7 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_GI2CCTL: packed struct {
        RWDATA: u8 = 0,
        REGADDR: u8 = 0,
        ADDR: u7 = 0,
        I2CEN: u1 = 0,
        ACK: u1 = 0,
        _0: u1 = 0,
        I2CDEVADR: u2 = 0,
        I2CDATSE0: u1 = 0,
        _1: u1 = 0,
        RW: u1 = 0,
        BSYDNE: u1 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    OTG_HS_GCCFG: packed struct {
        DCDET: u1 = 0,
        PDET: u1 = 0,
        SDET: u1 = 0,
        PS2DET: u1 = 0,
        _0: u12 = 0,
        PWRDWN: u1 = 0,
        BCDEN: u1 = 0,
        DCDEN: u1 = 0,
        PDEN: u1 = 0,
        SDEN: u1 = 0,
        VBDEN: u1 = 0,
        _1: u10 = 0,

        pub const set = set_masked;
    },

    OTG_HS_CID: packed struct {
        PRODUCT_ID: u32 = 0,

        pub const set = set_masked;
    },

    _1: u160 = 0,

    OTG_HS_GLPMCFG: packed struct {
        LPMEN: u1 = 0,
        LPMACK: u1 = 0,
        BESL: u4 = 0,
        REMWAKE: u1 = 0,
        L1SSEN: u1 = 0,
        BESLTHRS: u4 = 0,
        L1DSEN: u1 = 0,
        LPMRST: u2 = 0,
        SLPSTS: u1 = 0,
        L1RSMOK: u1 = 0,
        LPMCHIDX: u4 = 0,
        LPMRCNT: u3 = 0,
        SNDLPM: u1 = 0,
        LPMRCNTSTS: u3 = 0,
        ENBESL: u1 = 0,
        _0: u3 = 0,

        pub const set = set_masked;
    },

    _2: u1344 = 0,

    OTG_HS_HPTXFSIZ: packed struct {
        PTXSA: u16 = 0,
        PTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF1: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF2: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF3: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF4: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF5: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF6: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF7: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPTXF8: packed struct {
        INEPTXSA: u16 = 0,
        INEPTXFD: u16 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40040000);

pub const OTG_HS_PWRCLK: *volatile packed struct {
    OTG_HS_PCGCR: packed struct {
        STPPCLK: u1 = 0,
        GATEHCLK: u1 = 0,
        _0: u2 = 0,
        PHYSUSP: u1 = 0,
        _1: u27 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40040e00);

pub const OTG_HS_DEVICE: *volatile packed struct {
    OTG_HS_DCFG: packed struct {
        DSPD: u2 = 0,
        NZLSOHSK: u1 = 0,
        _0: u1 = 0,
        DAD: u7 = 0,
        PFIVL: u2 = 0,
        _1: u11 = 0,
        PERSCHIVL: u2 = 0,
        _2: u6 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DCTL: packed struct {
        RWUSIG: u1 = 0,
        SDIS: u1 = 0,
        GINSTS: u1 = 0,
        GONSTS: u1 = 0,
        TCTL: u3 = 0,
        SGINAK: u1 = 0,
        CGINAK: u1 = 0,
        SGONAK: u1 = 0,
        CGONAK: u1 = 0,
        POPRGDNE: u1 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DSTS: packed struct {
        SUSPSTS: u1 = 0,
        ENUMSPD: u2 = 0,
        EERR: u1 = 0,
        _0: u4 = 0,
        FNSOF: u14 = 0,
        _1: u10 = 0,

        pub const set = set_masked;
    },

    _0: u32 = 0,

    OTG_HS_DIEPMSK: packed struct {
        XFRCM: u1 = 0,
        EPDM: u1 = 0,
        _0: u1 = 0,
        TOM: u1 = 0,
        ITTXFEMSK: u1 = 0,
        INEPNMM: u1 = 0,
        INEPNEM: u1 = 0,
        _1: u1 = 0,
        TXFURM: u1 = 0,
        BIM: u1 = 0,
        _2: u22 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPMSK: packed struct {
        XFRCM: u1 = 0,
        EPDM: u1 = 0,
        _0: u1 = 0,
        STUPM: u1 = 0,
        OTEPDM: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u1 = 0,
        OPEM: u1 = 0,
        BOIM: u1 = 0,
        _3: u22 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DAINT: packed struct {
        IEPINT: u16 = 0,
        OEPINT: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DAINTMSK: packed struct {
        IEPM: u16 = 0,
        OEPM: u16 = 0,

        pub const set = set_masked;
    },

    _1: u64 = 0,

    OTG_HS_DVBUSDIS: packed struct {
        VBUSDT: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DVBUSPULSE: packed struct {
        DVBUSP: u12 = 0,
        _0: u20 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DTHRCTL: packed struct {
        NONISOTHREN: u1 = 0,
        ISOTHREN: u1 = 0,
        TXTHRLEN: u9 = 0,
        _0: u5 = 0,
        RXTHREN: u1 = 0,
        RXTHRLEN: u9 = 0,
        _1: u1 = 0,
        ARPEN: u1 = 0,
        _2: u4 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPEMPMSK: packed struct {
        INEPTXFEM: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DEACHINT: packed struct {
        _0: u1 = 0,
        IEP1INT: u1 = 0,
        _1: u15 = 0,
        OEP1INT: u1 = 0,
        _2: u14 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DEACHINTMSK: packed struct {
        _0: u1 = 0,
        IEP1INTM: u1 = 0,
        _1: u15 = 0,
        OEP1INTM: u1 = 0,
        _2: u14 = 0,

        pub const set = set_masked;
    },

    _2: u1536 = 0,

    OTG_HS_DIEPCTL0: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _3: u32 = 0,

    OTG_HS_DIEPINT0: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _4: u32 = 0,

    OTG_HS_DIEPTSIZ0: packed struct {
        XFRSIZ: u7 = 0,
        _0: u12 = 0,
        PKTCNT: u2 = 0,
        _1: u11 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA0: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DTXFSTS0: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _5: u32 = 0,

    OTG_HS_DIEPCTL1: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _6: u32 = 0,

    OTG_HS_DIEPINT1: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _7: u32 = 0,

    OTG_HS_DIEPTSIZ1: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA1: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DTXFSTS1: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _8: u32 = 0,

    OTG_HS_DIEPCTL2: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _9: u32 = 0,

    OTG_HS_DIEPINT2: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _10: u32 = 0,

    OTG_HS_DIEPTSIZ2: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA2: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DTXFSTS2: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _11: u32 = 0,

    OTG_HS_DIEPCTL3: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _12: u32 = 0,

    OTG_HS_DIEPINT3: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _13: u32 = 0,

    OTG_HS_DIEPTSIZ3: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA3: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DTXFSTS3: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _14: u32 = 0,

    OTG_HS_DIEPCTL4: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _15: u32 = 0,

    OTG_HS_DIEPINT4: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _16: u32 = 0,

    OTG_HS_DIEPTSIZ4: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA4: packed struct {
        DMAADDR: u32 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DTXFSTS4: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _17: u32 = 0,

    OTG_HS_DIEPCTL5: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _18: u32 = 0,

    OTG_HS_DIEPINT5: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _19: u32 = 0,

    OTG_HS_DIEPTSIZ5: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA5: u32 = 0,

    OTG_HS_DTXFSTS5: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _20: u32 = 0,

    OTG_HS_DIEPCTL6: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _21: u32 = 0,

    OTG_HS_DIEPINT6: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _22: u32 = 0,

    OTG_HS_DIEPTSIZ6: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA6: u32 = 0,

    OTG_HS_DTXFSTS6: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _23: u32 = 0,

    OTG_HS_DIEPCTL7: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        _1: u1 = 0,
        Stall: u1 = 0,
        TXFNUM: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _24: u32 = 0,

    OTG_HS_DIEPINT7: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        TOC: u1 = 0,
        ITTXFE: u1 = 0,
        _1: u1 = 0,
        INEPNE: u1 = 0,
        TXFE: u1 = 0,
        TXFIFOUDRN: u1 = 0,
        BNA: u1 = 0,
        _2: u1 = 0,
        PKTDRPSTS: u1 = 0,
        BERR: u1 = 0,
        NAK: u1 = 0,
        _3: u18 = 0,

        pub const set = set_masked;
    },

    _25: u32 = 0,

    OTG_HS_DIEPTSIZ7: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        MCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DIEPDMA7: u32 = 0,

    OTG_HS_DTXFSTS7: packed struct {
        INEPTFSAV: u16 = 0,
        _0: u16 = 0,

        pub const set = set_masked;
    },

    _26: u192 = 0,

    OTG_HS_DIEPDMA8: u32 = 0,

    _27: u224 = 0,

    OTG_HS_DIEPDMA9: u32 = 0,

    _28: u224 = 0,

    OTG_HS_DIEPDMA10: u32 = 0,

    _29: u224 = 0,

    OTG_HS_DIEPDMA11: u32 = 0,

    _30: u224 = 0,

    OTG_HS_DIEPDMA12: u32 = 0,

    _31: u224 = 0,

    OTG_HS_DIEPDMA13: u32 = 0,

    _32: u224 = 0,

    OTG_HS_DIEPDMA14: u32 = 0,

    _33: u224 = 0,

    OTG_HS_DIEPDMA15: u32 = 0,

    _34: u64 = 0,

    OTG_HS_DOEPCTL0: packed struct {
        MPSIZ: u2 = 0,
        _0: u13 = 0,
        USBAEP: u1 = 0,
        _1: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _2: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        _3: u2 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _35: u32 = 0,

    OTG_HS_DOEPINT0: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _36: u32 = 0,

    OTG_HS_DOEPTSIZ0: packed struct {
        XFRSIZ: u7 = 0,
        _0: u12 = 0,
        PKTCNT: u1 = 0,
        _1: u9 = 0,
        STUPCNT: u2 = 0,
        _2: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA0: u32 = 0,

    _37: u64 = 0,

    OTG_HS_DOEPCTL1: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _38: u32 = 0,

    OTG_HS_DOEPINT1: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _39: u32 = 0,

    OTG_HS_DOEPTSIZ1: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA1: u32 = 0,

    _40: u64 = 0,

    OTG_HS_DOEPCTL2: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _41: u32 = 0,

    OTG_HS_DOEPINT2: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _42: u32 = 0,

    OTG_HS_DOEPTSIZ2: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA2: u32 = 0,

    _43: u64 = 0,

    OTG_HS_DOEPCTL3: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _44: u32 = 0,

    OTG_HS_DOEPINT3: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _45: u32 = 0,

    OTG_HS_DOEPTSIZ3: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA3: u32 = 0,

    _46: u64 = 0,

    OTG_HS_DOEPCTL4: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _47: u32 = 0,

    OTG_HS_DOEPINT4: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _48: u32 = 0,

    OTG_HS_DOEPTSIZ4: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA4: u32 = 0,

    _49: u64 = 0,

    OTG_HS_DOEPCTL5: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _50: u32 = 0,

    OTG_HS_DOEPINT5: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _51: u32 = 0,

    OTG_HS_DOEPTSIZ5: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA5: u32 = 0,

    _52: u64 = 0,

    OTG_HS_DOEPCTL6: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _53: u32 = 0,

    OTG_HS_DOEPINT6: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _54: u32 = 0,

    OTG_HS_DOEPTSIZ6: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA6: u32 = 0,

    _55: u64 = 0,

    OTG_HS_DOEPCTL7: packed struct {
        MPSIZ: u11 = 0,
        _0: u4 = 0,
        USBAEP: u1 = 0,
        EONUM_DPID: u1 = 0,
        NAKSTS: u1 = 0,
        EPTYP: u2 = 0,
        SNPM: u1 = 0,
        Stall: u1 = 0,
        _1: u4 = 0,
        CNAK: u1 = 0,
        SNAK: u1 = 0,
        SD0PID_SEVNFRM: u1 = 0,
        SODDFRM: u1 = 0,
        EPDIS: u1 = 0,
        EPENA: u1 = 0,

        pub const set = set_masked;
    },

    _56: u32 = 0,

    OTG_HS_DOEPINT7: packed struct {
        XFRC: u1 = 0,
        EPDISD: u1 = 0,
        _0: u1 = 0,
        STUP: u1 = 0,
        OTEPDIS: u1 = 0,
        _1: u1 = 0,
        B2BSTUP: u1 = 0,
        _2: u7 = 0,
        NYET: u1 = 0,
        _3: u17 = 0,

        pub const set = set_masked;
    },

    _57: u32 = 0,

    OTG_HS_DOEPTSIZ7: packed struct {
        XFRSIZ: u19 = 0,
        PKTCNT: u10 = 0,
        RXDPID_STUPCNT: u2 = 0,
        _0: u1 = 0,

        pub const set = set_masked;
    },

    OTG_HS_DOEPDMA7: u32 = 0,

    _58: u224 = 0,

    OTG_HS_DOEPDMA8: u32 = 0,

    _59: u224 = 0,

    OTG_HS_DOEPDMA9: u32 = 0,

    _60: u224 = 0,

    OTG_HS_DOEPDMA10: u32 = 0,

    _61: u224 = 0,

    OTG_HS_DOEPDMA11: u32 = 0,

    _62: u224 = 0,

    OTG_HS_DOEPDMA12: u32 = 0,

    _63: u224 = 0,

    OTG_HS_DOEPDMA13: u32 = 0,

    _64: u224 = 0,

    OTG_HS_DOEPDMA14: u32 = 0,

    _65: u224 = 0,

    OTG_HS_DOEPDMA15: u32 = 0,
} = @ptrFromInt(0x40040800);

pub const WWDG: *volatile packed struct {
    CR: packed struct {
        T: u7 = 0,
        WDGA: u1 = 0,
        _0: u24 = 0,

        pub const set = set_masked;
    },

    CFR: packed struct {
        W: u7 = 0,
        WDGTB0: u1 = 0,
        WDGTB1: u1 = 0,
        EWI: u1 = 0,
        _0: u22 = 0,

        pub const set = set_masked;
    },

    SR: packed struct {
        EWIF: u1 = 0,
        _0: u31 = 0,

        pub const set = set_masked;
    },
} = @ptrFromInt(0x40002c00);

pub const IRQ = enum(u32) {
    WWDG = 0,
    PVD = 1,
    TAMP_STAMP = 2,
    RTC_WKUP = 3,
    FLASH = 4,
    RCC = 5,
    EXTI0 = 6,
    EXTI1 = 7,
    EXTI2 = 8,
    EXTI3 = 9,
    EXTI4 = 10,
    DMA1_Stream0 = 11,
    DMA1_Stream1 = 12,
    DMA1_Stream2 = 13,
    DMA1_Stream3 = 14,
    DMA1_Stream4 = 15,
    DMA1_Stream5 = 16,
    DMA1_Stream6 = 17,
    ADC = 18,
    CAN1_TX = 19,
    CAN1_RX0 = 20,
    CAN1_RX1 = 21,
    CAN1_SCE = 22,
    EXTI9_5 = 23,
    TIM1_BRK_TIM9 = 24,
    TIM1_UP_TIM10 = 25,
    TIM1_TRG_COM_TIM11 = 26,
    TIM1_CC = 27,
    TIM2 = 28,
    TIM3 = 29,
    TIM4 = 30,
    I2C1_EV = 31,
    I2C1_ER = 32,
    I2C2_EV = 33,
    I2C2_ER = 34,
    SPI1 = 35,
    SPI2 = 36,
    USART1 = 37,
    USART2 = 38,
    USART3 = 39,
    EXTI15_10 = 40,
    RTC_ALARM = 41,
    OTG_FS_WKUP = 42,
    TIM8_BRK_TIM12 = 43,
    TIM8_UP_TIM13 = 44,
    TIM8_TRG_COM_TIM14 = 45,
    TIM8_CC = 46,
    DMA1_Stream7 = 47,
    FSMC = 48,
    SDMMC1 = 49,
    TIM5 = 50,
    SPI3 = 51,
    UART4 = 52,
    UART5 = 53,
    TIM6_DAC = 54,
    TIM7 = 55,
    DMA2_Stream0 = 56,
    DMA2_Stream1 = 57,
    DMA2_Stream2 = 58,
    DMA2_Stream3 = 59,
    DMA2_Stream4 = 60,
    OTG_FS = 67,
    DMA2_Stream5 = 68,
    DMA2_Stream6 = 69,
    DMA2_Stream7 = 70,
    USART6 = 71,
    I2C3_EV = 72,
    I2C3_ER = 73,
    OTG_HS_EP1_OUT = 74,
    OTG_HS_EP1_IN = 75,
    OTG_HS_WKUP = 76,
    OTG_HS = 77,
    AES = 79,
    RNG = 80,
    FPU = 81,
    UART7 = 82,
    UART8 = 83,
    SPI4 = 84,
    SPI5 = 85,
    SAI1 = 87,
    SAI2 = 91,
    QuadSPI = 92,
    LP_Timer1 = 93,
    SDMMC2 = 103,
};
