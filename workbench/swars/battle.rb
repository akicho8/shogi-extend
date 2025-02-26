require "./setup"

battle = Swars::Battle.create!
battle.analysis_version # => 3
battle.update!(analysis_version: 0)
battle = Swars::Battle.find(battle.id)

battle.analysis_version # => 0
battle.rebuild
battle.analysis_version # => 3
# >> |--------------------+---|
# >> |                 id |   |
# >> |                key |   |
# >> |         battled_at |   |
# >> |            csa_seq |   |
# >> |        win_user_id |   |
# >> |           turn_max |   |
# >> |          meta_info |   |
# >> |         created_at |   |
# >> |         updated_at |   |
# >> |         start_turn |   |
# >> |      critical_turn |   |
# >> |          sfen_body |   |
# >> |         image_turn |   |
# >> |      outbreak_turn |   |
# >> |        accessed_at |   |
# >> |          sfen_hash |   |
# >> |           xmode_id |   |
# >> |          preset_id |   |
# >> |            rule_id |   |
# >> |           final_id |   |
# >> |   analysis_version | 0 |
# >> |  starting_position |   |
# >> |           imode_id |   |
# >> |   defense_tag_list |   |
# >> |    attack_tag_list |   |
# >> | technique_tag_list |   |
# >> |      note_tag_list |   |
# >> |--------------------+---|
# >> .
