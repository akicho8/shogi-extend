desc "OGP画像最適化"
task "my:ogp_image_optimize" do
  system "mogrify -resize 1200x630! *.png" if false
  system "pngquant --skip-if-larger --speed 1 --ext .png --force nuxt_side/static/ogp/*.png"
end
