// Imports
const std = @import("std");
const expect = @import("std").testing.expect;

// ************************
// *      Constants       *
// ************************
const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

const decimal_int: i32 = 98222;

const hex_int: u8 = 0xff;

const another_hex_int: u8 = 0xFF;

const octal_int: u16 = 0o755;

const binary_int: u8 = 0b11110000;

const one_billion: u64 = 1_000_000_000;

const binary_mask: u64 = 0b1_1111_1111;

const permissions: u64 = 0o7_5_5;

const big_address: u64 = 0xFF80_0000_0000_0000;

const Tag = enum { a, b, c };

const Tagged = union(Tag) { a: u8, b: f32, c: bool };

const Tagged2 = union(enum) { a: u8, b: f32, c: bool };

const Tagged3 = union(enum) { a: u8, b: f32, c: bool, none };

const Stuff = struct {
    x: i32,
    y: i32,

    fn swap(self: *Stuff) void {
        const tmp = self.x;
        self.x = self.y;
        self.y = tmp;
    }
};

const Vec3 = struct {
    x: f32, y: f32, z: f32
};

const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next,
};

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

const Vec4 = struct {
    x: f32, y: f32, z: f32 = 0, w: f32 = undefined
};

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};

const Direction = enum { north, south, east, west };

const Value = enum(u2) { zero, one, two };

// ********************
// *    Variables     *
// ********************
var problems: u32 = 98;
var numbers_left: u32 = 4;

// *******************
// *     Functions   *
// *******************
fn addFive(x: u32) u32 {
    return x + 5;
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

fn failFn() error{Oops}!i32 {
    try failingFunction();
    return 12;
}

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

fn createFile() !void {
    return error.AccessDenied;
}

fn rangeHasNumber(begin: usize, end: usize, number: usize) bool {
    var i = begin;

    return while (i < end) : (i += 1) {
        if (i == number) {
            break true;
        }
    } else false;
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

fn eventuallyNullSequence() ?u32 {
    if (numbers_left == 0) return null;
    numbers_left -= 1;
    return numbers_left;
}

fn increment(num: *u8) void {
    num.* += 1;
}

fn total(values: []const u8) usize {
    var count: usize = 0;
    for (values) |v| count += v;
    return count;
}

// ******************
// *     Tests      *
// ******************
test "struct usage" {
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };
}

test "struct defaults" {
    const my_vector = Vec4{
        .x = 25,
        .y = -50,
    };
}

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

test "returning an error" {
    failingFunction() catch |err| {
        expect(err == error.Oops);
        return;
    };
}

test "try" {
    var v = failFn() catch |err| {
        expect(err == error.Oops);
        return;
    };
    expect(v == 12); // never executes
}

test "errdefer" {
    failFnCounter() catch |err| {
        expect(err == error.Oops);
        expect(problems == 99);
        return;
    };
}

test "inferred error set" {
    // type coercion successfully occurs
    const x: error{AccessDenied}!void = createFile();
}

test "unreachable code" {
    expect(asciiToUpper('a') == 'A');
    expect(asciiToUpper('A') == 'A');
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

test "enum ordinal value" {
    expect(@enumToInt(Value.zero) == 0);
    expect(@enumToInt(Value.one) == 1);
    expect(@enumToInt(Value.two) == 2);
}

test "set enum ordinal value" {
    expect(@enumToInt(Value2.hundred) == 100);
    expect(@enumToInt(Value2.thousand) == 1000);
    expect(@enumToInt(Value2.million) == 1000000);
    expect(@enumToInt(Value2.next) == 1000001);
}

test "enum method" {
    expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

test "hmm" {
    Mode.count += 1;
    expect(Mode.count == 1);
}

test "automatic dereference" {
    var thing = Stuff{ .x = 10, .y = 20 };
    thing.swap();
    expect(thing.x == 20);
    expect(thing.y == 10);
}

test "switch on tagged union" {
    var value = Tagged3{ .b = 1.5 };
    switch (value) {
        .a => |*byte| byte.* += 1,
        .b => |*float| float.* *= 2,
        .c => |*b| b.* = !b.*,
        .none => |*none| std.debug.print("None\n", .{}),
    }
    expect(value.b == 3);
}

test "integer widening" {
    const a: u8 = 250;
    const b: u16 = a;
    const c: u32 = b;

    expect(c == a);
}

test "@intCast" {
    const x: u64 = 200;
    const y = @intCast(u8, x);
    expect(@TypeOf(y) == u8);
}

test "well defined overflow" {
    var a: u8 = 255;
    a +%= 1;
    expect(a == 0);
}

test "float widening" {
    const a: f16 = 0;
    const b: f32 = a;
    const c: f128 = b;
    expect(c == @as(f128, a));
}

test "labelled blocks" {
    const count = blkloop: {
        var sum: u32 = 0;
        var i: u32 = 0;
        while (i < 10) : (i += 1) sum += i;
        break :blkloop sum;
    };
    expect(count == 45);
    expect(@TypeOf(count) == u32);
}

test "nested continue" {
    var count: usize = 0;
    outer: for ([_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 }) |_| {
        for ([_]i32{ 1, 2, 3, 4, 5 }) |_| {
            count += 1;
            continue :outer;
        }
    }
    expect(count == 8);
}

test "while loop expr" {
    expect(rangeHasNumber(0, 10, 3));
}

test "optional" {
    var found_index: ?usize = null;
    const data = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 12 };
    for (data) |v, i| {
        if (v == 10) found_index = i;
    }
    expect(found_index == null);
}

test "orelse" {
    var a: ?f32 = null;
    var b = a orelse 0;
    expect(b == 0);
    expect(@TypeOf(b) == f32);
}

test "orelse unreachable" {
    const a: ?f32 = 5;
    const b = a orelse unreachable;
    const c = a.?;
    expect(b == c);
    expect(@TypeOf(c) == f32);
}

test "if optional payload capture" {
    const a: ?i32 = 5;
    if (a != null) {
        const value = a.?;
    }

    const b: ?i32 = 5;
    if (b) |value| {}
}

test "while null capture" {
    var sum: u32 = 0;
    while (eventuallyNullSequence()) |value| {
        sum += value;
    }
    expect(sum == 6);
}

test "comptime blocks" {
    var x = comptime fibonacci(10);

    var y = comptime blk: {
        break :blk fibonacci(10);
    };
}
