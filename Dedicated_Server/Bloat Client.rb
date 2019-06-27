require 'socket'

s = TCPSocket.open '192.168.1.123', 4445
begin
  if s
    puts "Starting the Client..................."
    s.puts "this is a test"
    while message = s.gets # Read lines from the socket
      puts message
    end
    puts "Closing the Client..................."
    s.close # Close the socket
  else
    puts "....nil"
  end
rescue Exception => e
  puts e.message
end