################################################################################

require "faraday"
require "memory_record"
require "table_format"

################################################################################

require "zeitwerk"
loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/capistrano/helpers")
loader.setup

################################################################################

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# 本家の隠しタスク cap production console
require "capistrano/console"

require "capistrano/rails/console"

# require "capistrano/rvm"
require "capistrano/rbenv"
# require "capistrano/chruby"
require "capistrano/rails" # bundler + rails/assets + rails/migrations
# require "capistrano/passenger"
require "capistrano/yarn"

require "whenever/capistrano"
require "table_format"
require "capistrano/maintenance"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |e| import e }
