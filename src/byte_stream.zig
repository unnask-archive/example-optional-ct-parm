const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

//quick example of an optional type parameter

pub fn fixedByteStream() ByteStream {
    return ByteStream(null);
}

pub const FixedByteStream = ByteStream(null);

pub fn managedByteStream(comptime allocator: Allocator) ByteStream {
    return ByteStream(allocator);
}

fn ByteStream(comptime allocator: ?Allocator) type {
    return struct {
        const Self = @This();

        capacity: usize,
        bytes: []u8,

        pub const init = if (allocator) |_| initCapacity else initFixed;

        fn initCapacity(capacity: usize) Allocator.Error!Self {
            var alloc = if (allocator) |a| a else @compileError("initCapacity requires allocator. Use managedByteStream.");
            var bytes = try alloc.alloc(u8, capacity);
            bytes.len = 0;

            return .{
                .capacity = capacity,
                .bytes = bytes,
            };
        }

        fn initFixed(buffer: []u8) Self {
            const capacity = buffer.len;
            buffer.len = 0;

            return .{
                .capacity = capacity,
                .bytes = buffer,
            };
        }
    };
}
