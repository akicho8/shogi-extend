################################################################################ next_side

# cap staging next_side:deploy

# after "deploy:updated", "next_side:deploy"

namespace :next_side do
  desc "Next側のアップロード"
  task :deploy do
    if false
      # next_side/dist を public/app として転送するだけ
      Dir.chdir("next_side") { system "next generate --dotenv .env.#{fetch(:stage)}" }
      on roles(:web) do |host|
        execute :rm, "-rf", "#{release_path}/public/app"
        execute :rm, "-rf", "#{release_path}/public/s"
        upload! "next_side/dist", "#{release_path}/public/app", recursive: true
        execute :ls, "-al #{release_path}/public"
      end
    end

    if true
      # 1. next_side/.next を next_side/.next として転送
      # 2. next_side/static/* も Next が直接配信しているるため転送が必要
      # 3. next_side で yarn
      Dir.chdir("next_side") { system "next build --dotenv .env.#{fetch(:stage)}" }
      on roles(:web) do |host|
        execute :rm, "-rf", "#{release_path}/public/app"
        execute :rm, "-rf", "#{release_path}/public/s"
        execute :rm, "-rf", "#{release_path}/next_side/static"
        execute :rm, "-rf", "#{release_path}/next_side/.next"

        # if ENV["WITH_STATIC"]
        upload! "next_side/static", "#{release_path}/next_side/", recursive: true # static は .next の下に入らずそのまま配信されるため
        # end
        upload! "next_side/.next", "#{release_path}/next_side/", recursive: true

        upload! "next_side/.env.#{fetch(:stage)}", "#{release_path}/next_side/"
        upload! "next_side/static/#{fetch(:stage)}.robots.txt", "#{release_path}/next_side/static/robots.txt"

        within "#{release_path}/next_side" do
          execute :yarn
        end
        execute :ls, "-al #{release_path}/next_side"
      end
    end
  end
end
