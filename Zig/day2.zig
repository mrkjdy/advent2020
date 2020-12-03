const std = @import("std");

const fmt = std.fmt;
const heap = std.heap;
const io = std.io;
const mem = std.mem;

// Zig is just low-level Rust, change my mind

// No documentation for methods in std lib is quite annoying
// No intellisense sucks
// No scanf is really annoying

/// The first part
fn is_valid_1(min: u64, max: u64, c: u8, pwd: []const u8) bool {
    var c_count: u64 = 0;
    for (pwd) |p| {
        if (p == c) {
            c_count += 1;
        }
        if (c_count > max) {
            return false;
        }
    }
    return c_count >= min;
}

/// The second part
fn is_valid_2(pos1: u64, pos2: u64, c: u8, pwd: []const u8) bool {
    return (pwd[pos1] == c) != (pwd[pos2] == c);
}

pub fn main() !void {
    const stdin = io.getStdIn().inStream();
    const stdout = std.io.getStdOut().outStream();
    var num_valid: u64 = 0;
    while (true) {
        var arena = heap.ArenaAllocator.init(heap.page_allocator);
        defer arena.deinit();
        const line =
            try stdin.readUntilDelimiterAlloc(&arena.allocator, '\n', 2097152);
        if (line.len <= 0) {
            break;
        }
        // This is really ugly, wish there was scanf
        const dash_pos = mem.indexOf(u8, line, "-").?;
        const num1 = try fmt.parseUnsigned(u64, line[0..dash_pos], 10);
        const space_pos = mem.indexOf(u8, line, " ").?;
        const num2 = try fmt.parseUnsigned(u64, line[dash_pos+1..space_pos], 10);
        const colon_pos = mem.indexOf(u8, line, ":").?;
        const c = line[colon_pos-1];
        const password = line[colon_pos+1..];
        if (is_valid_2(num1, num2, c, password)) {
            num_valid += 1;
        }
    }
    try stdout.print("{} valid\n", .{ num_valid });
}