class DisplayListener
  def initialize(ip_v4, port, dedicated_server)
    @server = TCPServer.new ip_v4, port
    @dedicated_server = dedicated_server
  end

  def run
    puts "Rails View Listener Running"
    loop do
      client = @server.accept
      request = receive client.gets

      if (request.key?("Action") && !request["Action"].nil?)
        Thread.start(client) do |client|
          begin
            users = @dedicated_server.get_users
            client.puts users
            puts "sent back info to server"
            client.close
          rescue Exception => e
            puts e.message
          end
        end
      else
        puts "CLient rejected...wrong keys: #{request}"
        client.close
      end
    end
  end

  def receive(lines)
    info = Hash.new # dictionary
    puts "This is what we Received"
    lines = @dedicated_server.reorderLines(lines) #move empty lines
    lines.each_line do |line|
      contents = line.strip!.split(":") # strip doesnt do anything here?
      info[contents[0]] = contents[1] # info[ : ]
    end
    return info
  end
end