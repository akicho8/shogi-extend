require "rails_helper"

module Swars
  RSpec.describe PresetMagicNumberInfo, type: :model, swars_spec: true do
    it "works" do
      value = PresetMagicNumberInfo.by_magic_number(1)
      assert2 { value.real_key == "香落ち" }
      assert2 { value.preset_info.name == "香落ち" }
    end
  end
end
