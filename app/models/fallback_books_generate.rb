class FallbackBooksGenerate
  def call
    require "rgb"

    primary_color = "#00d1b2"
    # primary_color = "#7957d5"
    count = 8
    width = 1200
    height = 630
    output_dir = "../app/assets/images/book"
    point_size = 160
    label = "?"

    base_color = RGB::Color.from_rgb_hex(primary_color)

    count.times do |i|
      c = RGB::Color.from_fractions((1.0 / count) * i, base_color.s, base_color.l)
      background = c.to_rgb_hex               # => "#D10000", "#D19D00", "#69D100", "#00D134", "#00D1D1", "#0034D1", "#6800D1", "#D1009D"
      fill = c.lighten_percent(97).to_rgb_hex # => "#FFF6F6", "#FFFDF6", "#FAFFF6", "#F6FFF8", "#F6FFFF", "#F6F8FF", "#FAF6FF", "#FFF6FD"
      filepath = "#{output_dir}/%04d_fallback_book_icon.png" % i
      command = "convert -background '#{background}' -fill '#{fill}' -size #{width}x#{height} -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize #{point_size} #{filepath}"
      puts command
      puts system(command)
      puts filepath
    end
    # >> convert -background '#D10000' -fill '#FFF6F6' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0000_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0000_fallback_book_icon.png
    # >> convert -background '#D19D00' -fill '#FFFDF6' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0001_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0001_fallback_book_icon.png
    # >> convert -background '#69D100' -fill '#FAFFF6' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0002_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0002_fallback_book_icon.png
    # >> convert -background '#00D134' -fill '#F6FFF8' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0003_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0003_fallback_book_icon.png
    # >> convert -background '#00D1D1' -fill '#F6FFFF' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0004_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0004_fallback_book_icon.png
    # >> convert -background '#0034D1' -fill '#F6F8FF' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0005_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0005_fallback_book_icon.png
    # >> convert -background '#6800D1' -fill '#FAF6FF' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0006_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0006_fallback_book_icon.png
    # >> convert -background '#D1009D' -fill '#FFF6FD' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Bold.ttf -pointsize 160 ../app/assets/images/book/0007_fallback_book_icon.png
    # >> false
    # >> ../app/assets/images/book/0007_fallback_book_icon.png
  end
end
