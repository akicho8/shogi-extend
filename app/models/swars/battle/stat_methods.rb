module Swars
  class Battle
    concern :StatMethods do
      included do
        # TODO: created_at に index がない
        scope :with_today,     -> t = Time.current { where(created_at: t.midnight...t.midnight.tomorrow) }                     # 本日取得分
        scope :with_yesterday, -> t = Time.current { where(created_at: t.yesterday.midnight...t.yesterday.midnight.tomorrow) } # 昨日取得分
      end

      class_methods do
        def stat
          {}.tap do |hv|
            hv[:elapsed] = TimeTrial.ms { hv.update(stat_without_elapsed) }
          end
        end

        def stat_without_elapsed
          {
            :all_count => count,
            :today_import_count => with_today.count,
            :yesterday_import_count => with_yesterday.count,
          }
        end
      end
    end
  end
end
