module Acns2
  class MovesAnswer < ApplicationRecord
    belongs_to :question

    before_validation do
      if changes_to_save[:sfen_moves_pack] && v = sfen_moves_pack.presence
        self.limit_turn = v.split.size
      end
    end

    with_options presence: true do
      validates :sfen_moves_pack
      validates :limit_turn
    end
  end
end
