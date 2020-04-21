module Acns2
  class MovesAnswer < ApplicationRecord
    belongs_to :question

    before_validation do
      if changes_to_save[:moves_str] && v = moves_str.presence
        self.limit_turn = v.split.size
      end
    end

    with_options presence: true do
      validates :moves_str
      validates :limit_turn
    end
  end
end
