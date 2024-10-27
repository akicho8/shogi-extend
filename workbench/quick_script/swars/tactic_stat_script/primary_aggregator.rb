require "./setup"

# Swars::Membership.joins(:battle => :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良")).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` INNER JOIN `swars_xmodes` ON `swars_xmodes`.`id` = `swars_battles`.`xmode_id` WHERE `swars_xmodes`.`key` = '野良'"
# Swars::Membership.joins(:battle => :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良")).count # => 3476368

# s = s.where(xmode: ::Swars::Xmode.arel_table[:key].eq(:"野良"))

scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
p _ { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new(scope: scope).call } # => "55.90 ms"
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

# >> [2024-10-27 19:08:39][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> "55.90 ms"
# >> [2024-10-27 19:08:39][QuickScript::Swars::TacticStatScript::PrimaryAggregator] Processing relation #0
# >> |----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                    records | [{:tag_name=>"三間飛車", :win_count=>8, :win_ratio=>0.6153846153846154, :lose_count=>5, :draw_count=>0, :freq_count=>13, :win_lose_count=>13, :freq_ratio=>0.1326530612244898}, {:tag_name=>"角交換振り飛車", :win_count=>3, :win_ratio=>0.75, :lose_count=>1, :draw_count=... |
# >> |           population_count | 98                                                                                                                                                                                                                                                                             |
# >> |      primary_aggregated_at | 2024-10-27 19:08:39 +0900                                                                                                                                                                                                                                                      |
# >> | primary_aggregation_second | 0.013133999891579151                                                                                                                                                                                                                                                           |
# >> |----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
