#!/usr/bin/env ruby

require "rgb"

primary_color = "#00d1b2"
# primary_color = "#7957d5"
count = 8
size = 256
output_dir = "../app/assets/images/human"
point_size = 160
label = "?"

base_color = RGB::Color.from_rgb_hex(primary_color)

count.times do |i|
  c = RGB::Color.from_fractions((1.0 / count) * i, base_color.s, base_color.l)
  background = c.to_rgb_hex               # => "#D10000", "#D19D00", "#69D100", "#00D134", "#00D1D1", "#0034D1", "#6800D1", "#D1009D"
  fill = c.lighten_percent(97).to_rgb_hex # => "#FFF6F6", "#FFFDF6", "#FAFFF6", "#F6FFF8", "#F6FFFF", "#F6F8FF", "#FAF6FF", "#FFF6FD"
  filepath = "#{output_dir}/%04d_fallback_avatar_icon.png" % i
  command = "convert -background '#{background}' -fill '#{fill}' -size #{size}x#{size} -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize #{point_size} label:'#{label}' #{filepath}"
  puts command
  puts system(command)
  puts filepath
end
# >> convert -background '#D10000' -fill '#FFF6F6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0000_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0000_fallback_avatar_icon.png
# >> convert -background '#D19D00' -fill '#FFFDF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0001_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0001_fallback_avatar_icon.png
# >> convert -background '#69D100' -fill '#FAFFF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0002_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0002_fallback_avatar_icon.png
# >> convert -background '#00D134' -fill '#F6FFF8' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0003_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0003_fallback_avatar_icon.png
# >> convert -background '#00D1D1' -fill '#F6FFFF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0004_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0004_fallback_avatar_icon.png
# >> convert -background '#0034D1' -fill '#F6F8FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0005_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0005_fallback_avatar_icon.png
# >> convert -background '#6800D1' -fill '#FAF6FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0006_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0006_fallback_avatar_icon.png
# >> convert -background '#D1009D' -fill '#FFF6FD' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0007_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0007_fallback_avatar_icon.png
