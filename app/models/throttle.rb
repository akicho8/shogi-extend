# 連打防止用
#
#   throttle = Throttle.new(expires_in: 0.1)
#   throttle.reset
#   throttle.call { true }             # => true
#   throttle.call { true }             # => nil
#   sleep(0.1)
#   throttle.call { true }             # => true
#   throttle.call { true }             # => nil
#
# 実行できるブロックよりも、実行できない状態を先に判定したい場合
#
#   unless throttle.call
#     return "あと #{throttle.ttl_sec} 秒待ってから実行してください (あと #{throttle.ttl_ms} ms)"
#   end
#   self.count += 1
#
class Throttle
  attr_reader :key

  def initialize(options = {})
    @options = {
      key: nil,
      expires_in: 3.seconds,
    }.merge(options)
  end

  # 次のように書くのと似ているが、
  #
  #  if allowed?
  #    stop!
  #    yield
  #  end
  #
  # allowed? と stop! の間に割り込まれる場合がある。
  def call(&block)
    if block
      if call
        yield
        return true
      end
      return false
    end

    # nx -> true: すでにあれば書き込まない
    # px -> TTL を ms の整数で指定する
    redis.set(key, true, nx: true, px: (@options[:expires_in] * 1000.0).to_i)
  end

  def key
    @key ||= @options[:key] || SecureRandom.hex
  end

  def allowed?
    !Rails.cache.exist?(key)
  end

  def throttled?
    Rails.cache.exist?(key)
  end

  def stop!
    Rails.cache.write(key, true, expires_in: @options[:expires_in])
  end

  def reset
    Rails.cache.delete(key)
  end

  def ttl_sec
    if ms = ttl_ms
      ms.ceildiv(1000)
    end
  end

  def ttl_ms
    ttl = redis.pttl(key)
    if ttl > 0
      ttl
    end
  end

  def redis
    @redis ||= Rails.cache.redis.with(&:itself)
  end
end
