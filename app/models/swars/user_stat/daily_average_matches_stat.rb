# frozen-string-literal: true

module Swars
  module UserStat
    class DailyAverageMatchesStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :@user_stat

      # 1日の平均対局数
      def average
        @average ||= yield_self do
          if ids_count.positive?
            aggregate_outcome["average"].to_f.round(2)
          end
        end
      end

      # 1日の最高対局数
      def max
        @max ||= yield_self do
          if ids_count.positive?
            aggregate_outcome["max"]
          end
        end
      end

      private

      def aggregate_outcome
        @aggregate_outcome ||= yield_self do
          if ids_count.positive?
            s = ids_scope
            s = s.joins(:battle)
            s = s.group(:battled_on)
            s = s.select([
                           "DATE(#{battled_at}) AS battled_on",
                           "COUNT(*) AS count_all",
                         ])
            Rails.logger.debug { s.to_t }
            sql = "SELECT AVG(count_all) AS average, MAX(count_all) AS max FROM (#{s.to_sql}) AS from_values"
            ActiveRecord::Base.connection.select_one(sql)
          end
        end
      end

      def battled_at
        MysqlUtil.column_tokyo_timezone_cast(:battled_at)
      end
    end
  end
end
