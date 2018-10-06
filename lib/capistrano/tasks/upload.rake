################################################################################ deploy:upload

desc "cap production deploy:upload FILES=config/schedule.rb"
namespace :deploy do
  task :upload do
    on roles :all do |host|
      files = (ENV["FILES"] || "").split(",").collect { |f| Dir[f.strip] }.flat_map { |e| Pathname(e) }
      rows = files.collect do |file|
        server_file = release_path.join(file)
        upload! file.open, server_file.to_s
        {"Host" => host.hostname, "転送元" => file, "転送先" => server_file}
      end
      tp rows
    end
  end
end
