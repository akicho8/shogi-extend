require "rails_helper"

RSpec.describe Swars::PresetMagicNumberInfo, type: :model, swars_spec: true do
  it "works" do
    assert { Swars::PresetMagicNumberInfo.fetch_by_magic_number(1).preset_info.name == "香落ち" }
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::PresetMagicNumberInfo
# >>   .fetch_by_magic_number
# >>   preset_info
# >>
# >> Swars::Top 2 slowest examples (0.2284 seconds, 9.7% of total time):
# >>   Swars::PresetMagicNumberInfo .fetch_by_magic_number
# >>     0.15115 seconds -:5
# >>   Swars::PresetMagicNumberInfo preset_info
# >>     0.07725 seconds -:8
# >>
# >> Swars::Finished in 2.35 seconds (files took 1.65 seconds to load)
# >> 2 examples, 0 failures
# >>
