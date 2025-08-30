# ↓これを入れたら起動しなくなった罠

# # config/initializers/maintenance_tasks.rb
# MaintenanceTasks.setup do |config|
#   # CSRF チェックを無効化（開発環境のみ推奨）
#   if Rails.env.development?
#     config.skip_csrf_check = true
#   end
# end
