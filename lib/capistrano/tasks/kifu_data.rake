################################################################################ kifu_data

# cap staging kifu_data:deploy

after "deploy:updated", "kifu_data:deploy"

namespace :kifu_data do
  desc "kifu_data/* を転送"
  task :deploy do
    run_locally do
      roles(:web).each do |e|
        execute :rsync, %(-avz --delete --exclude=".git" kifu_data #{e.user}@#{e.hostname}:#{release_path})
      end
    end
  end
end
