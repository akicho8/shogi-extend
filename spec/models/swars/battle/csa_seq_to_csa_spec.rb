require "rails_helper"

RSpec.describe Swars::Battle::CsaSeqToCsa, type: :model, swars_spec: true do
  it "works" do
    battle = Swars::Battle.create!
    battle.kifu_body.include?("$X_FINAL:投了")
    battle.kifu_body.include?("$X_WINNER:▲")
  end
end
