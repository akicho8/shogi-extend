module ShareBoard
  module Xbadge
    extend self

    def match_record_default
      {
        win_count: 0,
        lose_count: 0,
      }
    end
  end
end
