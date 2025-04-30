# frozen-string-literal: true

module Swars
  module User::Stat
    class GradeByRulesStat < Base
      delegate *[
        :ids_scope,
      ], to: :stat

      # for プレイヤー情報
      def display_rank_items
        @display_rank_items ||= ::Swars::DisplayRankInfo.collect do |e|
          e.display_rank_item.merge(:grade_name => public_send(e.key)&.name)
        end
      end

      # for UserGroupScript
      def grade_per_rule
        @grade_per_rule ||= ::Swars::DisplayRankInfo.each_with_object({}) do |e, m|
          m[e.long_name] = public_send(e.key)&.name || ""
        end
      end

      ################################################################################

      def dr_ten_min
        normal_grades_hash[:ten_min]
      end

      def dr_three_min
        normal_grades_hash[:three_min]
      end

      def dr_ten_sec
        normal_grades_hash[:ten_sec]
      end

      # 罠ポイント
      # 対象が0件に絞られても集約関数は必ずレコードを返す
      # それなら if record = s.take とする必要はない
      # と思うかもしれないが最初から 0 件の場合は s.take が nil になるためやっぱり if がいる
      # あと0件に絞られたときレコードが取れても min_priority は nil になっている
      def dr_sprint
        @dr_sprint ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => :imode)
          s = s.joins(:grade)
          s = s.where(Imode.arel_table[:key].eq(:sprint))
          s = s.select("MIN(#{Swars::Grade.table_name}.priority) AS min_priority")
          if record = s.take
            Swars::GradeInfo.fetch_if(record.min_priority)
          end
        end
      end

      ################################################################################

      private

      # 通常専用
      def normal_grades_hash
        @normal_grades_hash ||= yield_self do
          s = ids_scope
          s = s.joins(:battle => [:imode, :rule])
          s = s.joins(:grade)
          s = s.where(Imode.arel_table[:key].eq(:normal))
          s = s.group(:rule_key)
          s = s.select([
              "#{Swars::Rule.table_name}.key AS rule_key",
              "MIN(#{Swars::Grade.table_name}.priority) AS min_priority",
            ])
          Rails.logger.debug { s.to_t }
          # => "SELECT swars_rules.key AS rule_key, MIN(swars_grades.priority) AS min_priority FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_rules` ON `swars_rules`.`id` = `swars_battles`.`rule_id` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY rule_key"
          # >> |-----------+--------------+
          # >> | rule_key  | min_priority |
          # >> |-----------+--------------+
          # >> | three_min |            3 |
          # >> | ten_sec   |            4 |
          # >> |-----------+--------------+

          if false
            # min_priority から段位名にSQLで変換する場合:
            if false
              # JOIN したい swars_grades の方を「FROM swars_grades」とするのはおかしい
              g = Swars::Grade.all
              g = g.joins("INNER JOIN (#{s.to_sql}) main ON priority = main.min_priority")
              g = g.select("main.rule_key, #{Swars::Grade.table_name}.key AS grade_name")
            else
              # 副SQLを主体として swars_grades を JOIN する
              sql = []
              sql << "SELECT main.rule_key, g.key AS grade_name"
              sql << "FROM (#{s.to_sql}) main"
              sql << "INNER JOIN #{Swars::Grade.table_name} g ON g.priority = main.min_priority"
              g = ActiveRecord::Base.connection.select_all(sql * " ")
            end
            Rails.logger.debug { g.to_t }
            # >> |-----------+------------+
            # >> | rule_key  | grade_name |
            # >> |-----------+------------+
            # >> | three_min | 七段       |
            # >> | ten_sec   | 六段       |
            # >> |-----------+------------+
            g.each_with_object({}) do |e, m|
              m[e["rule_key"].to_sym] = Swars::GradeInfo.fetch(e["grade_name"])
            end
          else
            # min_priority から段位名にSQLを使わずに変換する場合:
            # Ruby 側で行なった方が全体として 10ms ほど速くなる
            s.each_with_object({}) do |e, m|
              m[e.rule_key.to_sym] = Swars::GradeInfo.fetch(e.min_priority)
            end
          end
        end
      end
    end
  end
end
