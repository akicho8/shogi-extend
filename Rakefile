# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

task "p:d" do
  system %(git push; OPEN=false cap production deploy)
end

task :t => :test_all
desc "[t] test_all"
task :test_all do
  system <<~EOT

  k -x "Google Chrome"
  k -x "chromedriver"
  k -x "shogi-extend"

  tmux kill-window -t start
  tmux new-window -n start
  tmux send-keys -t start "start" C-m

  tmux kill-window -t test
  tmux new-window -n test
  tmux send-keys -t test "sleep 180; rake; rspec --only-failures; sleep 120; rspec --only-failures; sleep 120; rspec --only-failures" C-m

  EOT
end
