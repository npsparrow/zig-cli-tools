const std = @import("std");
const testing = std.testing;

const styler = @import("root.zig");

test "red text" {
    const styled = styler.red("This should be red!");
    std.debug.print("\n{s}\n", .{styled});
}

test "format func" {
    styler.format("tester!", .{ styler.ansi.fg_red, styler.ansi.bold });
}
