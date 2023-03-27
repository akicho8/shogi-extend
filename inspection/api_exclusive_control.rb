require File.expand_path('../../config/environment', __FILE__)

Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

process1 = false
process2 = false

key = SecureRandom.hex
obj = ApiExclusiveControl.new(key)
obj.redis.flushdb

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

# >> [ApiExclusiveControl][talk_mp3][1][権利を獲得したのでAPIを実行する]
# >> [ApiExclusiveControl][talk_mp3][2][権利がないためAPI実行完了待ち]
# >> [ApiExclusiveControl][talk_mp3][814ad31dcca4992da98369e95f38b91a][0][none:false]
# >> [ApiExclusiveControl][talk_mp3][814ad31dcca4992da98369e95f38b91a][1][none:false]
# >> [ApiExclusiveControl][talk_mp3][814ad31dcca4992da98369e95f38b91a][2][none:false]
# >> [ApiExclusiveControl][talk_mp3][814ad31dcca4992da98369e95f38b91a][3][none:false]
# >> [ApiExclusiveControl][talk_mp3][814ad31dcca4992da98369e95f38b91a][4][none:true]
