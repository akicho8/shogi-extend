require "rails_helper"

RSpec.describe Swars::StyleInfo, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::StyleInfo.fetch("王道") }
  end
end
