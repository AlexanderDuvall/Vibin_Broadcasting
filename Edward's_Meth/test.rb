require 'mysql2'

begin
  puts "UPDATING DB...."
  con = Mysql2::Client.new(:host => "192.168.1.70", :username => "root", :password => "password", :database => "vibinmusic_beta_development", :port => "3306")
  query = con.prepare("UPDATE Broadcasters SET is_playing = 0 WHERE Id = ?")
  result = query.execute(2)
  puts "result #{result}"
rescue Mysql2::Error => e
  puts e.errno
  puts e.error
ensure
  con.close if con
end
