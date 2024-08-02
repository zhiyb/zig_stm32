const std = @import("std");
const rcc = @import("rcc.zig");

comptime {
    // Force import start.zig
    _ = @import("start.zig");
}

pub fn main() noreturn {
    // Init
    rcc.init();
    @breakpoint();

    // Function
    while (true) {}
}
