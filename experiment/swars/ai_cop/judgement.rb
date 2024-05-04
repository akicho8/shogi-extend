#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)

ForeignKey.disabled
Swars.setup(force: true)

user1 = Swars::User.create!
user2 = Swars::User.create!

battle = Swars::Battle.new
battle.csa_seq = [["+5756FU", 0],["-5354FU", 0],["+5958OU", 0],["-5152OU", 0],["+5857OU", 0],["-5253OU", 0],["+5746OU", 0],["-5364OU", 0],["+4645OU", 0],["-6465OU", 0],["+4544OU", 0],["-6566OU", 0],["+4453OU", 0],["-6657OU", 0]]
battle.memberships.build(user: user1, judge_key: :win,  location_key: :black)
battle.memberships.build(user: user2, judge_key: :lose, location_key: :white)
battle.save!                  # => true
membership = battle.memberships[0]

Swars::AiCop::Analyzer.analyze(membership.sec_list).to_h # => {:drop_total=>0, :wave_count=>0, :two_count=>0, :two_freq=>0.0, :noizy_two_max=>0, :ticket_count=>nil}

Swars::AiCop::Judgement.arrest_scope(Swars::Membership).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE (`swars_memberships`.`ai_wave_count` >= 3 OR `swars_memberships`.`ai_drop_total` >= 15 OR `swars_memberships`.`ai_two_freq` >= 0.6 AND `swars_battles`.`turn_max` >= 50)"
Swars::AiCop::Judgement.arrest_scope(Swars::Membership).count # => 0

# Swars::Membership
# membership.sec_list             # => [600 seconds, 0 seconds, 0 seconds, 0 seconds, 0 seconds, 0 seconds, 0 seconds]
tp membership

# >> |-----------------------+---------------------------|
# >> |                    id | 355                       |
# >> |             battle_id | 178                       |
# >> |               user_id | 171                       |
# >> |            op_user_id | 172                       |
# >> |              grade_id | 778                       |
# >> |              position | 0                         |
# >> |            grade_diff | 0                         |
# >> |            created_at | 2024-05-04 18:49:12 +0900 |
# >> |            updated_at | 2024-05-04 18:49:12 +0900 |
# >> |         think_all_avg | 85                        |
# >> |         think_end_avg | 0                         |
# >> |            think_last | 0                         |
# >> |             think_max | 600                       |
# >> |         ai_drop_total | 0                         |
# >> |              judge_id | 55                        |
# >> |           location_id | 37                        |
# >> |              style_id |                           |
# >> | ek_score_without_cond | 0                         |
# >> |    ek_score_with_cond |                           |
# >> |         ai_wave_count | 0                         |
# >> |           ai_two_freq | 0.0                       |
# >> |      ai_noizy_two_max | 0                         |
# >> |      defense_tag_list |                           |
# >> |       attack_tag_list | 力戦                      |
# >> |    technique_tag_list |                           |
# >> |         note_tag_list | 入玉 相入玉 居飛車        |
# >> |        other_tag_list |                           |
# >> |-----------------------+---------------------------|
