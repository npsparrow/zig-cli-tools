const std = @import("std");

/// ANSI escape codes for terminal formatting
pub const ansi = enum(u8) {
    reset = 0,

    // text styles
    bold = 1,
    dim = 2,
    italic = 3,
    underline = 4,
    blink = 5,
    inverse = 7,
    hidden = 8,
    strikethrough = 9,

    // foreground colors (normal)
    fg_black = 30,
    fg_red = 31,
    fg_green = 32,
    fg_yellow = 33,
    fg_blue = 34,
    fg_magenta = 35,
    fg_cyan = 36,
    fg_white = 37,
    fg_default = 39,

    // background colors (normal)
    bg_black = 40,
    bg_red = 41,
    bg_green = 42,
    bg_yellow = 43,
    bg_blue = 44,
    bg_magenta = 45,
    bg_cyan = 46,
    bg_white = 47,
    bg_default = 49,

    // bright foreground colors
    fg_bright_black = 90,
    fg_bright_red = 91,
    fg_bright_green = 92,
    fg_bright_yellow = 93,
    fg_bright_blue = 94,
    fg_bright_magenta = 95,
    fg_bright_cyan = 96,
    fg_bright_white = 97,

    // bright background colors
    bg_bright_black = 100,
    bg_bright_red = 101,
    bg_bright_green = 102,
    bg_bright_yellow = 103,
    bg_bright_blue = 104,
    bg_bright_magenta = 105,
    bg_bright_cyan = 106,
    bg_bright_white = 107,

    // Returns the ANSI escape sequence for this code
    // pub fn sequence(self: Ansi) []const u8 {
    //     return switch (self) {
    //         inline else => |code| std.fmt.comptimePrint("\x1b[{d}m", .{@intFromEnum(code)}),
    //     };
    // }

    // Returns a string wrapped with this ANSI code and a reset code
    // pub fn format(self: Ansi, text: []const u8) []const u8 {
    //     return std.fmt.comptimePrint("{s}{s}{s}", .{
    //         self.sequence(),
    //         text,
    //         Ansi.reset.sequence(),
    //     });
    // }
};

pub inline fn format(comptime text: []const u8, args: anytype) void {
    const args_type = @TypeOf(args);
    comptime {
        if (@typeInfo(args_type) != .@"struct") {
            @compileError("Expected tuple or struct argument, found " ++ @typeName(args_type));
        }
        if (!@typeInfo(args_type).@"struct".is_tuple) {
            @compileError("Expected tuple or struct argument, found " ++ @typeName(args_type));
        }
    }

    std.debug.print("Text: {s}\n", .{text});
    const fields = @typeInfo(args_type).@"struct".fields;
    const len = @typeInfo(args_type).@"struct".fields.len;
    var ret = "";
    inline for (fields) |field| {
        const value = @field(args, field.name);

        const value_type = @TypeOf(value);
        if (comptime !(value_type == ansi)) {
            @compileError("Expected type root.ansi, got " ++ @typeName(value_type));
        }

        // std.debug.print("Field '{s}' = {any}\n", .{ field.name, value });
        ret = comptime std.fmt.comptimePrint(ret ++ "\x1b[{d}m", .{@intFromEnum(value)});
    }
    ret += text ++ "\x1b[0m";
}

pub inline fn red(comptime text: []const u8) []const u8 {
    return "\x1b[31m\x1b[1m" ++ text ++ "\x1b[0m";
}
