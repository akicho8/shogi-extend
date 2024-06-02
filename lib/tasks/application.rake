require 'git-version-bump/rake-tasks'

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

desc "本番環境の直近のログを取得する"
task "production:log:download" do
  system "cap production rails:log:download"
  system "scp i:/var/log/nginx/access.log log/production-nginx.log"
end
