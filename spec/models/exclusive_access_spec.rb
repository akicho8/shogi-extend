require "rails_helper"

RSpec.describe ExclusiveAccess do
  it "works" do
    process1 = false
    process2 = false

    obj = ExclusiveAccess.new("key1")
    obj.redis.flushdb

    thread = Thread.start do
      obj.call do
        sleep(1.0)                  # API実行には1秒かかる
        process1 = true
      end
    end
    sleep(0.5)                      # 上のスレッドが先に実行されるように少し待つ
    obj.call { process2 = true }    # このブロックは排他制御されるため呼ばれない
    thread.join
    is_asserted_by { process1 == true }
    is_asserted_by { process2 == false }
  end
end
