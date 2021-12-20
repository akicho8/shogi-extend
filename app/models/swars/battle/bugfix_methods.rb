module Swars
  class Battle
    concern :BugfixMethods do
      class_methods do
        def rule_key_bugfix_process
          c = 0
          Swars::Battle.where(Swars::Battle.arel_table[:created_at].gteq("2020-01-17".to_time)).find_each do |battle|
            if battle.rule_key == "ten_min"
              if ary = battle.csa_seq.first
                v = ary.last
                rule_key = nil
                case
                when v <= 180
                  rule_key = "three_min"
                when v >= 1000
                  rule_key = "ten_sec"
                end
                if rule_key
                  battle.update!(rule_key: rule_key)
                  c += 1
                end
              end
            end
          end
          SlackAgent.notify(subject: "rule_key_bugfix_process", body: c.to_s)
        end
      end
    end
  end
end
