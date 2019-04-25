# /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/whenever-0.10.0/lib/whenever/capistrano/v3/tasks/whenever.rake
# の設定の方が後に呼ばれて有効になってしまうため
# load:defaults のなかにいれている

namespace :load do
  task :defaults do
    set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
    # set :whenever_path,       -> { release_path } # FIXME: whenever (0.10.0) 以下の場合のみ。0.10.0 になっても直ってない。0.11.0 で直った
  end
end
