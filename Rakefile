# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task "p:d" do
  system %(git push; OPEN=false cap production deploy)
end

# task :t => :test_all
desc "test_all"
task :test_all do
  system <<~EOT

  # k -x "Google Chrome"
  # k -x "chromedriver"
  # k -x "shogi-extend"

  tmux kill-window -t start
  tmux new-window -n start
  tmux send-keys -t start "start" C-m

  tmux kill-window -t test
  tmux new-window -n test
  tmux send-keys -t test "sleep 180; rake; rspec --only-failures; sleep 120; rspec --only-failures; sleep 120; rspec --only-failures" C-m

  EOT
end

namespace :spec do
  desc "core (--fail-fast)"
  RSpec::Core::RakeTask.new(:core) do |t|
    t.pattern = "spec/models/**/*_spec.rb"
    t.rspec_opts = "-f p --fail-fast"
  end

  desc "corec (--fail-fast --only-failures)"
  RSpec::Core::RakeTask.new(:corec) do |t|
    t.pattern = "spec/models/**/*_spec.rb"
    t.rspec_opts = "-f p --fail-fast --only-failures"
  end
end

# require "rspec/core/rake_task"
#
# desc "すべてのテスト"
# RSpec::Core::RakeTask.new(:test) do |t|
# end
# desc "alias to test"
# task :default => :test
#
# desc "alias to test:core"
# task :c => "test:core"
#
# namespace :test do
#   desc "重要なところだけのテスト"
#   RSpec::Core::RakeTask.new(:core) do |t|
#     # t.exclude_pattern = "spec/**/{animation,image}*_spec.rb"
#     # t.rspec_opts = "-f d -t ~animation --fail-fast"
#     t.rspec_opts = "-f d  -t ~screen_image -t ~animation -t ~tactic -t ~transform"
#   end
#
#   desc "戦法判定"
#   RSpec::Core::RakeTask.new(:tactic) do |t|
#     t.rspec_opts = "-f d --fail-fast -t tactic"
#   end
#
#   desc "棋譜変換のテスト(TRANSFORM_OUTPUT=1 で expected を生成)"
#   RSpec::Core::RakeTask.new(:transform) do |t|
#     t.rspec_opts = "-f d -t transform"
#   end
#
#   desc "画像変換のテスト"
#   RSpec::Core::RakeTask.new(:screen_image) do |t|
#     # t.pattern = "spec/**/{screen_image,image}*_spec.rb"
#     t.rspec_opts = "-f d --fail-fast -t screen_image"
#   end
#
#   desc "動画変換のテスト"
#   RSpec::Core::RakeTask.new(:animation) do |t|
#     # t.pattern = "spec/**/{animation,image}*_spec.rb"
#     t.rspec_opts = "-f d --fail-fast -t animation"
#   end
# end
