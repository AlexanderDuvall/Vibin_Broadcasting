require 'socket'
require_relative '../Broadcasting Server/Server'
class Requests
  def initialize(ip_v4, port, dedicated_server)
    @song = nil
    @duration = nil
    @server = TCPServer.new ip_v4, port
    loop do
      puts "listening for requests"
      current_client = @server.accept
      Thread.start(current_client) do |client|
        loop do
          puts "looping...x"
          lines = client.readpartial(2048)
          # puts "results.... #{lines}"
          request = receive lines
          unless (request.nil?)
            if (request.key?("Broadcaster_id") && !request["Broadcaster_id"].nil?)
              if (dedicated_server.exists_key?(request["Broadcaster_id"]))
                data = dedicated_server.get_data(request["Broadcaster_id"])[0]
                puts "DATA:   #{data.class}"
                @song = data['Song_id']
                puts "Song: #{@song}, #{@song.class}"
                @duration = data['Duration']
                puts "Duration: #{@duration}, #{@duration.class}"
                client.puts build_header @song.to_s, @duration.to_s
                puts "SENT BACK THE DATA."
              else
                data = dedicated_server.get_data(request["Broadcaster_id"])[0]
                @song = -1
                @duration = -1
                client.puts build_header @song.to_s, @duration.to_s
              end
            else
              puts "bad key"
            end
          else
            puts "user request..."
          end
          client.close
          break
        end
      end
    end
  end

  private

  def build_header(song, duration)
    length = song + duration
    length = length.length
    headers = ["HTTP/1.1 200 OK",
               "Access-Control-Allow-Origin:http://localhost:3000\r\n",
               "Date: Tue, 14 Dec 2010 10:48:45 GMT",
               "Server: Ruby",
               "Content-Type: text/html; charset=iso-8859-1",
               "Content-Length: #{length}", "Song_id:#{song}", "Duration:#{duration}"].join("\r\n")
    headers
  end

  def receive(lines)

    info = Hash.new
    lines = reorderLines(lines)
    lines.each_line do |line|
      contents = line.split(":")
      info[contents[0]] = contents[1]
    end
    unless !info["Broadcaster_id"]
      puts "Broadcaster id: #{info["Broadcaster_id"]}"
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

end