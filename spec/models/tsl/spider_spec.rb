require "rails_helper"

RSpec.describe Tsl::Spider, type: :model do
  let :spider do
    Tsl::Spider.new(generation: 66)
  end

  it "works" do
    assert { spider.call.count == 30 }
    assert { spider.call.first == { result_key: "none", start_pos: 1, name: "古賀悠聖", parent: "中田功", age: 18, win: 6, lose: 12, ox: "oxxoxxxoxxxxooxxxo" } }
  end
end
