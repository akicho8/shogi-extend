# # # Default value for :linked_files is []
# # # append :linked_files, "config/database.yml", "config/secrets.yml"
# # append :linked_files, "config/master.key"
# # 
# # # Default value for linked_dirs is []
# # append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system"
# 
# append :linked_dirs, "public/tmp"
# 
# namespace :maintenance do
#   desc 'start maintenance'
#   task :on do
#     on roles(:web) do
#       target_dir = "#{shared_path}/public/tmp"
#       target_path = "#{target_dir}/maintenance.html"
#       source_path = "#{release_path}/public/maintenance.html"
#       execute :mkdir, '-p', target_dir
#       execute :cp, '-f', source_path, target_path
#     end
#   end
# 
#   desc 'stop maintenance'
#   task :off do
#     on roles(:web) do
#       target = "#{shared_path}/public/tmp/maintenance.html"
#       if test "[ -f #{target} ]"
#         execute :rm, target
#       end
#     end
#   end
# end
