const std = @import("std");
const expect = @import("std").testing.expect;
const eql = @import("std").mem.eql;

const ArrayList = std.ArrayList;
const test_allocator = std.testing.allocator;

test "while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    expect(i == 128);
}

test "while with continue expression" {
    var sum: u8 = 0;

    var i: u8 = 1;

    while (i <= 10) : (i += 1) {
        sum += i;
    }
    expect(sum == 55);
}

test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    expect(sum == 4);
}

test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;

    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    expect(sum == 1);
}

//test "another one bites the dust" {
//    const dst: [*:0]const u8 = "bites";
//
//    expect(dst == "bites");
//}

//test "arraylist" {
//    var list = ArrayList(u8).init(test_allocator);
//    defer list.deinit();
//    try list.append('H');
//    try list.append('e');
//    try list.append('l');
//    try list.append('l');
//    try list.append('o');
//    try list.appendSlice(" Linux!");
//
//    expect(eql(u8, list.items, "Hello Linux!"));
//}
