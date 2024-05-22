# frozen-string-literal: true

module Swars
  module UserStat
    class BpdStat < Base
      delegate *[
        :ids_scope,
        :ids_count,
      ], to: :@user_stat

      # 1日の平均対局数
      def average
        @average ||= yield_self do
          if ids_count.positive?
            s = ids_scope
            s = s.joins(:battle)
            s = s.group(:battled_on)
            s = s.select([
                           "DATE(#{battled_at}) AS battled_on",
                           "COUNT(*) AS count_all",
                         ])
            Rails.logger.debug { s.to_t }

            # SELECT AVG(count_all) FROM (SELECT DATE(CONVERT_TZ(battled_at, 'UTC', 'Asia/Tokyo')) AS battled_on, COUNT(*) AS count_all FROM swars_memberships INNER JOIN swars_battles ON swars_battles.id = swars_memberships.battle_id WHERE swars_memberships.id IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY battled_on) AS avg_value
            sql = "SELECT AVG(count_all) FROM (#{s.to_sql}) AS avg_value"
            ActiveRecord::Base.connection.select_value(sql).to_f.round(2)
          end
        end
      end

      private

      def battled_at
        MysqlUtil.column_tokyo_timezone_cast(:battled_at)
      end
    end
  end
end
