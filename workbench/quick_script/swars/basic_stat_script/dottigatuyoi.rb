require "./setup"
scope = Swars::Membership.where(id: Swars::Membership.last(1000).collect(&:id))
base = QuickScript::Swars::BasicStatScript.new(scope: scope)
# base.cache_all
tp base.dottigatuyoi.call
# >> |----------+----------+--------+--------+------|
# >> | ▲勝率   | △勝率   | ▲勝数 | △勝数 | 分母 |
# >> |----------+----------+--------+--------+------|
# >> | 47.727 % | 52.273 % |     42 |     46 |   88 |
# >> |----------+----------+--------+--------+------|
