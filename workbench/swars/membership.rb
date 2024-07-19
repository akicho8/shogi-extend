require "./setup"
# ids_scope = Swars::User["bsplive"].stat.style_stat_mod.ids_scope
# Swars::Style.fetch("王道")            # => #<Swars::Style id: 1, key: "王道", position: 0, created_at: "2022-12-12 10:55:47.000000000 +0900", updated_at: "2022-12-12 10:55:47.000000000 +0900">

membership = Swars::User["bsplive"].memberships.first
membership.opponent2            # => #<Swars::Membership id: 11363296, battle_id: 5685678, user_id: 233808, grade_id: 4, position: 1, created_at: "2020-10-31 15:34:42.000000000 +0900", updated_at: "2024-06-28 13:15:20.000000000 +0900", grade_diff: 0, think_max: 11, op_user_id: 22122, think_last: 10, think_all_avg: 6, think_end_avg: 5, ai_drop_total: 0, judge_id: 1, location_id: 2, style_id: 1, ek_score_without_cond: 19, ek_score_with_cond: nil, ai_wave_count: 0, ai_two_freq: 0.221053, ai_noizy_two_max: 2, ai_gear_freq: 0.0210526, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil>
