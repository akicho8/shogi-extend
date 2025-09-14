module Swars
  class Battle
    concern :StatMethods do
      included do
        scope :with_today,     -> { where(created_at: 0.days.ago.all_day) } # 本日取得分
        scope :with_yesterday, -> { where(created_at: 1.days.ago.all_day) } # 昨日取得分
      end

      class_methods do
        def stat
          {}.tap do |hv|
            hv[:elapsed] = TimeTrial.ms { hv.update(stat_without_elapsed) }
          end
        end

        def stat_without_elapsed
          {
            :all_count              => count,
            :today_import_count     => with_today.count,
            :yesterday_import_count => with_yesterday.count,
          }
        end
      end
    end
  end
end
