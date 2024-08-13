require "rails_helper"

module Swars
  RSpec.describe BanInfo, type: :model, swars_spec: true do
    it "works" do
      assert { BanInfo["on"].key   == :and    }
      assert { BanInfo["true"].key == :and    }
      assert { BanInfo["除外"].key == :reject }
    end
  end
end
