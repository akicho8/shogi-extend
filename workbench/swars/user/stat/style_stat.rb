require "./setup"
# Swars::User["bsplive"].stat.style_stat.counts_hash            # => {:準王道=>11, :変態=>7, :準変態=>15, :王道=>4}
# Swars::User["bsplive"].stat.style_stat.ratios_hash            # => {:王道=>0.10810810810810811, :準王道=>0.2972972972972973, :準変態=>0.40540540540540543, :変態=>0.1891891891891892}
# Swars::User["bsplive"].stat.style_stat.denominator            # => 37
# Swars::User["bsplive"].stat.style_stat.majority_ratio         # => 0.40540540540540543
# Swars::User["bsplive"].stat.style_stat.minority_ratio         # => 0.5945945945945946
# Swars::User["bsplive"].stat.style_stat.to_chart               # => [{:name=>"王道", :value=>4}, {:name=>"準王道", :value=>11}, {:name=>"準変態", :value=>15}, {:name=>"変態", :value=>7}]

# Swars::User::Stat::StyleStat.vip_update_all(max: 1)

sql
battle = Swars::Battle.find(14375030)    # => #<Swars::Battle id: 14375030, key: "suzukihajime-bediazepine-20210911_232427", battled_at: "2021-09-11 23:24:27.000000000 +0900", csa_seq: [["+7776FU", 3598], ["-3334FU", 3600], ["+2868HI", 3589], ["-4344FU", 3599], ["+7675FU", 3585], ["-8242HI", 3597], ["+6878HI", 3583], ["-7182GI", 3593], ["+5948OU", 3580], ["-6171KI", 3589], ["+3938GI", 3574], ["-5162OU", 3587], ["+4839OU", 3569], ["-6272OU", 3585], ["+7574FU", 3562], ["-7374FU", 3583], ["+7874HI", 3558], ["-0073FU", 3582], ["+7476HI", 3553], ["-3132GI", 3578], ["+6958KI", 3546], ["-2233KA", 3576], ["+9796FU", 3541], ["-9394FU", 3574], ["+8977KE", 3538], ["-7162KI", 3573], ["+8897KA", 3535], ["-3243GI", 3569], ["+7968GI", 3532], ["-4152KI", 3565], ["+3928OU", 3526], ["-2324FU", 3564], ["+5756FU", 3523], ["-2425FU", 3562], ["+5655FU", 3519], ["-4222HI", 3560], ["+6857GI", 3514], ["-1314FU", 3551], ["+1716FU", 3504], ["-1112KY", 3542], ["+9786KA", 3495], ["-4445FU", 3537], ["+5756GI", 3491], ["-3324KA", 3533], ["+5645GI", 3485], ["-2133KE", 3529], ["+4554GI", 3475], ["-5354FU", 3524], ["+8631UM", 3472], ["-2223HI", 3522], ["+5554FU", 3471], ["-2435KA", 3518], ["+7765KE", 3462], ["-0042GI", 3512], ["+3142UM", 3453], ["-5242KI", 3509], ["+7656HI", 3452], ["-0045KA", 3501], ["+5453TO", 3444], ["-4556KA", 3496], ["+5342TO", 3441], ["-5665KA", 3490], ["+4243TO", 3432], ["-6543KA", 3489], ["+0042GI", 3423], ["-4387UM", 3482], ["+0053FU", 3414], ["-2526FU", 3475], ["+2726FU", 3412], ["-8743UM", 3471], ["+0052KI", 3402], ["-6252KI", 3466], ["+5352TO", 3393], ["-4352UM", 3465], ["+0053GI", 3384], ["-3553KA", 3463], ["+4253NG", 3382], ["-5253UM", 3459], ["+0032KA", 3380], ["-2322HI", 3454], ["+0054FU", 3376], ["-5364UM", 3449]], win_user_id: 533390, turn_max: 82, meta_info: {}, created_at: "2021-09-12 12:44:00.000000000 +0900", updated_at: "2024-06-29 08:49:03.000000000 +0900", start_turn: nil, critical_turn: 15, sfen_body: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", image_turn: nil, outbreak_turn: 47, accessed_at: "2021-09-12 12:44:00.000000000 +0900", sfen_hash: "91ce7c45ee625b799ad3bfbff459d800", xmode_id: 1, preset_id: 1, rule_id: 3, final_id: 1, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>
battle.rebuild                            # => true

# battle = Swars::Battle.find(20299393)    # => #<Swars::Battle id: 20299393, key: "Sweetooth-pagagm-20220309_095731", battled_at: "2022-03-09 09:57:31.000000000 +0900", csa_seq: [["+7776FU", 180], ["-4344FU", 179], ["+7675FU", 179], ["-3132GI", 178], ["+2878HI", 178], ["-3243GI", 178], ["+6958KI", 177], ["-3334FU", 177], ["+5948OU", 176], ["-2233KA", 176], ["+3938GI", 175], ["-8222HI", 175], ["+4839OU", 175], ["-7182GI", 175], ["+7574FU", 174], ["-7374FU", 174], ["+7874HI", 173], ["-2324FU", 173], ["+7968GI", 172], ["-2425FU", 173], ["+7476HI", 171], ["-0073FU", 171], ["+8786FU", 170], ["-5162OU", 170], ["+8685FU", 170], ["-5354FU", 169], ["+9796FU", 168], ["-6272OU", 168], ["+7686HI", 167], ["-3342KA", 167], ["+8676HI", 166], ["-6162KI", 166], ["+3928OU", 162], ["-2133KE", 164], ["+1716FU", 160], ["-1314FU", 163], ["+6877GI", 159], ["-4152KI", 162], ["+5756FU", 156], ["-2526FU", 160], ["+2726FU", 155], ["-2226HI", 159], ["+0027FU", 154], ["-2625HI", 159], ["+7786GI", 151], ["-1415FU", 158], ["+1615FU", 150], ["-0016FU", 157], ["+1916KY", 147], ["-1115KY", 156], ["+1615KY", 146], ["-2515HI", 155], ["+0016FU", 143], ["-1512HI", 122], ["+8879KA", 140], ["-1211HI", 97], ["+8977KE", 136], ["-4445FU", 95], ["+7968KA", 127], ["-4253KA", 93], ["+5655FU", 123], ["-5455FU", 87], ["+6824KA", 115], ["-5344KA", 83], ["+0074FU", 112], ["-7374FU", 82], ["+7674HI", 111], ["-0073FU", 81], ["+7444HI", 110], ["-4344GI", 80], ["+0022KA", 108], ["-1121HI", 79], ["+2233UM", 104], ["-4433GI", 78], ["+2433UM", 103], ["-0026FU", 77], ["+2726FU", 93], ["-0089HI", 75], ["+0053FU", 91], ["-6253KI", 74], ["+7765KE", 90], ["-0027FU", 71], ["+2827OU", 88], ["-8986RY", 70], ["+6553NK", 86], ["-8626RY", 68]], win_user_id: 15435, turn_max: 86, meta_info: {}, created_at: "2022-03-09 10:20:58.000000000 +0900", updated_at: "2022-03-09 10:20:58.000000000 +0900", start_turn: nil, critical_turn: 15, sfen_body: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", image_turn: nil, outbreak_turn: 50, accessed_at: "2024-04-08 01:18:25.000000000 +0900", sfen_hash: "cd4982448e1903bdaae01684d3ef39f1", xmode_id: 1, preset_id: 1, rule_id: 2, final_id: 1, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>
# battle.battled_at = Time.now
# battle.rebuild                            # => true
# tp battle.memberships                       # => #<ActiveRecord::Associations::CollectionProxy [#<Swars::Membership battle_id: 20299393, think_max: 10, think_last: 2, think_all_avg: 2, think_end_avg: 3, ai_two_freq: 0.13953488372093023, ai_drop_total: 0, ai_wave_count: 0, ai_noizy_two_max: 2, ai_gear_freq: 0.0, attack_tag_list: ["早石田"], defense_tag_list: ["美濃囲い"], technique_tag_list: [], note_tag_list: ["振り飛車", "対振り飛車", "相振り飛車", "持久戦", "短手数"], ek_score_without_cond: 13, ek_score_with_cond: nil, style_id: 1, id: 40558959, user_id: 603746, grade_id: 5, position: 0, created_at: "2022-03-09 10:20:58.000000000 +0900", updated_at: "2024-06-28 20:58:05.000000000 +0900", grade_diff: 2, op_user_id: 15435, judge_id: 2, location_id: 1, other_tag_list: nil>, #<Swars::Membership battle_id: 20299393, think_max: 33, think_last: 2, think_all_avg: 2, think_end_avg: 1, ai_two_freq: 0.16279069767441862, ai_drop_total: 0, ai_wave_count: 0, ai_noizy_two_max: 2, ai_gear_freq: 0.06976744186046512, attack_tag_list: ["パックマン戦法", "向かい飛車"], defense_tag_list: ["金無双"], technique_tag_list: ["垂れ歩"], note_tag_list: ["対振り飛車", "振り飛車", "相振り飛車", "持久戦", "短手数"], ek_score_without_cond: 9, ek_score_with_cond: nil, style_id: 2, id: 40558960, user_id: 15435, grade_id: 3, position: 1, created_at: "2022-03-09 10:20:59.000000000 +0900", updated_at: "2024-06-28 20:58:05.000000000 +0900", grade_diff: -2, op_user_id: 603746, judge_id: 1, location_id: 2, other_tag_list: nil>]>
# >>   Swars::Battle Load (0.7ms)  SELECT `swars_battles`.* FROM `swars_battles` WHERE `swars_battles`.`id` = 14375030 LIMIT 1
# >>   Swars::Membership Load (0.9ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 14375030 ORDER BY `swars_memberships`.`position` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/csa_seq_to_csa.rb:19:in `render_header'
# >>   Swars::User Load (0.7ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 25383 LIMIT 1
# >>   ↳ app/models/swars/membership.rb:160:in `name_with_grade'
# >>   Swars::Grade Load (0.5ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 4 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/membership.rb:160:in `name_with_grade'
# >>   Swars::Membership Load (0.6ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 14375030 ORDER BY `swars_memberships`.`position` ASC LIMIT 1 OFFSET 1
# >>   ↳ app/models/swars/battle/csa_seq_to_csa.rb:20:in `render_header'
# >>   Swars::User Load (0.3ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 533390 LIMIT 1
# >>   ↳ app/models/swars/membership.rb:160:in `name_with_grade'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 5 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/membership.rb:160:in `name_with_grade'
# >>   Swars::Rule Load (0.5ms)  SELECT `swars_rules`.* FROM `swars_rules` WHERE `swars_rules`.`id` = 3 ORDER BY `swars_rules`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:103:in `public_send'
# >>   Swars::Xmode Load (0.4ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`id` = 1 ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/swars/battle/csa_seq_to_csa.rb:67:in `event_types'
# >>   Swars::Xmode Load (0.3ms)  SELECT `swars_xmodes`.* FROM `swars_xmodes` WHERE `swars_xmodes`.`key` = '指導' ORDER BY `swars_xmodes`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Preset Load (0.4ms)  SELECT `presets`.* FROM `presets` WHERE `presets`.`id` = 1 ORDER BY `presets`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:103:in `public_send'
# >>   Swars::Membership Count (0.5ms)  SELECT COUNT(*) FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 14375030
# >>   ↳ app/models/swars/battle/csa_seq_to_csa.rb:34:in `render_body'
# >>   Swars::Final Load (0.4ms)  SELECT `swars_finals`.* FROM `swars_finals` WHERE `swars_finals`.`id` = 1 ORDER BY `swars_finals`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:103:in `public_send'
# >>   Swars::Membership Load (1.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` WHERE `swars_memberships`.`battle_id` = 14375030 ORDER BY `swars_memberships`.`position` ASC
# >>   ↳ app/models/swars/battle/core_methods.rb:59:in `parser_exec_after'
# >>   Location Load (0.5ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`id` = 1 ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:103:in `public_send'
# >>   Location Load (0.3ms)  SELECT `locations`.* FROM `locations` WHERE `locations`.`id` = 2 ORDER BY `locations`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:103:in `public_send'
# >>   Swars::MembershipExtra Load (0.5ms)  SELECT `swars_membership_extras`.* FROM `swars_membership_extras` WHERE `swars_membership_extras`.`membership_id` = 28727251 LIMIT 1
# >>   ↳ app/models/swars/battle/core_methods.rb:39:in `block in membership_extra_build_if_nothing'
# >>   Swars::MembershipExtra Load (0.3ms)  SELECT `swars_membership_extras`.* FROM `swars_membership_extras` WHERE `swars_membership_extras`.`membership_id` = 28727253 LIMIT 1
# >>   ↳ app/models/swars/battle/core_methods.rb:39:in `block in membership_extra_build_if_nothing'
# >>   ActsAsTaggableOn::Tagging Load (0.8ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership'
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (1.1ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tagging Load (0.5ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership'
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.8ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   ActsAsTaggableOn::Tag Load (0.7ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/battle/core_methods.rb:69:in `block (3 levels) in parser_exec_after'
# >>   Swars::Style Load (0.5ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   Swars::Style Load (0.3ms)  SELECT `swars_styles`.* FROM `swars_styles` WHERE `swars_styles`.`key` = '王道' ORDER BY `swars_styles`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_memory_record.rb:22:in `db_record!'
# >>   TRANSACTION (0.2ms)  BEGIN
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Judge Load (0.4ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 2 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Swars::User Load (0.4ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 25383 LIMIT 1
# >>   ↳ app/models/swars/membership.rb:106:in `block in <class:Membership>'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 4 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/membership.rb:108:in `block in <class:Membership>'
# >>   Swars::Membership Exists? (0.4ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 1 AND `swars_memberships`.`id` != 28727251 AND `swars_memberships`.`battle_id` = 14375030 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 533390 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 25383 AND `swars_memberships`.`id` != 28727251 AND `swars_memberships`.`battle_id` = 14375030 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 533390 AND `swars_memberships`.`id` != 28727251 AND `swars_memberships`.`battle_id` = 14375030 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Membership Update (0.6ms)  UPDATE `swars_memberships` SET `swars_memberships`.`updated_at` = '2024-06-28 23:54:34', `swars_memberships`.`ai_two_freq` = 0.12195121951219512 WHERE `swars_memberships`.`id` = 28727251
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (46.4ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('美濃囲い'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.6ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (38.9ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('角道オープン四間飛車') OR LOWER(name) = LOWER('早石田') OR LOWER(name) = LOWER('４→３戦法') OR LOWER(name) = LOWER('石田流'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (19.9ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('垂れ歩'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (44.7ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('大駒全ブッチ') OR LOWER(name) = LOWER('相振り飛車') OR LOWER(name) = LOWER('持久戦') OR LOWER(name) = LOWER('短手数'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (36.3ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('角道オープン四間飛車') OR LOWER(name) = LOWER('早石田') OR LOWER(name) = LOWER('４→３戦法') OR LOWER(name) = LOWER('石田流'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.5ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (20.5ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('美濃囲い'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (44.8ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('大駒全ブッチ') OR LOWER(name) = LOWER('相振り飛車') OR LOWER(name) = LOWER('持久戦') OR LOWER(name) = LOWER('短手数'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (20.2ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('垂れ歩'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727251 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Judge Load (0.2ms)  SELECT `judges`.* FROM `judges` WHERE `judges`.`id` = 1 ORDER BY `judges`.`position` ASC LIMIT 1
# >>   ↳ app/models/application_record.rb:99:in `public_send'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 533390 LIMIT 1
# >>   ↳ app/models/swars/membership.rb:106:in `block in <class:Membership>'
# >>   Swars::Grade Load (0.3ms)  SELECT `swars_grades`.* FROM `swars_grades` WHERE `swars_grades`.`id` = 5 ORDER BY `swars_grades`.`priority` ASC LIMIT 1
# >>   ↳ app/models/swars/membership.rb:108:in `block in <class:Membership>'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 533390 LIMIT 1
# >>   ↳ app/models/swars/membership.rb:113:in `block in <class:Membership>'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`location_id` = 2 AND `swars_memberships`.`id` != 28727253 AND `swars_memberships`.`battle_id` = 14375030 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::User Load (0.2ms)  SELECT `swars_users`.* FROM `swars_users` WHERE `swars_users`.`id` = 25383 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Membership Exists? (0.1ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`user_id` = 533390 AND `swars_memberships`.`id` != 28727253 AND `swars_memberships`.`battle_id` = 14375030 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Membership Exists? (0.2ms)  SELECT 1 AS one FROM `swars_memberships` WHERE `swars_memberships`.`op_user_id` = 25383 AND `swars_memberships`.`id` != 28727253 AND `swars_memberships`.`battle_id` = 14375030 LIMIT 1
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Membership Update (0.3ms)  UPDATE `swars_memberships` SET `swars_memberships`.`updated_at` = '2024-06-28 23:54:34', `swars_memberships`.`ai_two_freq` = 0.24390243902439024 WHERE `swars_memberships`.`id` = 28727253
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (20.1ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('金無双'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (20.2ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('四間飛車'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'technique_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (44.9ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('大駒コンプリート') OR LOWER(name) = LOWER('相振り飛車') OR LOWER(name) = LOWER('持久戦') OR LOWER(name) = LOWER('短手数'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (20.2ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('四間飛車'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.3ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'attack_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (20.0ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('金無双'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'defense_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (44.8ms)  SELECT `tags`.* FROM `tags` WHERE (LOWER(name) = LOWER('対振り飛車') OR LOWER(name) = LOWER('振り飛車') OR LOWER(name) = LOWER('大駒コンプリート') OR LOWER(name) = LOWER('相振り飛車') OR LOWER(name) = LOWER('持久戦') OR LOWER(name) = LOWER('短手数'))
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tag Load (0.4ms)  SELECT `tags`.* FROM `tags` INNER JOIN `taggings` ON `tags`.`id` = `taggings`.`tag_id` WHERE `taggings`.`taggable_id` = 28727253 AND `taggings`.`taggable_type` = 'Swars::Membership' AND (taggings.context = 'note_tags' AND taggings.tagger_id IS NULL) ORDER BY taggings.id
# >>   ↳ app/models/swars/rebuilder_methods.rb:34:in `block in remake_fast'
# >>   Swars::Battle Update (0.3ms)  UPDATE `swars_battles` SET `swars_battles`.`updated_at` = '2024-06-28 23:54:34' WHERE `swars_battles`.`id` = 14375030
# >>   ↳ app/models/swars/rebuilder_methods.rb:36:in `block in remake_fast'
# >>   ActsAsTaggableOn::Tagging Load (0.2ms)  SELECT `taggings`.* FROM `taggings` WHERE `taggings`.`taggable_id` = 14375030 AND `taggings`.`taggable_type` = 'Swars::Battle'
# >>   ↳ app/models/swars/rebuilder_methods.rb:36:in `block in remake_fast'
# >>   Swars::User Update (0.2ms)  UPDATE `swars_users` SET `swars_users`.`updated_at` = '2024-06-28 23:54:34', `swars_users`.`latest_battled_at` = '2024-06-28 23:54:34' WHERE `swars_users`.`id` = 25383
# >>   ↳ app/models/swars/rebuilder_methods.rb:33:in `remake_fast'
# >>   Swars::User Update (0.2ms)  UPDATE `swars_users` SET `swars_users`.`updated_at` = '2024-06-28 23:54:34', `swars_users`.`latest_battled_at` = '2024-06-28 23:54:34' WHERE `swars_users`.`id` = 533390
# >>   ↳ app/models/swars/rebuilder_methods.rb:33:in `remake_fast'
# >>   TRANSACTION (0.8ms)  COMMIT
# >>   ↳ app/models/swars/rebuilder_methods.rb:33:in `remake_fast'
