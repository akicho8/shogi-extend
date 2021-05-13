################################################################################ front_app

# cap staging front_app:deploy

after "deploy:updated", "front_app:deploy"

namespace :front_app do
  desc "Nuxt側のアップロード"
  task :deploy do
    if false
      # front_app/dist を public/app として転送するだけ
      Dir.chdir("front_app") { system "nuxt generate --dotenv .env.#{fetch(:stage)}" }
      on roles(:web) do |host|
        execute :rm, "-rf", "#{release_path}/public/app"
        execute :rm, "-rf", "#{release_path}/public/s"
        upload! "front_app/dist", "#{release_path}/public/app", recursive: true
        execute :ls, "-al #{release_path}/public"
      end
    end

    if true
      # 1. front_app/.nuxt を front_app/.nuxt として転送
      # 2. front_app/static/* も Nuxt が直接配信しているるため転送が必要
      # 3. front_app で yarn
      Dir.chdir("front_app") { system "nuxt build --dotenv .env.#{fetch(:stage)}" }
      on roles(:web) do |host|
        execute :rm, "-rf", "#{release_path}/public/app"
        execute :rm, "-rf", "#{release_path}/public/s"
        execute :rm, "-rf", "#{release_path}/front_app/static"
        execute :rm, "-rf", "#{release_path}/front_app/.nuxts"

        upload! "front_app/static", "#{release_path}/front_app/", recursive: true # static は .nuxt の下に入らずそのまま配信されるため
        upload! "front_app/.nuxt", "#{release_path}/front_app/", recursive: true

        upload! "front_app/.env.#{fetch(:stage)}", "#{release_path}/front_app/"
        upload! "front_app/static/#{fetch(:stage)}.robots.txt", "#{release_path}/front_app/static/robots.txt"

        within "#{release_path}/front_app" do
          execute :yarn
        end
        execute :ls, "-al #{release_path}/front_app"
      end
    end
  end
end
