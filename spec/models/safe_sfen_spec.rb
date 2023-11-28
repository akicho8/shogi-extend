require "rails_helper"

RSpec.describe SafeSfen, type: :model do
  it "encode" do
    assert { SafeSfen.encode("position sfen 9/9/9/9/9/9/9/9/9 b - 1") == "cG9zaXRpb24gc2ZlbiA5LzkvOS85LzkvOS85LzkvOSBiIC0gMQ" }
  end
  it "decode" do
    assert { SafeSfen.decode("cG9zaXRpb24gc2ZlbiA5LzkvOS85LzkvOS85LzkvOSBiIC0gMQ") == "position sfen 9/9/9/9/9/9/9/9/9 b - 1" }
  end
end
