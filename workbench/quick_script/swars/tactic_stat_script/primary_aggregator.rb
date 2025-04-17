require "./setup"

scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
# p _ { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call } # => "67.60 ms"
# tp QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call
# pp QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).aggregate[:term_none]
# tp QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call[:period_based_agg][:term_none]
hv = QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call
tp hv[:period_based_agg].keys
tp hv[:period_based_agg][:term_none]

# Swars::Membership.joins(:battle => :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良")).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_xmodes`.`key` = '野良'"
# Swars::Membership.joins(:battle => :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良")).count # => 3476368

# s = s.where(xmode: ::Swars::Xmode.arel_table[:key].eq(:"野良"))

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

# >> [2025-04-17 21:07:18][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> [2025-04-17 21:07:18][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> [2025-04-17 21:07:18][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> [2025-04-17 21:07:18][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> [2025-04-17 21:07:18][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> [2025-04-17 21:07:18][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> |-------|
# >> | day1  |
# >> | day3  |
# >> | day7  |
# >> | day30 |
# >> | day60 |
# >> | year1 |
# >> |-------|
