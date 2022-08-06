const std = @import("std");
const net = std.net;

pub fn main() anyerror!void {
  var server = net.StreamServer.init(.{});
  defer server.deinit();

  try server.listen(net.Address.parseIp("127.0.0.1", 0) catch unreachable);
  std.log.info("listen at {}\n", .{server.listen_address});

  while ((server.accept())) |conn| {
    std.log.info("Accepted Connection from: {}", .{conn.address});
    if (conn.stream.write("hello")) |size| {
      std.log.info("size message is {}", .{size});
    } else |err| {
      std.log.err("Error: {}", .{err});
    }
    conn.stream.close();
  } else |err| {
    return err;
  }
}