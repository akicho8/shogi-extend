set_if_empty :application, Pathname(__dir__).dirname.dirname.dirname.basename.to_s
set_if_empty :branch, ENV["BRANCH"] || `git rev-parse --abbrev-ref HEAD`.strip
set_if_empty :deploy_name, fetch(:application) # ← 自分用に追加
set_if_empty :deploy_to, -> { "/var/www/#{fetch(:deploy_name)}_#{fetch(:stage)}" }
