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
        # execute :pnpm, "--version"
        execute :npm, "--version"
        execute :which, "npx"
      end
    end
  end

  # cap staging nuxt_side:deploy
  # cap production nuxt_side:deploy
  desc "Nuxt側のデプロイ"
  task :deploy => [:npm_install, :build_upload, :static_upload]

  # cap staging nuxt_side:npm_install
  # cap production nuxt_side:npm_install
  desc "npm install を実行する"
  task :npm_install do
    if dry_run?
    else
      # 先に確認する
      on roles(:web) do |host|
        within "#{release_path}/nuxt_side" do
          execute :npm, "install"
        end
        execute :ls, "-al #{release_path}/nuxt_side"
      end
    end
  end

  # cap staging nuxt_side:build_upload
  # cap production nuxt_side:build_upload
  desc "ローカルでビルドしたのを転送する"
  task :build_upload do
    if dry_run?
    else
      run_locally do
        within "nuxt_side" do
          execute :nuxt, "build --dotenv .env.#{fetch(:stage)}"
        end
      end
      on roles(:web) do |e|
        run_locally do
          within "nuxt_side" do
            execute :rsync, %(-azh .nuxt #{e.user}@#{e.hostname}:#{release_path}/nuxt_side/)
          end
        end
        upload! "nuxt_side/.env.#{fetch(:stage)}", "#{release_path}/nuxt_side/"
        upload! "nuxt_side/static/#{fetch(:stage)}.robots.txt", "#{release_path}/nuxt_side/static/robots.txt"
      end
    end
  end

  # cap staging nuxt_side:static_upload
  # cap production nuxt_side:static_upload
  desc "static 以下をコピーする"
  task :static_upload do
    if dry_run?
    else
      on roles(:web) do |e|
        run_locally do
          within "nuxt_side" do
            execute :rsync, %(-azh static #{e.user}@#{e.hostname}:#{release_path}/nuxt_side/)
          end
        end
      end
    end
  end
end
