set_if_empty :application, Pathname(__dir__).dirname.dirname.dirname.basename.to_s
set_if_empty :branch, ENV["BRANCH"] || `git rev-parse --abbrev-ref HEAD`.strip
set_if_empty :deploy_to, -> { "/var/www/#{fetch(:application)}_#{fetch(:stage)}" }
