class ChoreTask1 < ActiveRecord::Migration[6.0]
  def up
    Actb::Question.good_bad_click_by_owner_reject_all
  end
end
