################################################################################ error_page

# cap production error_page:upload ローカルのテンプレートをアップロード

after "deploy:updated", "error_page:upload"

namespace :error_page do
  desc "静的エラーページのアップロード"
  task :upload do
    Dir.chdir("static_app") { system "BASE_DIR=/system/static/ yarn build" }
    on roles(:web) do |host|
      # いったん消さないと2度目で static/dist ディレクトリに転送してしまう
      execute :rm, "-rf", "#{shared_path}/public/system/static"
      upload! "static_app/dist", "#{shared_path}/public/system/static", recursive: true
      ["404", "422", "500"].each do |code|
        if false
          # 本当はこうしたかったが、
          # シンボリックリンクもハードリンクも動作しない
          execute :ln, "-sf", "#{shared_path}/public/system/static/page#{code}.html", "#{release_path}/public/#{code}.html"
        else
          # ダサいが meta refresh で遷移させる
          # なぜ /public/404.html のような形で置く理由は Rails が読んでいるから
          upload! StringIO.new(%(<html><head><meta http-equiv="refresh" content="0;url=/system/static/page#{code}/"></head></html>)), "#{release_path}/public/#{code}.html"
        end
      end
      execute :ls, "-al #{release_path}/public/"
      execute :ls, "-al #{shared_path}/public/system/"
      execute :ls, "-al #{shared_path}/public/system/static"
    end
  end
end
