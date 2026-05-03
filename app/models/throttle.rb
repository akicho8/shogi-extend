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
        # PEXPIRE key milliseconds XX
        # XX: キーがすでに存在する場合のみ有効期限を設定する
        redis.call("PEXPIRE", key, expires_in_ms, "XX")
      end
    end

    stop!
  end

  def key
    @key ||= @options[:key] || SecureRandom.hex
  end

  def allowed?
    !throttled?
  end

  def throttled?
    # EXISTS は存在するキーの数を返すので、0より大きいかどうかで判定
    redis.call("EXISTS", key) > 0
  end

  def stop!
    # RedisClient の set オプション指定
    # nx: true -> "NX"
    # px: ms   -> "PX", ms
    # 成功すると "OK"、NX条件により書き込めなかったら nil が返る
    redis.call("SET", key, "true", "NX", "PX", expires_in_ms) == "OK"
  end

  def reset
    redis.call("DEL", key)
  end

  def ttl_sec
    if ms = ttl_ms
      ms.ceildiv(1000)
    end
  end

  def ttl_ms
    # PTTL は残り時間を ms で返す。キーがない場合は -2、期限がない場合は -1
    ttl = redis.call("PTTL", key)
    if ttl > 0
      ttl
    end
  end

  def expires_in_ms
    (@options[:expires_in] * 1000.0).to_i
  end

  # test 環境でも使いたいので Rails.cache 経由しない
  def redis
    @redis ||= RedisPool.client(AppConfig[:redis_db_for_rails_cache])
  end
end
