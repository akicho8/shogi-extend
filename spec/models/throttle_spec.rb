require "rails_helper"

RSpec.describe type: :model do
  it "works" do
    throttle = Throttle.new(expires_in: 0.1)
    throttle.reset
    assert { throttle.call { true } == true  } # 初回は実行できる
    assert { throttle.call { true } == false } # しかし連打状態だと2回目は実行されない
    sleep(0.1)                                 # 指定の時間待つと
    assert { throttle.call { true } == true  } # 再度初回は実行でき
    assert { throttle.call { true } == false } # また連打はできない
  end
end
