require "./setup"

battle = Swars::Battle.create!(key: SecureRandom.hex, csa_seq: Swars::KifuGenerator.gear_pattern(size: 50))
tp battle.memberships[0]
battle.memberships[0].fraud?        # => true
battle.memberships.fraud_only.count # => 2

battle = Swars::Battle.create!(key: SecureRandom.hex, csa_seq: Swars::KifuGenerator.gear_pattern(size: 49))
tp battle.memberships[0]
battle.memberships[0].fraud?        # => false
battle.memberships.fraud_only.count # => 0
# >> |-----------------------+---------------------------|
# >> |                    id | 98346917                  |
# >> |             battle_id | 49285315                  |
# >> |               user_id | 957333                    |
# >> |              grade_id | 39                        |
# >> |              position | 0                         |
# >> |            created_at | 2024-05-30 20:09:50 +0900 |
# >> |            updated_at | 2024-05-30 20:09:50 +0900 |
# >> |            grade_diff | 0                         |
# >> |             think_max | 2                         |
# >> |            op_user_id | 957334                    |
# >> |            think_last | 1                         |
# >> |         think_all_avg | 1                         |
# >> |         think_end_avg | 1                         |
# >> |         ai_drop_total | 0                         |
# >> |              judge_id | 1                         |
# >> |           location_id | 1                         |
# >> |              style_id |                           |
# >> | ek_score_without_cond | 0                         |
# >> |    ek_score_with_cond |                           |
# >> |         ai_wave_count | 0                         |
# >> |           ai_two_freq | 0.48                      |
# >> |      ai_noizy_two_max | 1                         |
# >> |          ai_gear_freq | 0.48                      |
# >> |      defense_tag_list |                           |
# >> |       attack_tag_list | 力戦                      |
# >> |    technique_tag_list |                           |
# >> |         note_tag_list | 居飛車 相居飛車           |
# >> |        other_tag_list |                           |
# >> |-----------------------+---------------------------|
# >> |-----------------------+---------------------------|
# >> |                    id | 98346919                  |
# >> |             battle_id | 49285316                  |
# >> |               user_id | 957335                    |
# >> |              grade_id | 39                        |
# >> |              position | 0                         |
# >> |            created_at | 2024-05-30 20:09:51 +0900 |
# >> |            updated_at | 2024-05-30 20:09:51 +0900 |
# >> |            grade_diff | 0                         |
# >> |             think_max | 2                         |
# >> |            op_user_id | 957336                    |
# >> |            think_last | 1                         |
# >> |         think_all_avg | 1                         |
# >> |         think_end_avg | 1                         |
# >> |         ai_drop_total | 0                         |
# >> |              judge_id | 1                         |
# >> |           location_id | 1                         |
# >> |              style_id |                           |
# >> | ek_score_without_cond | 0                         |
# >> |    ek_score_with_cond |                           |
# >> |         ai_wave_count | 0                         |
# >> |           ai_two_freq | 0.48                      |
# >> |      ai_noizy_two_max | 1                         |
# >> |          ai_gear_freq | 0.48                      |
# >> |      defense_tag_list |                           |
# >> |       attack_tag_list | 力戦                      |
# >> |    technique_tag_list |                           |
# >> |         note_tag_list | 居飛車 相居飛車           |
# >> |        other_tag_list |                           |
# >> |-----------------------+---------------------------|
