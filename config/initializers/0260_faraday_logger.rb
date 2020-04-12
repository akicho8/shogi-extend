ActiveSupport::Notifications.subscribe("request.faraday") do |name, starts, ends, _, env|
  url = env[:url]
  http_method = env[:method].to_s.upcase
  duration = "%.3f" % (ends - starts)
  time = Time.current.strftime("%F %T")
  Rails.logger.info %([faraday] #{time} #{env[:status]} #{duration} #{http_method} "#{url}")
end
