# API実行超過対策
#
# 仕組み
#
#   require "redis"
#
#   r = Redis.new
#   r.ping                     # => "PONG"
#
#   # 1秒に1回
#   f = -> {
#     wait = (r.get("foo") || 0).to_i
#     next_wait = wait + 1
#     expires_in = next_wait
#     r.setex("foo", expires_in, next_wait)
#     wait
#   }
#
#   r.flushdb                  # => "OK"
#   4.times.collect { f.call } # => [0, 1, 2, 3]
#   4.times.collect { f.call } # => [4, 5, 6, 7]
#   sleep(8)
#   4.times.collect { f.call } # => [0, 1, 2, 3]
#
#   # 1秒に2回
#   f = -> {
#     wait = (r.get("foo") || 0).to_f
#     next_wait = wait + 0.5
#     expires_in = next_wait.ceil
#     r.setex("foo", expires_in, next_wait)
#     wait.truncate
#   }
#
#   r.flushdb                  # => "OK"
#   4.times.collect { f.call } # => [0, 0, 1, 1]
#   4.times.collect { f.call } # => [2, 2, 3, 3]
#   sleep(4)
#   4.times.collect { f.call } # => [0, 0, 1, 1]
#

class ExcessiveMeasure
  def initialize(params = {})
    @params = {
      :key            => SecureRandom.hex, # Rails.cache の key
      :run_per_second => 1,                # 1秒間当たりに実行できる回数
      :expires_in     => 60,               # 何秒間空いたらリセットするか？
    }.merge(params)

    if block_given?
      yield self
    end
  end

  # Example:
  #
  #   obj = ExcessiveMeasure.new(key: "foo", run_per_second: 2)
  #   obj.reset
  #   4.times.collect { obj.wait_value_for_job } # => [0, 0, 1, 1]
  #   4.times.collect { obj.wait_value_for_job } # => [2, 2, 3, 3]
  #   sleep(4)
  #   4.times.collect { obj.wait_value_for_job } # => [0, 0, 1, 1]
  #
  #   excessive_measure = ExcessiveMeasure.new(key: "SlackAgentNotifyJob", run_per_second: 2)
  #   SlackAgentNotifyJob.set(wait: excessive_measure.wait_value_for_job).perform_later(params)
  def wait_value_for_job
    hv = Rails.cache.read(key) || {}
    wait = hv[:next_wait] || 0
    next_wait = wait + 1.fdiv(run_per_second)

    now = Time.current
    if v = hv[:previous_time]
      previous_time = Time.zone.iso8601(v)
    else
      previous_time = now
    end
    spend = now - previous_time
    if spend >= expires_in_max
      next_wait = 0
    end

    hv = { next_wait: next_wait, previous_time: now.iso8601 }
    Rails.cache.write(key, hv, expires_in: expires_in)
    Rails.logger.info { "[ExcessiveMeasure][#{key}][#{run_per_second}] #{hv.inspect} #{wait} #{next_wait} #{wait.truncate}" }
    wait.truncate
  end

  # Example:
  #   obj = ExcessiveMeasure.new
  #   obj.wait_value_for_job # => 0
  #   obj.wait_value_for_job # => 1
  #   obj.reset
  #   obj.wait_value_for_job # => 0
  def reset
    Rails.cache.delete(key)
  end

  private

  def key
    @params[:key]
  end

  def run_per_second
    @params[:run_per_second]
  end

  def expires_in
    @params[:expires_in]
  end
end
