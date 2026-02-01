################################################################################ material

# [実行] cap staging material:deploy
after "deploy:updated", "material:deploy"

namespace :material do
  desc "nuxt_side/static/material を public/system の下に転送"
  task :deploy do
    run_locally do
      roles(:web).each do |e|
        src_dir = "nuxt_side/static/material"
        dst_dir = "#{shared_path}/public/system"
        execute :rsync, %(-azh --delete --exclude=".git" #{src_dir} #{e.user}@#{e.hostname}:#{dst_dir})
      end
    end
    on roles(:web) do
      execute "ls -al #{shared_path}/public/system"
    end
  end
end
