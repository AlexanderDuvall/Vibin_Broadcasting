require 'socket'
#sends a requests
a = TCPSocket.open '192.168.1.91', '4446'
a.puts "Broadcaster_id:1"
puts a.gets
