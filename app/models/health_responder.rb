# /health に応答させるためのミニマムRackアプリ
#
# 使用例:
#
#   routes.rb:
#     get "health"   => HealthResponder
#
#   $ curl http://localhost:3000/health   #=> I'm fine
#

HealthResponder = Proc.new do |env|
  begin
    ActiveRecord::Migrator.current_version
    key = SecureRandom.hex
    val = SecureRandom.hex
    Rails.cache.write(key, val, expires_in: 3.second)
    if Rails.cache.read(key) != val
      raise "Redis is not running"
    end
    Rails.cache.delete(key)
    [200, {"Content-Type" => "text/plain"}, ["I'm fine\n"]]
  rescue => e
    [500, {"Content-Type" => "text/plain"}, ["#{e.message} (#{e.class.name})\n"]]
  end
end
