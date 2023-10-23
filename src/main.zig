const std = @import("std");
const universal_lambda = @import("universal_lambda_handler");
const helpers = @import("universal_lambda_helpers"); // not necessary, but these functions provide common access to common things

pub fn main() !u8 {
    return try universal_lambda.run(null, handler);
}

pub fn handler(allocator: std.mem.Allocator, event_data: []const u8, context: universal_lambda.Context) ![]const u8 {
    // our allocator is an area, so yolo
    const target = try helpers.findTarget(allocator, context);
    var al = std.ArrayList(u8).init(allocator);
    var writer = al.writer();
    var headers = try helpers.allHeaders(allocator, context);
    try writer.print("Header data passed to handler (if console, this is args+env vars)\n", .{});
    for (headers.http_headers.list.items) |f| {
        try writer.print("\t{s}: {s}\n", .{ f.name, f.value });
    }
    try writer.print("======================================================================\n", .{});
    try writer.print("Event handler target: {s}\n", .{target});
    try writer.print("Event data passed to handler: {s}\n", .{event_data});
    return al.items;
}
