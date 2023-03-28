# ▼使い方
#
#   Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
#
#   process1 = false
#   process2 = false
#
#   key = SecureRandom.hex
#   obj = ExclusiveAccess.new(key)
#   obj.redis.flushdb
#
#   thread = Thread.start do
#     obj.call do
#       sleep(1.0)
#       process1 = true
#     end
#   end
#   sleep(0.5)                      # 上のスレッドが先に実行されるように少し待つ
#   obj.call { process2 = true }    # このブロックは排他制御されるため呼ばれない
#   thread.join
#   process1                        # => true
#   process2                        # => false
#
#   # >> [ExclusiveAccess][talk_mp3][1][権利を獲得したのでAPIを実行する]
#   # >> [ExclusiveAccess][talk_mp3][2][権利がないためAPI実行完了待ち]
#   # >> [ExclusiveAccess][talk_mp3][814ad31dcca4992da98369e95f38b91a][0][none:false]
#   # >> [ExclusiveAccess][talk_mp3][814ad31dcca4992da98369e95f38b91a][1][none:false]
#   # >> [ExclusiveAccess][talk_mp3][814ad31dcca4992da98369e95f38b91a][2][none:false]
#   # >> [ExclusiveAccess][talk_mp3][814ad31dcca4992da98369e95f38b91a][3][none:false]
#   # >> [ExclusiveAccess][talk_mp3][814ad31dcca4992da98369e95f38b91a][4][none:true]
#
class ExclusiveAccess
  class TimeoutError < Timeout::Error; end

  def initialize(key, options = {})
    @key = key
    @options = {
      :interval   => 0.1,
      :expires_in => 3,         # Aws Polly のほとんどは1秒以内にレスポンスがある
    }.merge(options)

    unless @options[:expires_in].kind_of? Integer
      raise ArgumentError
    end
  end

  def call(&block)
    count = count_next
    if count == 1
      Rails.logger.debug { "[ExclusiveAccess][talk_mp3][#{count}][権利を獲得したのでAPIを実行する]" }
      api_call(&block)
    else
      Rails.logger.debug { "[ExclusiveAccess][talk_mp3][#{count}][権利がないためAPI実行完了待ち]" }
      wait_until_currently_running_process_complete
    end
  end

  def redis
    @redis ||= Redis.new(db: AppConfig[:redis_db_for_exclusive_access])
  end

  private

  attr_reader :key

  # すでに動いている処理が終了するまで待つ
  def wait_until_currently_running_process_complete
    timeout = true
    loop_count.times do |i|
      v = process_none?
      Rails.logger.debug { "[ExclusiveAccess][talk_mp3][#{key}][#{i}][none:#{v}]" }
      if v
        timeout = false
        break
      end
      sleep(interval)
    end
    if timeout
      raise TimeoutError, "key: #{key}"
    end
  end

  def api_call(&block)
    # api_start
    yield
    api_done
  end

  # def api_start
  #   redis.setex(key, @options[:timeout], "true")
  # end

  def api_done
    clear
  end

  def clear
    redis.del(key)
  end

  def process_now?
    redis.exists?(key)
  end

  def process_none?
    !process_now?
  end

  def loop_count
    expires_in.fdiv(interval).ceil
  end

  # 1 が返ってきたら最初にボタンを叩いたプロセスだとわかる
  # 一回の処理で排他制御すること
  # キーがあるかどうかの確認とキーの作成の間を設けてはいけない
  def count_next
    redis.multi { |e|
      e.incr(key)
      e.expire(key, expires_in)
    }.first
  end

  def expires_in
    @options.fetch(:expires_in)
  end

  def interval
    @options.fetch(:interval)
  end
end
