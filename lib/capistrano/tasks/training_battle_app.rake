################################################################################ training_battle_app

# cap staging training_battle_app:upload

after "deploy:updated", "training_battle_app:upload"

namespace :training_battle_app do
  desc "静的エラーページのアップロード"
  task :upload do

    # ビルド
    # Dir.chdir("training_battle_app") { system "BASE_DIR=/system/training_battle_app/ yarn build" }
    Dir.chdir("training_battle_app") { system "yarn run build" }

    on roles(:web) do |host|
      # いったん消さないと2度目で static/dist ディレクトリに転送してしまう
      execute :rm, "-rf", "#{release_path}/public/tb2"

      # アップロードして
      upload! "training_battle_app/dist", "#{release_path}/public/tb2", recursive: true

      # 確認
      execute :ls, "-al #{release_path}/public"
    end
  end
end
