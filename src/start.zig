const root = @import("root");

comptime {
    // Interrupt vector table
    asm (
        \\      .section .isr_vector,"a",%progbits
        \\      .type g_pfnVectors, %object
        \\  g_pfnVectors:
        \\      .word __stack_end
        \\      .word Reset_Handler
        \\      .size g_pfnVectors, .-g_pfnVectors
    );

    // Startup entry function
    @export(_main, .{ .name = "_main" });

    asm (
        \\      .section .text.Reset_Handler
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
