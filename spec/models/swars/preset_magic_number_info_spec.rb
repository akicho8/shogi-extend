require "rails_helper"

module Swars
  RSpec.describe PresetMagicNumberInfo, type: :model, swars_spec: true do
    it "works" do
      value = PresetMagicNumberInfo.by_magic_number(1)
      is_asserted_by { value.real_key == "香落ち" }
      is_asserted_by { value.preset_info.name == "香落ち" }
    end
  end
end
