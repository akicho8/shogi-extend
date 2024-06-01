# frozen-string-literal: true

module Swars
  module UserStat
    concern :MembershipGlobalExtension do
      included do
        scope :win_only,  -> { s_where_judge_key_eq(:win)  }
        scope :lose_only, -> { s_where_judge_key_eq(:lose) }
        scope :draw_only, -> { s_where_judge_key_eq(:draw) }
      end

      class_methods do
        def total_judge_counts
          s_group_judge_key.count
        end
      end
    end
  end
end
