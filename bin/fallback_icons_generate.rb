#!/usr/bin/env ruby

require "rgb"

[
  {key: :red,     h:   0, },
  {key: :orange,  h:  38, },
  {key: :yellow,  h:  60, },
  {key: :green,   h: 120, },
  {key: :cyan,    h: 180, },
  {key: :blue,    h: 240, },
  {key: :magenta, h: 300, },
].each.with_index do |e, i|
  c = RGB::Color.from_fractions(e[:h] / 360.0, 0.7, 0.7)
  background = c.to_rgb_hex               # => "#E87D7D", "#E8C17D", "#E8E87D", "#7DE87D", "#7DE8E8", "#7D7DE8", "#E87DE8"
  fill = c.lighten_percent(100).to_rgb_hex # => "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF"
  filename = "../app/assets/images/fallback_icons/%04d_fallback_face_icon_#{e[:key]}.png" % i
  p `convert -background '#{background}' -fill '#{fill}' -size 256x256 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 label:"?" #{filename}`
  puts filename
end
# >> ""
# >> ../app/assets/images/fallback_icons/0000_fallback_face_icon_red.png
# >> ""
# >> ../app/assets/images/fallback_icons/0001_fallback_face_icon_orange.png
# >> ""
# >> ../app/assets/images/fallback_icons/0002_fallback_face_icon_yellow.png
# >> ""
# >> ../app/assets/images/fallback_icons/0003_fallback_face_icon_green.png
# >> ""
# >> ../app/assets/images/fallback_icons/0004_fallback_face_icon_cyan.png
# >> ""
# >> ../app/assets/images/fallback_icons/0005_fallback_face_icon_blue.png
# >> ""
# >> ../app/assets/images/fallback_icons/0006_fallback_face_icon_magenta.png
