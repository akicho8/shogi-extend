require "rails_helper"

module Swars
  RSpec.describe Battle::CsaSeqToCsa, type: :model, swars_spec: true do
    it "works" do
      battle = Swars::Battle.create!
      battle.kifu_body.include?("$X_FINAL:投了")
      battle.kifu_body.include?("$X_WINNER:black")
    end
  end
end
