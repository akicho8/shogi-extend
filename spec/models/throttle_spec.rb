require "rails_helper"

RSpec.describe type: :model do
  it "一定時間立つと許可" do
    throttle = Throttle.new(expires_in: 0.2, delayed_again: false)
    throttle.reset
    assert { throttle.call == true }
    sleep(0.1)
    assert { throttle.call == false }
    sleep(0.1)
    assert { throttle.call == true }
  end

  it "連打している限り許さん" do
    throttle = Throttle.new(expires_in: 0.2, delayed_again: true)
    throttle.reset
    assert { throttle.call == true }
    sleep(0.1)
    assert { throttle.call == false }
    sleep(0.1)
    assert { throttle.call == false }
  end
end
