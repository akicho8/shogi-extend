require "./setup"

# # Time.current.to_fs(:ymdhms)               # => "2024-08-25 10:54:56"
# # p _ { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(batch_size: 500000).call }
# # scope = Swars::Membership.where(id: Swars::Membership.last(100000).collect(&:id))
# # p _ { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call } # => "1009.66 ms"
#
# s = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
# s = s.joins(:taggings => :tag)
# s = s.joins(:judge)
# s = s.group("tags.name")
# s = s.group("judges.key")
# s.count                         # => {["新嬉野流", "win"]=>35, ["対振り飛車", "win"]=>35, ["居飛車", "win"]=>48, ["対抗形", "win"]=>35, ["2手目△３ニ飛戦法", "lose"]=>35, ["振り飛車", "lose"]=>35, ["対居飛車", "lose"]=>48, ["対抗形", "lose"]=>35, ["力戦", "win"]=>15, ["相居飛車", "win"]=>15, ["対居飛車", "win"]=>15, ["力戦", "lose"]=>15, ["居飛車", "lose"]=>15, ["相居飛車", "lose"]=>15}
#
# s = Swars::Membership.all
# s = s.joins(:taggings => :tag)
# s = s.joins(:judge)
# s = s.group("tags.name")
# s = s.group("judges.key")
# s.count

# >>   Swars::Membership Load (0.4ms)  SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` = 1 AND `swars_battles`.`turn_max` >= 14
# >>   Swars::Membership Load (0.2ms)  SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` = 1 AND `swars_battles`.`turn_max` >= 14
# >>   Swars::Membership Load (0.2ms)  SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`id` = 1 AND `swars_battles`.`turn_max` >= 14
