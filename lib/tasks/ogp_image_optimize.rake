desc "OGP画像最適化"
task "my:ogp_image_optimize" do
  system "mogrify -resize 1200x630! *.png" if false
  system "fd -g '*.png' nuxt_side/static/ogp --exec pngquant --skip-if-larger --speed 1 --ext .png --force {}"
end
