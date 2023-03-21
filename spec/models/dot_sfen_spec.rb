require "rails_helper"

RSpec.describe DotSfen, type: :model do
  it "escape" do
    is_asserted_by { DotSfen.escape("position sfen 9/9/9/9/9/9/9/9/9 b - 1") == "position.sfen.9/9/9/9/9/9/9/9/9.b.-.1" }
    is_asserted_by { DotSfen.escape("foo") == "foo" }
  end
  it "unescape" do
    is_asserted_by { DotSfen.unescape("position.sfen.9/9/9/9/9/9/9/9/9.b.-.1") == "position sfen 9/9/9/9/9/9/9/9/9 b - 1" }
    is_asserted_by { DotSfen.unescape("foo") == "foo" }
  end
end
