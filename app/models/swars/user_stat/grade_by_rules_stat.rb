# frozen-string-literal: true

module Swars
  module UserStat
    class GradeByRulesStat < Base
      delegate *[
        :ids_scope,
      ], to: :@user_stat

      def to_chart
        s = ids_scope
        s = s.joins(:battle => :rule).joins(:grade)
        s = s.group(:rule_key)
        s = s.select([
                       "#{Swars::Rule.table_name}.key AS rule_key",
                       "MIN(#{Swars::Grade.table_name}.priority) AS min_priority",
                     ])
        Rails.logger.debug { s.to_t }
        # => "SELECT swars_rules.key AS rule_key, MIN(swars_grades.priority) AS min_priority FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_rules` ON `swars_rules`.`id` = `swars_battles`.`rule_id` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY rule_key"
        # >> |-----------+--------------+----+------------------+-----------------+--------------------+---------------+----------------|
        # >> | rule_key  | min_priority | id | defense_tag_list | attack_tag_list | technique_tag_list | note_tag_list | other_tag_list |
        # >> |-----------+--------------+----+------------------+-----------------+--------------------+---------------+----------------|
        # >> | three_min |            3 |    |                  |                 |                    |               |                |
        # >> | ten_sec   |            4 |    |                  |                 |                    |               |                |
        # >> |-----------+--------------+----+------------------+-----------------+--------------------+---------------+----------------|

        g = Swars::Grade.all
        g = g.joins("INNER JOIN (#{s.to_sql}) m ON priority = m.min_priority")
        g = g.select("m.rule_key, #{Swars::Grade.table_name}.key AS grade_name")
        Rails.logger.debug { g.to_t }
        # => "SELECT m.rule_key, swars_grades.key AS grade_name FROM `swars_grades` INNER JOIN (SELECT swars_rules.key AS rule_key, MIN(swars_grades.priority) AS min_priority FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_rules` ON `swars_rules`.`id` = `swars_battles`.`rule_id` INNER JOIN `swars_grades` ON `swars_grades`.`id` = `swars_memberships`.`grade_id` WHERE `swars_memberships`.`id` IN (98271894, 98271896, 98271899, 98271900, 98271902, 98271905, 98271907, 98271909, 98271911, 98271913, 98303204, 98212763, 98212766, 98212768, 98212769, 98212771, 98212774, 98208928, 98212775, 98212778, 98263994, 98263995, 98263998, 98264000, 98264001, 98264003, 98264005, 98264007, 98196869, 98196871, 98196872, 98196874, 98196876, 98196878, 98196881, 98196885, 98196899, 98196901, 98196903, 98196909, 98196911, 98196913, 98196915, 98191817, 97909143, 97909144, 97904863, 97904485, 97904487, 97904490) GROUP BY rule_key) m ON priority = m.min_priority ORDER BY `swars_grades`.`priority` ASC"
        # >> |-----------+------------+----|
        # >> | rule_key  | grade_name | id |
        # >> |-----------+------------+----|
        # >> | three_min | 七段       |    |
        # >> | ten_sec   | 六段       |    |
        # >> |-----------+------------+----|

        hash = g.each_with_object({}) do |e, m|
          m[e.rule_key.to_sym] = e.grade_name
        end

        RuleInfo.collect do |e|
          {
            :rule_key   => e.key,
            :rule_name  => e.name,
            :grade_name => hash[e.key],
          }
        end
      end
    end
  end
end
