# cap production maintenance:test
# cap production maintenance:enable
# cap production maintenance:disable

# for capistrano-maintenance gem
# cp /usr/local/var/rbenv/versions/2.6.1/lib/ruby/gems/2.6.0/gems/capistrano-maintenance-1.2.1/lib/capistrano/templates/maintenance.html.erb config/
# として雛形をカスタマイズするために移動したパスに合わせている
set :maintenance_template_path, "#{__dir__}/../../../config/maintenance.html.erb"

namespace :maintenance do
  desc "test maintenance mode"
  task :test do
    require 'erb'
    reason = ENV['REASON']
    deadline = ENV['UNTIL']
    base_path = File.expand_path("#{__dir__}/../../../public")
    result = ERB.new(File.read(fetch(:maintenance_template_path)), trim_mode: "<>").result(binding)
    file = "public/system/maintenance.html"
    File.write(file, result)
    `open #{file}`
  end
end
