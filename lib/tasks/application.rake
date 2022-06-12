if defined?(RSpec)
  # desc "棋譜変換のテスト(KIFU_EXTRACTOR_OUTPUT=1 で expected を生成)"
  RSpec::Core::RakeTask.new("spec:kifu_extractor") do |t|
    t.pattern = "spec/models/kifu_extractor_spec.rb"
    t.rspec_opts = "-f d"
    # t.rspec_opts = "-f d -t kifu_extractor"
  end
end

desc "なんかしらのエラー画像の生成"
task "my:nankasirano_error_image_generate" do
  system "convert -background '#fff' -fill '#999' -size 1200x630 -gravity center -font /Library/Fonts/Ricty-Regular.ttf -pointsize 80 label:'なんかしらのエラーです\nたぶん反則です' app/assets/images/fallback.png"
end

desc "apple-touch-icon.png を元に favicon.ico の生成"
task "my:favicon_generate" do
  system "convert nuxt_side/static/apple-touch-icon.png -define icon:auto-resize nuxt_side/static/favicon.ico"
  system "ln -sfv ../../../nuxt_side/static/favicon.ico            app/assets/images"
  system "ln -sfv ../../../nuxt_side/static/apple-touch-icon.png   app/assets/images"
  system "ls -al app/assets/images"
end
