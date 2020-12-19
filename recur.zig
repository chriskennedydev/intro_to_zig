const std = @import("std");

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

pub fn main() void {
    const x: u16 = fibonacci(10);
    const y: u16 = fibonacci(20);

    std.debug.print("{}\n", .{x});
    std.debug.print("{}\n", .{y});
}
