# frozen-string-literal: true

module Swars
  module UserStat
    concern :MembershipGlobalExtension do
      class_methods do
        def total_judge_counts
          s_group_judge_key.count
        end
      end
    end
  end
end
