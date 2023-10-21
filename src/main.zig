const std = @import("std");
const universal_lambda = @import("universal_lambda_handler");
const helpers = @import("helpers.zig"); // not necessary, but these functions provide common access to common things
pub fn main() !void {
    try universal_lambda.run(null, handler);
}

pub fn handler(allocator: std.mem.Allocator, event_data: []const u8, context: universal_lambda.Context) ![]const u8 {
    // our allocator is an area, so yolo
    const target = try helpers.findTarget(allocator, context);
    var al = std.ArrayList(u8).init(allocator);
    var writer = al.writer();
    var args = try std.process.argsWithAllocator(allocator);
    while (args.next()) |arg| {
        try writer.print("\tcalled with arg: {s}\n", .{arg});
    }
    try writer.print("(target: {s}) Event data, from you, to me, to you: {s}\n", .{ target, event_data });
    try writer.print("Value for header 'Foo' is: {s}\n", .{try helpers.getFirstHeaderValue(allocator, context, "foo") orelse "undefined"});
    return al.items;
}
