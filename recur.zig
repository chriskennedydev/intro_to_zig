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

    const luck = [_]u8{ 4, 8, 15, 16, 23, 42 };

    for (luck) |n, i| {
        if (n % 2 == 0) {
            std.debug.print("{} {}\n", .{ i, n });
        }
    }

    const arr = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = arr[0..3];

    for (slice) |v| {
        std.debug.print("{}\n", .{v});
    }

    const name: [*:0]const u8 = "Christopher Kennedy";

    std.debug.print("{}\n", .{name});
}
