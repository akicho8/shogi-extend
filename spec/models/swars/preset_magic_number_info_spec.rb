require "rails_helper"

module Swars
  RSpec.describe PresetMagicNumberInfo, type: :model, swars_spec: true do
    it "works" do
      value = PresetMagicNumberInfo.by_magick_number(1)
      assert { value.real_key == "香落ち" }
      assert { value.preset_info.name == "香落ち" }
    end
  end
end
