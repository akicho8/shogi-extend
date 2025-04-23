require "./setup"
scope = Swars::Membership.where(id: Swars::Membership.last(100).collect(&:id))
QuickScript::Swars::TacticJudgeAggregator.new(scope: scope).cache_write
tp QuickScript::Swars::TacticStatScript.new({scope_key: :attack}).aggregate
# >> [2025-04-22 19:11:10][QuickScript::Swars::TacticJudgeAggregator][1週間] Processing relation #0/1
# >> [2025-04-22 19:11:10][QuickScript::Swars::TacticJudgeAggregator][1ヶ月] Processing relation #0/1
# >> [2025-04-22 19:11:10][QuickScript::Swars::TacticJudgeAggregator][2ヶ月] Processing relation #0/1
# >> 2025-04-22T10:11:10.582Z pid=17351 tid=enj INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |  day7 | {records: [], memberships_count: 0, win_lose_draw_total: 0}                                                                                                                                                                                                             |
# >> | day30 | {records: [], memberships_count: 0, win_lose_draw_total: 0}                                                                                                                                                                                                             |
# >> | day60 | {records: [{tag_name: "力戦", win_count: 7, win_ratio: 0.5833333333333334, draw_count: 0, freq_count: 12, freq_ratio: 0.02197802197802198, lose_count: 5}, {tag_name: "居玉", win_count: 6, win_ratio: 0.4615384615384616, draw_count: 0, freq_count: 13, freq_ratio... |
# >> |-------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
