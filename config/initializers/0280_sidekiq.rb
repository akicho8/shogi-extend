# run sidekiq worker
#  $ sidekiq -C config/sidekiq.yml
#
# sidekiq web
#   rails server (development)
#     $ rails s
#     => http://localhost:3000/admin/sidekiq
#
# sidekiq status
#   job_id = MyJob.perform_async(*args)
#   # :queued, :working, :complete or :failed , nil after expiry (default 30 minutes)
#   status = Sidekiq::Status::status(job_id)
#   Sidekiq::Status::queued?   job_id
#   Sidekiq::Status::working?  job_id
#   Sidekiq::Status::complete? job_id
#   Sidekiq::Status::failed?   job_id
#
# sidekiq-failures
#   Sidekiq::Failures.count
#   Sidekiq::Failures.reset_failures
#
# whenever sample
#   every 1.day, at: '12:01 pm' do
#     runner 'Warehouse::FtpPull.perform_async'
#   end
#
# require 'sidekiq-status'

redis_options = {
  :url       => 'redis://localhost:6379/0',
  :namespace => "shogi_web_#{Rails.env}_sidekiq",
}

# default_worker_options = {
#   'backtrace' => true,
# }

################################################################################
# Sidekiq.configure_client と configure_server の両方に設定すること！
################################################################################

# 表側 (WEBの方)
Sidekiq.configure_client do |config|
  config.redis = redis_options
  # config.default_worker_options = default_worker_options

  # #== sidekiq-status setting
  # config.client_middleware do |chain|
  #   chain.add Sidekiq::Status::ClientMiddleware
  # end
end

# 裏側 (バックグラウンドで動いている側)
Sidekiq.configure_server do |config|
  config.redis = redis_options
  # config.default_worker_options = default_worker_options # これ重要

  #== sidekiq-failures setting
  # 失敗jobを保持する最大数、容易にunlimitにするのは危ない
  # config.failures_max_count    = 1000  # default: 1000, false(unlimit)
  # config.failures_default_mode = :all  # default :all, :exhausted or :off.

  # #== sidekiq-status setting
  # config.server_middleware do |chain|
  #   # expiration == ステータス情報を保持しておく時間 (default: 30.minutes)
  #   chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes
  # end
  # config.client_middleware do |chain|
  #   chain.add Sidekiq::Status::ClientMiddleware
  # end
end

# 出力ログを日本標準時にする
# http://qiita.com/h_hys/items/250dce4d972295937318
# class JSTTimestampFormatter < Sidekiq::Logging::WithoutTimestamp
#   def call(severity, time, program_name, message)
#     "#{time.localtime.iso8601(3)} #{super}"
#   end
# end
# Sidekiq::Logging.logger.formatter = JSTTimestampFormatter.new

# if Rails.env.test?
#   require 'sidekiq/testing/inline'
# end
