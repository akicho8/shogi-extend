# -*- coding: utf-8; compile-command: "scp production.rb s:/var/www/shogi_web_production/current/config/puma; ssh s '(cd /var/www/shogi_web_production/current && bin/rails restart)' && ssh s 'sudo nginx -t && sudo systemctl restart nginx'" -*-

pp({
    "whoami"    => `whoami`.strip,
    "Dir.pwd"   => Dir.pwd,
    "__FILE__"  => __FILE__,
    "RAILS_ENV" => ENV["RAILS_ENV"],
    "PORT"      => ENV["PORT"],
    "PIDFILE"   => ENV["PIDFILE"],
  })

# bind "unix://#{Rails.root}/tmp/sockets/puma.sock"
bind "unix:///var/www/shogi_web_production/shared/tmp/sockets/puma.sock"

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.

# port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

state_path "tmp/pids/puma.state"

# workers (=プロセス数) はCPUコア数〜1.5倍を基本とする
# https://qiita.com/snaka/items/029889198def72e84209#puma-%E3%81%AE-worker-%E6%95%B0%E3%81%AE%E7%9B%AE%E5%AE%89

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
workers ENV.fetch("WEB_CONCURRENCY") { 1 }

# https://techracho.bpsinc.jp/hachi8833/2017_11_13/47696
# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# ▼プロセスを確認しやすくするためのタグ
#
#   $ ps auxwww | grep shogi
#   root      1834  0.7  5.5 214664 27596 ?  Ssl  22:26   0:00 puma 4.3.3 (unix:///var/www/shogi_web_production/shared/tmp/sockets/puma.sock) [shogi_web_production]
#   root      1988  1.7 18.6 847228 93028 ?  Sl   22:26   0:01 puma: cluster worker 0: 1834 [shogi_web_production]
#   root      1989  1.6 17.9 837452 89312 ?  Sl   22:26   0:01 puma: cluster worker 1: 1834 [shogi_web_production]
#
tag "shogi_web_production"

# # app do |env|
# #   puts env
# #   body = 'Hello, World!'
# #   [200, { 'Content-Type' => 'text/plain', 'Content-Length' => body.length.to_s }, [body]]
# # end
#
# debug

# わかりにくいが quiet false にするとリクエストを確認できるようにする
# ドキュメントにはデフォルト false とあるが、実際は quiet true がデフォルトになっている
# ログは journalctl -f -u puma で見れる
quiet false
