#!/usr/bin/env ruby

require "rgb"

count = 32
size = 256
primary_color = RGB::Color.from_rgb_hex("#7957d5")

count.times do |i|
  c = RGB::Color.from_fractions((1.0 / count) * i, primary_color.s, primary_color.l)
  background = c.to_rgb_hex               # => "#D55757", "#D58657", "#D5B657", "#C5D557", "#96D557", "#67D557", "#57D577", "#57D5A6", "#57D5D5", "#57A6D5", "#5776D5", "#6757D5", "#9657D5", "#C557D5", "#D557B5", "#D55786"
  fill = c.lighten_percent(97).to_rgb_hex # => "#FEFAFA", "#FEFBFA", "#FEFDFA", "#FDFEFA", "#FCFEFA", "#FAFEFA", "#FAFEFB", "#FAFEFC", "#FAFEFE", "#FAFCFE", "#FAFBFE", "#FAFAFE", "#FCFAFE", "#FDFAFE", "#FEFAFD", "#FEFAFB"
  filepath = "../app/assets/images/fallback_icons/%04d_fallback_face_icon.png" % i
  command = "convert -background '#{background}' -fill '#{fill}' -size #{size}x#{size} -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' #{filepath}"
  puts command
  puts system(command)
  puts filepath
end
# >> convert -background '#D55757' -fill '#FEFAFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0000_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0000_fallback_face_icon.png
# >> convert -background '#D58657' -fill '#FEFBFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0001_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0001_fallback_face_icon.png
# >> convert -background '#D5B657' -fill '#FEFDFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0002_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0002_fallback_face_icon.png
# >> convert -background '#C5D557' -fill '#FDFEFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0003_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0003_fallback_face_icon.png
# >> convert -background '#96D557' -fill '#FCFEFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0004_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0004_fallback_face_icon.png
# >> convert -background '#67D557' -fill '#FAFEFA' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0005_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0005_fallback_face_icon.png
# >> convert -background '#57D577' -fill '#FAFEFB' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0006_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0006_fallback_face_icon.png
# >> convert -background '#57D5A6' -fill '#FAFEFC' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0007_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0007_fallback_face_icon.png
# >> convert -background '#57D5D5' -fill '#FAFEFE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0008_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0008_fallback_face_icon.png
# >> convert -background '#57A6D5' -fill '#FAFCFE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0009_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0009_fallback_face_icon.png
# >> convert -background '#5776D5' -fill '#FAFBFE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0010_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0010_fallback_face_icon.png
# >> convert -background '#6757D5' -fill '#FAFAFE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0011_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0011_fallback_face_icon.png
# >> convert -background '#9657D5' -fill '#FCFAFE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0012_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0012_fallback_face_icon.png
# >> convert -background '#C557D5' -fill '#FDFAFE' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0013_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0013_fallback_face_icon.png
# >> convert -background '#D557B5' -fill '#FEFAFD' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0014_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0014_fallback_face_icon.png
# >> convert -background '#D55786' -fill '#FEFAFB' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:'?' ../app/assets/images/fallback_icons/0015_fallback_face_icon.png
# >> true
# >> ../app/assets/images/fallback_icons/0015_fallback_face_icon.png
