require "rails_helper"

RSpec.describe ShareBoard::MessageHistory do
  it "works" do
    object = ShareBoard::MessageHistory.new(size: 2, expires_in: 1)
    object.clear_all
    object.push("a")
    object.push("b")
    object.push("c")
    assert { object.to_a == ["b", "c"] }
    object.clear
    assert { object.to_a.empty? }
  end

  it "一定時間経つと破棄する" do
    object = ShareBoard::MessageHistory.new(size: 1, expires_in: 1)
    object.clear_all
    object.push("a")
    sleep(1.5)
    assert { object.to_a.empty? }
  end

  it "無駄なく反転する" do
    object = ShareBoard::MessageHistory.new(size: 2, latest_order: true)
    object.push("a")
    object.push("b")
    object.push("c")
    assert { object.to_a == ["c", "b"] }
  end

  # it "to_topic" do
  #   object = ShareBoard::MessageHistory.new(size: 2, latest_order: true)
  #   object.push("a")
  #   object.push("b")
  #   object.push("c")
  #   assert { object.to_a == ["c", "b"] }
  # end
end
