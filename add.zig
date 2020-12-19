const std = @import("std");
const expect = @import("std").testing.expect;

test "switch" {
    var x: i8 = 10;

    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            x = @divExact(x, 10);
        },
        else => {},
    }
    expect(x == 1);
}

test "switch as expression" {
    var x: i8 = 10;

    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    expect(x == 1);
}

fn addFive(x: u32) u32 {
    return x + 5;
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function" {
    const y = addFive(0);
    expect(@TypeOf(y) == u32);
    expect(y == 5);
}

test "recursion" {
    const x = fibonacci(10);
    expect(x == 55);
}

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        expect(x == 5);
    }
    expect(x == 7);
}

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    expect(err == FileOpenError.OutOfMemory);
}

test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    expect(@TypeOf(no_error) == u16);
    expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        expect(err == error.Oops);
        return;
    };
}

fn failFn() error{Oops}!i32 {
    try failingFunction();
    return 12;
}

test "try" {
    var v = failFn() catch |err| {
        expect(err == error.Oops);
        return;
    };
    expect(v == 12); // never executes
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        expect(err == error.Oops);
        expect(problems == 99);
        return;
    };
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    // type coercion successfully occurs
    const x: error{AccessDenied}!void = createFile();
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable code" {
    expect(asciiToUpper('a') == 'A');
    expect(asciiToUpper('A') == 'A');
}

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    expect(x == 2);
}

test "usize" {
    expect(@sizeOf(usize) == @sizeOf(*u8));
    expect(@sizeOf(isize) == @sizeOf(*i8));
}

fn total(values: []const u8) usize {
    var count: usize = 0;
    for (values) |v| count += v;
    return count;
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    expect(total(slice) == 6);
}

test "slices2" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    expect(@TypeOf(slice) == *const [3]u8);
}

test "slices3" {
    var array = [_]u8{ 1, 2, 3, 4, 5 };
    var slice = array[0..];
}
