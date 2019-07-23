#local Broadcaster
require 'socket'
class Server
  @server = nil

  def sever_connection
    puts "starting thread..."
    loop do
      puts "looping"
      sleep(3)
      if Thread.current.thread_variable? :time
        puts "comparing"
        past_time = Thread.current.thread_variable_get :time
        current_time = Time.now.to_f.round
        if (current_time - past_time > 5)
          @socket.close
          puts "severing conn.."
          break;
        else
          puts "still good..."
        end
      else
        puts "Var not set"
      end
    end
    puts "fin"
  end

  def initialize (remote_host,port)
    @server = TCPServer.new "localhost", port
    @client = nil
    @ip = remote_host
  end

  def run
    loop do
      puts 'waiting....'
      @client = @server.accept
      request = @client.readpartial(2048)
      # puts request
      request_info = parse(request.to_s)
      if (request_info.key?("User_id"))
        resp = "True"
        puts "We have confirmation that the machine has been reached."
        headers = ["HTTP/1.1 200 OK",
                   "Access-Control-Allow-Origin:http://localhost:3000\r\n",
                   "Date: Tue, 14 Dec 2010 10:48:45 GMT",
                   "Server: Ruby",
                   "Content-Type: text/html; charset=iso-8859-1",
                   "Content-Length: #{resp.length}", "Machine-Reached-Status:#{resp}"].join("\r\n")
        @client.print headers
        @client.close
        @socket = TCPSocket.open(@ip, 4445)
        send_id(request_info["User_id"])
        sever = Thread.new do |f|
          sever_connection
        end
        loop do
          puts "waiting for next byte..."
          client = @server.accept
          sever.alive? ? sever.thread_variable_set(:time, Time.now.to_f.round) : break
          info = client.readpartial(2048)
          parsed_info = receive info
          client.close
          if (parsed_info.key?("Action"))
            send_off parsed_info["Action"], nil
          else
            send_off parsed_info["Duration"], parsed_info["Song_id"]
          end
        end
        sever.join
      else
        @client.close
        puts "reality is often disappointing"

      end
    end
  end

  def send_id(id)
    if @socket
      puts "sent it out: #{id}"
      @socket.puts("Broadcaster:#{id}")
    else
      puts "Socket it null"
    end
  end

  def send_off(duration, song_id)
    if @socket
      if (song_id.nil?)
        @socket.puts "Action:#{duration} \n"
        puts "sent off"
      else
        @socket.puts "Duration:#{duration} \nSong_id:#{song_id}"
        puts "sent off"
      end
    else
      puts "socket is nil"
    end
  end

  def receive(lines)

    info = Hash.new
    lines = reorderLines(lines)
    lines.each_line do |line|
      contents = line.split(":")
      info[contents[0]] = contents[1]
    end
    if info["Duration"] || info["Song_id"]
      puts "Current Song Duration: #{info["Duration"]}"
      puts "Current Song Id: #{info["Song_id"]}"
      return info
    elsif info["Action"]
      puts "Current Action #{info["Action"]}"
      return info
    else
      puts "one is null"
    end
  end

  def reorderLines(lines)
    puts "reordering...."
    new_lines = ""
    lines.each_line do |f|
      if (f.strip!.length == 0 || f.include?("------"))
        next
      elsif f.include?("Content-Disposition: form-data; ")
        f = f.gsub "Content-Disposition: form-data; name=", ""
        f = f.gsub "\"", ""
        new_lines += f
        new_lines += ":"
      else
        new_lines += f
        new_lines += "\n"
      end
    end
    return new_lines
  end

  def parse(request)
    request = reorderLines(request)
    info = Hash.new
    request.to_s.each_line do |f|
      contents = f.split(":")
      info[contents[0]] = contents[1]
    end
    if info.key "Broadcaster"
      return nil
    end
    return info
  end

  def is_number?(obj)
    obj.to_f.to_s == obj.to_s || obj.to_i.to_s == obj.to_s
  end

end

