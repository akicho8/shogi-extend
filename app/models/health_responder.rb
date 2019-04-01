# -*- coding: utf-8 -*-
#
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
      raise "Redisが起動していません"
    end
    Rails.cache.clear(key)

    [200, {"Content-Type" => "text/plain"}, ["I'm fine."]]
  rescue => e
    [500, {"Content-Type" => "text/plain"}, ["Something wrong. #{e.message}"]]
  end
end
