require "rails_helper"

module Swars
  RSpec.describe BanInfo, type: :model, swars_spec: true do
    it "works" do
      assert2 { BanInfo["ソフト指し"] }
      assert2 { BanInfo["on"] }
      assert2 { BanInfo["true"] }
      assert2 { BanInfo["ON"] }
    end
  end
end
