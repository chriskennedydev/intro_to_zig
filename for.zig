test "for" {
    // character literals are equivalent to integer literals
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string) |character, index| {}

    for (string) |character| {}

    for (string) |_, index| {}

    for (string) |_| {}
}
