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
#     return "あと #{throttle.ttl_sec} 秒待ってから実行しよう (あと #{throttle.ttl_ms} ms)"
#   end
#   self.count += 1
#
class Throttle
  attr_reader :key

  def initialize(options = {})
    @options = {
      :key           => nil,
      :expires_in    => 3.seconds,
      :delayed_again => false, # 連打している限り、延期するか？
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

    if @options[:delayed_again]
      if throttled?
        redis.pexpire(key, expires_in_ms, xx: true)
      end
    end

    stop!
  end

  def key
    @key ||= @options[:key] || SecureRandom.hex
  end

  def allowed?
    !redis.exists?(key)
  end

  def throttled?
    redis.exists?(key)
  end

  def stop!
    # nx -> true: すでにあれば書き込まない
    # px -> TTL を ms の整数で指定する
    # 書き込めたら true で書き込まなかったら false を返す
    redis.set(key, true, nx: true, px: expires_in_ms)
  end

  def reset
    redis.del(key)
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

  def expires_in_ms
    (@options[:expires_in] * 1000.0).to_i
  end

  # test 環境でも使いたいので Rails.cache 経由しない
  def redis
    @redis ||= Redis.new(db: AppConfig[:redis_db_for_rails_cache])
  end
end
