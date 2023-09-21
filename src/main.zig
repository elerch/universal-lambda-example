const std = @import("std");
const universal_lambda = @import("universal_lambda_handler");

pub fn main() !void {
    try universal_lambda.run(null, handler);
}

pub fn handler(allocator: std.mem.Allocator, event_data: []const u8, context: universal_lambda.Context) ![]const u8 {
    _ = event_data;
    _ = allocator;
    _ = context;
    return "hello world";
}
