require "rails_helper"

RSpec.describe Swars::BattleUrlValidator, type: :model, swars_spec: true do
  it "works" do
    url = "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900"
    assert { Swars::BattleUrlValidator.valid?(url) }
    assert { Swars::BattleUrlValidator.invalid?("_#{url}") }
    assert { (Swars::BattleUrlValidator.validate!("_") rescue $!.class) == Swars::InvalidKey }
  end
end
