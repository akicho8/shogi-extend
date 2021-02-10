################################################################################ kifu_data

# cap staging kifu_data:deploy

after "deploy:updated", "kifu_data:deploy"

namespace :kifu_data do
  desc "kifu_data/* を転送"
  task :deploy do
    on roles(:web) do |host|
      execute :rm, "-rf", "#{release_path}/kifu_data"
      upload! "kifu_data", release_path, recursive: true
    end
  end
end
