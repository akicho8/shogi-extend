# frozen-string-literal: true

module Swars
  module User::Stat
    class RapidAttackStat < Base
      delegate *[
        :win_tag,
        :win_ratio,
      ], to: :@stat

      def badge?
        if (win_ratio || 0) > 0.5
          win_tag.count(:"持久戦") < win_tag.count(:"急戦")
        end
      end
    end
  end
end
