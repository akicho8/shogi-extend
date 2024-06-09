# frozen-string-literal: true

module Swars
  module User::Stat
    class RapidAttackStat < Base
      delegate *[
        :tag_stat,
        :win_stat,
      ], to: :@stat

      def badge?
        if tag_stat.win_count_by(:"持久戦") < tag_stat.win_count_by(:"急戦")
          win_stat.exist?(:"急戦")
        end
      end
    end
  end
end
