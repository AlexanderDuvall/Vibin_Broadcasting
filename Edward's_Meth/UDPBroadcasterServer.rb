require 'socket'
require 'ruby-audio'

Socket.udp_server_loop("localhost", 12345) {|msg, msg_src|
puts msg_src
snd = RubyAudio::Sound.open("You.wav")
snip_time_begin = 0
while 1 do
  info = snd.info
  # create a buffer as big as the snippet
  bytes_to_read = (info.samplerate * 2).to_i
  buf = RubyAudio::Buffer.new("float", bytes_to_read, info.channels)
  # seek to where the snippet begins and grab the audio
  snd.seek(info.samplerate * snip_time_begin)
  snd.read(buf, bytes_to_read)
  # write the new snippet to a file
  out = RubyAudio::Sound.open("YouToo.wav", "w", info.clone)
  out.write(buf)
  snip_time_begin = snip_time_begin + 5
  sleep(4)
  msg_src.reply "lmao uga ass"
  sleep(2)
end
}


=begin

require 'audio_trimmer'
trimmer = AudioTrimmer.new input: "/Users/edwardsotelojr/PycharmProjects/UDP/venv/Young_Nudy_ft._Playboi_Carti_-_Pissy_Pamper-youtube-VB-jb93xwWw-140.wav"
trimmer.trim start: 0, finish:20, output: "/Users/edwardsotelojr/PycharmProjects/UDP/venv/Young_Nudy12.wav"


=end
