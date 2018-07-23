require "rails_helper"

RSpec.describe "ランキング", type: :system do
  it "基本" do
    user = create(:colosseum_user)

    user = create(:colosseum_user)
    user.judge_add(:lose)

    user = create(:colosseum_user)
    user.judge_add(:win)
    user.judge_add(:lose)

    user = create(:colosseum_user)
    user.judge_add(:win)
    user.judge_add(:lose)

    user = create(:colosseum_user)
    user.judge_add(:win)
    user.judge_add(:win)

    visit "/colosseum/rankings"
    doc_image
  end
end
