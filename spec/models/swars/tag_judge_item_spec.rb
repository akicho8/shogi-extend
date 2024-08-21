require "rails_helper"

module Swars
  RSpec.describe TagJudgeItem, type: :model, swars_spec: true do
    it "works" do
      black = User.create!
      Battle.create!(csa_seq: KifuGenerator.generate_n(14)) do |e|
        e.memberships.build(user: black)
      end
      TagJudgeItem.destroy_all
      TagJudgeItem.create_new_generation_items(scope: black.memberships)
      assert { TagJudgeItem.db_latest_items.present? }
      assert { TagJudgeItem.db_latest_created_at.present? }
      assert { TagJudgeItem.db_latest_generation == 0 }
    end
  end
end
