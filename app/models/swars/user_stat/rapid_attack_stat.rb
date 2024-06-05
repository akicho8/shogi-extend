# frozen-string-literal: true

module Swars
  module UserStat
    class RapidAttackStat < Base
      delegate *[
        :win_tag,
        :win_ratio,
      ], to: :@user_stat

      def medal?
        if (win_ratio || 0) > 0.5
          win_tag.count(:"持久戦") < win_tag.count(:"急戦")
        end
      end
    end
  end
end
