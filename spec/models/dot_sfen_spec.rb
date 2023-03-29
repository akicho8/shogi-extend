require "rails_helper"

RSpec.describe DotSfen, type: :model do
  it "escape" do
    assert2 { DotSfen.escape("position sfen 9/9/9/9/9/9/9/9/9 b - 1") == "position.sfen.9/9/9/9/9/9/9/9/9.b.-.1" }
    assert2 { DotSfen.escape("foo") == "foo" }
  end
  it "unescape" do
    assert2 { DotSfen.unescape("position.sfen.9/9/9/9/9/9/9/9/9.b.-.1") == "position sfen 9/9/9/9/9/9/9/9/9 b - 1" }
    assert2 { DotSfen.unescape("foo") == "foo" }
  end
end
