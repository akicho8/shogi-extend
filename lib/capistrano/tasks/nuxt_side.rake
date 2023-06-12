################################################################################ nuxt_side

after "deploy:updated", "nuxt_side:deploy"

namespace :nuxt_side do
  # cap staging nuxt_side:doctor
  desc "環境確認"
  task :doctor do
    on roles(:web) do |host|
      within "#{release_path}/nuxt_side" do
        execute :pwd
        execute :env, "| grep ENV"
        execute :env, "| grep PATH"
        execute :node, "-v"
        execute :nodenv, "versions"
      end
    end
  end

  # cap staging nuxt_side:deploy
  desc "Nuxt側のアップロード"
  task :deploy do
    if false
      # nuxt_side/dist を public/app として転送するだけ
      Dir.chdir("nuxt_side") { system "nuxt generate --dotenv .env.#{fetch(:stage)}" }
      on roles(:web) do |host|
        execute :rm, "-rf", "#{release_path}/public/app"
        execute :rm, "-rf", "#{release_path}/public/s"
        upload! "nuxt_side/dist", "#{release_path}/public/app", recursive: true
        execute :ls, "-al #{release_path}/public"
      end
    end

    if true
      # 1. nuxt_side/.nuxt を nuxt_side/.nuxt として転送
      # 2. nuxt_side/static/* も Nuxt が直接配信しているるため転送が必要
      # 3. nuxt_side で npm install
      Dir.chdir("nuxt_side") { system "nuxt build --dotenv .env.#{fetch(:stage)}" }
      on roles(:web) do |host|
        execute :rm, "-rf", "#{release_path}/public/app"
        execute :rm, "-rf", "#{release_path}/public/s"
        execute :rm, "-rf", "#{release_path}/nuxt_side/static"
        execute :rm, "-rf", "#{release_path}/nuxt_side/.nuxt"

        # if ENV["WITH_STATIC"]
        upload! "nuxt_side/static", "#{release_path}/nuxt_side/", recursive: true # static は .nuxt の下に入らずそのまま配信されるため
        # end
        upload! "nuxt_side/.nuxt", "#{release_path}/nuxt_side/", recursive: true

        upload! "nuxt_side/.env.#{fetch(:stage)}", "#{release_path}/nuxt_side/"
        upload! "nuxt_side/static/#{fetch(:stage)}.robots.txt", "#{release_path}/nuxt_side/static/robots.txt"

        within "#{release_path}/nuxt_side" do
          execute :pnpm, "install"
        end
        execute :ls, "-al #{release_path}/nuxt_side"
      end
    end
  end
end
