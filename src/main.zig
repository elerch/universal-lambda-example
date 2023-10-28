const std = @import("std");
const universal_lambda = @import("universal_lambda_handler");
const interface = @import("universal_lambda_interface");

pub fn main() !u8 {
    return try universal_lambda.run(null, handler);
}

fn handler(allocator: std.mem.Allocator, event_data: []const u8, context: interface.Context) ![]const u8 {
    // our allocator is an area, so yolo
    var al = std.ArrayList(u8).init(allocator);
    var writer = al.writer();
    try writer.print("Header data passed to handler (if console, this is args+env vars)\n", .{});
    for (context.request.headers.list.items) |f| {
        try writer.print("\t{s}: {s}\n", .{ f.name, f.value });
    }
    try writer.print("======================================================================\n", .{});
    try writer.print("Event handler target: {s}\n", .{context.request.target});
    try writer.print("Event data passed to handler: {s}\n", .{event_data});
    return al.items;
}

test "simple test" {
    try std.testing.expectEqual(@as(usize, 4), 2 + 2);
}
