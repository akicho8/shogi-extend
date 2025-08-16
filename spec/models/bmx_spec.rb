require "rails_helper"

RSpec.describe Bmx, type: :model do
  it "works" do
    assert { Bmx.call { }.second }
    assert { Bmx.call { }.inspect }
  end
end
