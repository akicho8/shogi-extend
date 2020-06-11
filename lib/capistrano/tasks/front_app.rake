################################################################################ front_app

# cap staging front_app:upload

after "deploy:updated", "front_app:upload"

namespace :front_app do
  desc "静的エラーページのアップロード"
  task :upload do

    # ビルド
    # Dir.chdir("front_app") { system "BASE_DIR=/system/front_app/ yarn build" }
    Dir.chdir("front_app") { system "yarn run build" }

    on roles(:web) do |host|
      # いったん消さないと2度目で static/dist ディレクトリに転送してしまう
      execute :rm, "-rf", "#{release_path}/public/s"

      # アップロードして
      upload! "front_app/dist", "#{release_path}/public/s", recursive: true

      # 確認
      execute :ls, "-al #{release_path}/public"
    end
  end
end
