# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "shogi_web"

set :repo_url, -> { "git@github.com:akicho8/#{fetch(:application)}.git" }

set :git_shallow_clone, 1

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# if ENV["USE_NEW_DOMAIN"]
#   set :USE_NEW_DOMAIN, "true"
#   set :ws_port, 28082
# else
#   set :USE_NEW_DOMAIN, nil
#   set :ws_port, 28081
# end

set :default_env, -> { {"DISABLE_DATABASE_ENVIRONMENT_CHECK" => "1", rails_env: fetch(:rails_env), } }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 1

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

################################################################################ yarn

# set :yarn_target_path, -> { release_path.join('subdir') } # default not set
# set :yarn_flags, '--production --silent --no-progress'    # default
# set :yarn_roles, :all                                     # default
# set :yarn_env_variables, {}                               # default

################################################################################ その他

# set :print_config_variables, true # デプロイ前に設定した変数値を確認

# set :my_rails_relative_url_root, "/#{fetch(:application).underscore.dasherize}"
# if ENV["USE_NEW_DOMAIN"]
# else
#   set :my_rails_relative_url_root, "/shogi"
# end
