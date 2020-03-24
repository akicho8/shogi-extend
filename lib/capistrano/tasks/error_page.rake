################################################################################ error_page

# cap production error_page:upload ローカルのテンプレートをアップロード

after "deploy:updated", "error_page:upload"

namespace :error_page do
  desc "静的エラーページのアップロード"
  task :upload do

    # ビルド
    Dir.chdir("error_page_app") { system "BASE_DIR=/system/error_page/ yarn build" }

    on roles(:web) do |host|
      # いったん消さないと2度目で static/dist ディレクトリに転送してしまう
      execute :rm, "-rf", "#{shared_path}/public/system/error_page"

      # アップロードして
      upload! "error_page_app/dist", "#{shared_path}/public/system/error_page", recursive: true

      # 既存の public/404.html からリダイレクトするようにする

      ["404", "422", "500"].each do |code|
        if false
          # 本当はこうしたかったが、
          # シンボリックリンクもハードリンクも動作しない
          execute :ln, "-sf", "#{shared_path}/public/system/error_page/page#{code}.html", "#{release_path}/public/#{code}.html"
        else
          # ダサいが meta refresh で遷移させる
          # なぜ /public/404.html のような形で置く理由は Rails が決め打ちで読み込んでいるから
          upload! StringIO.new(%(<html><head><meta http-equiv="refresh" content="0;url=/system/error_page/page#{code}/"></head></html>)), "#{release_path}/public/#{code}.html"
        end
      end

      # 確認
      execute :ls, "-al #{release_path}/public/"
      execute :ls, "-al #{shared_path}/public/system/"
      execute :ls, "-al #{shared_path}/public/system/error_page"
    end
  end
end
