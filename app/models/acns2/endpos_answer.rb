module Acns2
  class EndposAnswer < ApplicationRecord
    belongs_to :question, counter_cache: true

    before_validation do
      if changes_to_save[:sfen_endpos] && v = sfen_endpos.presence
        self.limit_turn = v.split.last
      end
    end

    with_options presence: true do
      validates :sfen_endpos
      validates :limit_turn
    end
  end
end
