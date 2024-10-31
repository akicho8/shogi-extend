require "./setup"

# Swars::Membership.joins(:battle => :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良")).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_xmodes`.`key` = '野良'"
# Swars::Membership.joins(:battle => :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良")).count # => 3476368

# s = s.where(xmode: ::Swars::Xmode.arel_table[:key].eq(:"野良"))

scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
p _ { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call } # => {:records=>[], :population_count=>0, :primary_aggregated_at=>Thu, 31 Oct 2024 00:48:22.668588000 JST +09:00, :primary_aggregation_second=>0.041097999550402164}
tp QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call

# # Time.current.to_fs(:ymdhms)               # => "2024-08-25 10:54:56"
# # p _ { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(batch_size: 500000).call }

# s = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
# s = s.joins(:taggings => :tag)
# s = s.joins(:judge)
# s = s.group("tags.name")
# s = s.group("judges.key")
# s.count                         # => {["新嬉野流", "win"]=>35, ["対振り飛車", "win"]=>35, ["居飛車", "win"]=>48, ["対抗形", "win"]=>35, ["2手目△3ニ飛戦法", "lose"]=>35, ["振り飛車", "lose"]=>35, ["対居飛車", "lose"]=>48, ["対抗形", "lose"]=>35, ["力戦", "win"]=>15, ["相居飛車", "win"]=>15, ["対居飛車", "win"]=>15, ["力戦", "lose"]=>15, ["居飛車", "lose"]=>15, ["相居飛車", "lose"]=>15}
#
# s = Swars::Membership.all
# s = s.joins(:taggings => :tag)
# s = s.joins(:judge)
# s = s.group("tags.name")
# s = s.group("judges.key")
# s.count

# >>   Swars::Membership Ids (2.3ms)  SELECT `swars_memberships`.`id` FROM `swars_memberships` WHERE `swars_memberships`.`id` IN (108956633, 108956634, 108956635, 108956636, 108956637, 108956638, 108956639, 108956640, 108956641, 108956642, 108956643, 108956644, 108956645, 108956646, 108956647, 108956648, 108956649, 108956650, 108956651, 108956652, 108956653, 108956654, 108956655, 108956656, 108956657, 108956658, 108956659, 108956660, 108956661, 108956662, 108956663, 108956664, 108956665, 108956666, 108956667, 108956668, 108956669, 108956670, 108956717, 108956718, 108956719, 108956720, 108956721, 108956722, 108956723, 108956724, 108956725, 108956726, 108956727, 108956728, 108956729, 108956730, 108956731, 108956732, 108956733, 108956734, 108956735, 108956736, 108956737, 108956738, 108956739, 108956740, 108956741, 108956742, 108956743, 108956744, 108956745, 108956746, 108956747, 108956748, 108956749, 108956750, 108956751, 108956752, 108956753, 108956754, 108956755, 108956756, 108956757, 108956758, 108956759, 108956760, 108956761, 108956762, 108956763, 108956764, 108956765, 108956766, 108956767, 108956768, 108956769, 108956770, 108956771, 108956772, 108956773, 108956774, 108956775, 108956776, 108956777, 108956778) ORDER BY `swars_memberships`.`id` ASC LIMIT 1000
# >>   ↳ app/models/quick_script/swars/tactic_stat_script/primary_aggregator.rb:54:in `with_index'
# >> [2024-10-31 00:48:22][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >>   Swars::Membership Count (2.7ms)  SELECT COUNT(*) FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_memberships`.`id` IN (108956633, 108956634, 108956635, 108956636, 108956637, 108956638, 108956639, 108956640, 108956641, 108956642, 108956643, 108956644, 108956645, 108956646, 108956647, 108956648, 108956649, 108956650, 108956651, 108956652, 108956653, 108956654, 108956655, 108956656, 108956657, 108956658, 108956659, 108956660, 108956661, 108956662, 108956663, 108956664, 108956665, 108956666, 108956667, 108956668, 108956669, 108956670, 108956717, 108956718, 108956719, 108956720, 108956721, 108956722, 108956723, 108956724, 108956725, 108956726, 108956727, 108956728, 108956729, 108956730, 108956731, 108956732, 108956733, 108956734, 108956735, 108956736, 108956737, 108956738, 108956739, 108956740, 108956741, 108956742, 108956743, 108956744, 108956745, 108956746, 108956747, 108956748, 108956749, 108956750, 108956751, 108956752, 108956753, 108956754, 108956755, 108956756, 108956757, 108956758, 108956759, 108956760, 108956761, 108956762, 108956763, 108956764, 108956765, 108956766, 108956767, 108956768, 108956769, 108956770, 108956771, 108956772, 108956773, 108956774, 108956775, 108956776, 108956777, 108956778) AND `swars_battles`.`turn_max` >= 14 AND `swars_xmodes`.`key` = '野良' AND `swars_battles`.`analysis_version` = 1
# >>   ↳ app/models/quick_script/swars/tactic_stat_script/primary_aggregator.rb:58:in `block (2 levels) in aggregate'
# >>   Swars::Membership Count (3.1ms)  SELECT COUNT(*) AS `count_all`, `tags`.`name` AS `tags_name`, `judges`.`key` AS `judges_key` FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` INNER JOIN `taggings` ON `taggings`.`taggable_type` = 'Swars::Membership' AND `taggings`.`taggable_id` = `swars_memberships`.`id` INNER JOIN `tags` ON `tags`.`id` = `taggings`.`tag_id` INNER JOIN `judges` ON `judges`.`id` = `swars_memberships`.`judge_id` WHERE `swars_memberships`.`id` IN (108956633, 108956634, 108956635, 108956636, 108956637, 108956638, 108956639, 108956640, 108956641, 108956642, 108956643, 108956644, 108956645, 108956646, 108956647, 108956648, 108956649, 108956650, 108956651, 108956652, 108956653, 108956654, 108956655, 108956656, 108956657, 108956658, 108956659, 108956660, 108956661, 108956662, 108956663, 108956664, 108956665, 108956666, 108956667, 108956668, 108956669, 108956670, 108956717, 108956718, 108956719, 108956720, 108956721, 108956722, 108956723, 108956724, 108956725, 108956726, 108956727, 108956728, 108956729, 108956730, 108956731, 108956732, 108956733, 108956734, 108956735, 108956736, 108956737, 108956738, 108956739, 108956740, 108956741, 108956742, 108956743, 108956744, 108956745, 108956746, 108956747, 108956748, 108956749, 108956750, 108956751, 108956752, 108956753, 108956754, 108956755, 108956756, 108956757, 108956758, 108956759, 108956760, 108956761, 108956762, 108956763, 108956764, 108956765, 108956766, 108956767, 108956768, 108956769, 108956770, 108956771, 108956772, 108956773, 108956774, 108956775, 108956776, 108956777, 108956778) AND `swars_battles`.`turn_max` >= 14 AND `swars_xmodes`.`key` = '野良' AND `swars_battles`.`analysis_version` = 1 GROUP BY `tags`.`name`, `judges`.`key`
# >>   ↳ app/models/quick_script/swars/tactic_stat_script/primary_aggregator.rb:65:in `block (2 levels) in aggregate'
# >> {:records=>[], :population_count=>0, :primary_aggregated_at=>Thu, 31 Oct 2024 00:48:22.668588000 JST +09:00, :primary_aggregation_second=>0.041097999550402164}
# >> [2024-10-31 00:48:22][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> |----------------------------+---------------------------|
# >> |                    records | []                        |
# >> |           population_count | 0                         |
# >> |      primary_aggregated_at | 2024-10-31 00:48:22 +0900 |
# >> | primary_aggregation_second | 0.008616000413894653      |
# >> |----------------------------+---------------------------|
