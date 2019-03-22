#!/usr/bin/env ruby

require "rgb"

primary_color = "#00d1b2"
# primary_color = "#7957d5"
count = 32
size = 256
output_dir = "../app/assets/images/human"
point_size = 160
label = "?"

base_color = RGB::Color.from_rgb_hex(primary_color)

count.times do |i|
  c = RGB::Color.from_fractions((1.0 / count) * i, base_color.s, base_color.l)
  background = c.to_rgb_hex               # => "#D10000", "#D12700", "#D14E00", "#D17600", "#D19D00", "#D1C400", "#B7D100", "#90D100", "#69D100", "#41D100", "#1AD100", "#00D10D", "#00D134", "#00D15B", "#00D183", "#00D1AA", "#00D1D1", "#00AAD1", "#0083D1", "#005BD1", "#0034D1", "#000DD1", "#1A00D1", "#4100D1", "#6800D1", "#9000D1", "#B700D1", "#D100C4", "#D1009D", "#D10076", "#D1004E", "#D10027"
  fill = c.lighten_percent(97).to_rgb_hex # => "#FFF6F6", "#FFF8F6", "#FFF9F6", "#FFFBF6", "#FFFDF6", "#FFFEF6", "#FEFFF6", "#FCFFF6", "#FAFFF6", "#F9FFF6", "#F7FFF6", "#F6FFF7", "#F6FFF8", "#F6FFFA", "#F6FFFC", "#F6FFFD", "#F6FFFF", "#F6FDFF", "#F6FCFF", "#F6FAFF", "#F6F8FF", "#F6F7FF", "#F7F6FF", "#F9F6FF", "#FAF6FF", "#FCF6FF", "#FEF6FF", "#FFF6FE", "#FFF6FD", "#FFF6FB", "#FFF6F9", "#FFF6F8"
  filepath = "#{output_dir}/%04d_fallback_avatar_icon.png" % i
  command = "convert -background '#{background}' -fill '#{fill}' -size #{size}x#{size} -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize #{point_size} label:'#{label}' #{filepath}"
  puts command
  puts system(command)
  puts filepath
end
# >> convert -background '#D10000' -fill '#FFF6F6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0000_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0000_fallback_avatar_icon.png
# >> convert -background '#D12700' -fill '#FFF8F6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0001_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0001_fallback_avatar_icon.png
# >> convert -background '#D14E00' -fill '#FFF9F6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0002_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0002_fallback_avatar_icon.png
# >> convert -background '#D17600' -fill '#FFFBF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0003_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0003_fallback_avatar_icon.png
# >> convert -background '#D19D00' -fill '#FFFDF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0004_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0004_fallback_avatar_icon.png
# >> convert -background '#D1C400' -fill '#FFFEF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0005_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0005_fallback_avatar_icon.png
# >> convert -background '#B7D100' -fill '#FEFFF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0006_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0006_fallback_avatar_icon.png
# >> convert -background '#90D100' -fill '#FCFFF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0007_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0007_fallback_avatar_icon.png
# >> convert -background '#69D100' -fill '#FAFFF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0008_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0008_fallback_avatar_icon.png
# >> convert -background '#41D100' -fill '#F9FFF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0009_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0009_fallback_avatar_icon.png
# >> convert -background '#1AD100' -fill '#F7FFF6' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0010_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0010_fallback_avatar_icon.png
# >> convert -background '#00D10D' -fill '#F6FFF7' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0011_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0011_fallback_avatar_icon.png
# >> convert -background '#00D134' -fill '#F6FFF8' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0012_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0012_fallback_avatar_icon.png
# >> convert -background '#00D15B' -fill '#F6FFFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0013_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0013_fallback_avatar_icon.png
# >> convert -background '#00D183' -fill '#F6FFFC' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0014_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0014_fallback_avatar_icon.png
# >> convert -background '#00D1AA' -fill '#F6FFFD' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0015_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0015_fallback_avatar_icon.png
# >> convert -background '#00D1D1' -fill '#F6FFFF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0016_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0016_fallback_avatar_icon.png
# >> convert -background '#00AAD1' -fill '#F6FDFF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0017_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0017_fallback_avatar_icon.png
# >> convert -background '#0083D1' -fill '#F6FCFF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0018_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0018_fallback_avatar_icon.png
# >> convert -background '#005BD1' -fill '#F6FAFF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0019_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0019_fallback_avatar_icon.png
# >> convert -background '#0034D1' -fill '#F6F8FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0020_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0020_fallback_avatar_icon.png
# >> convert -background '#000DD1' -fill '#F6F7FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0021_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0021_fallback_avatar_icon.png
# >> convert -background '#1A00D1' -fill '#F7F6FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0022_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0022_fallback_avatar_icon.png
# >> convert -background '#4100D1' -fill '#F9F6FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0023_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0023_fallback_avatar_icon.png
# >> convert -background '#6800D1' -fill '#FAF6FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0024_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0024_fallback_avatar_icon.png
# >> convert -background '#9000D1' -fill '#FCF6FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0025_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0025_fallback_avatar_icon.png
# >> convert -background '#B700D1' -fill '#FEF6FF' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0026_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0026_fallback_avatar_icon.png
# >> convert -background '#D100C4' -fill '#FFF6FE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0027_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0027_fallback_avatar_icon.png
# >> convert -background '#D1009D' -fill '#FFF6FD' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0028_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0028_fallback_avatar_icon.png
# >> convert -background '#D10076' -fill '#FFF6FB' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0029_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0029_fallback_avatar_icon.png
# >> convert -background '#D1004E' -fill '#FFF6F9' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0030_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0030_fallback_avatar_icon.png
# >> convert -background '#D10027' -fill '#FFF6F8' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/human/0031_fallback_avatar_icon.png
# >> true
# >> ../app/assets/images/human/0031_fallback_avatar_icon.png
