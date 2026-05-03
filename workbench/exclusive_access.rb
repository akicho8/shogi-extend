require File.expand_path('../../config/environment', __FILE__)

Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

process1 = false
process2 = false

key = SecureRandom.hex
obj = ExclusiveAccess.new(key)
obj.redis.call("FLUSHDB")

thread = Thread.start do
  obj.call do
    sleep(1.0)
    process1 = true
  end
end
sleep(0.5)                      # 上のスレッドが先に実行されるように少し待つ
obj.call { process2 = true }    # このブロックは排他制御されるため呼ばれない
thread.join
process1                        # => true
process2                        # => false

# >> [ExclusiveAccess][talk_mp3][1][権利を獲得したのでAPIを実行する]
# >> [ExclusiveAccess][talk_mp3][2][権利がないためAPI実行完了待ち]
# >> [ExclusiveAccess][talk_mp3][14c298f6fbb82f30c4685ccbe3c423b1][0][none:false]
# >> [ExclusiveAccess][talk_mp3][14c298f6fbb82f30c4685ccbe3c423b1][1][none:false]
# >> [ExclusiveAccess][talk_mp3][14c298f6fbb82f30c4685ccbe3c423b1][2][none:false]
# >> [ExclusiveAccess][talk_mp3][14c298f6fbb82f30c4685ccbe3c423b1][3][none:false]
# >> [ExclusiveAccess][talk_mp3][14c298f6fbb82f30c4685ccbe3c423b1][4][none:false]
# >> [ExclusiveAccess][talk_mp3][14c298f6fbb82f30c4685ccbe3c423b1][5][none:true]
