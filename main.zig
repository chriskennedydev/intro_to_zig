const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, {}!\n", .{"World!"});

    var some_var: i32 = 5;
    const some_const: u64 = 5000;

    var new_var = @as(i32, 5);
    var new_const = @as(u64, 5000);

    var x: u8 = undefined;
    var y: i16 = undefined;

    _ = 10;

    const a = [3]u8{ 1, 2, 3 };
    const b = [_]u8{ 2, 4, 6 };
}
