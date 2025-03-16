require "rails_helper"

RSpec.describe Swars::BanInfo, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::BanInfo["on"].key   == :and    }
    assert { Swars::BanInfo["true"].key == :and    }
    assert { Swars::BanInfo["除外"].key == :reject }
  end
end
