#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::User.destroy_all
Swars::Battle.destroy_all

user1 = Swars::User.create!
user2 = Swars::User.create!
100.times do
  battle = Swars::Battle.new
  battle.memberships.build(user: user1)
  battle.memberships.build(user: user2)
  battle.save!
end

Swars::Battle.all.each do |e|
  p e.kifu_body.lines.grep(/START_TIME/)
end

exit


p Swars::Battle.count             # => 2529

user = Swars::User.first

s1 = user.memberships
s1 = s1.joins(:battle)
s1 = s1.where(Swars::Battle.arel_table[:win_user_id].not_eq(nil)) # 勝敗が必ずあるもの
s1 = s1.order(Swars::Battle.arel_table[:battled_at].desc)         # 直近のものから取得
s1 = s1.includes(:battle)
s1 = s1.limit(50)

s2 = user.memberships.where(id: s1.pluck(:id))

require 'active_support/core_ext/benchmark'

f = -> s { s.all_tag_counts(at_least: 1, order: "count desc") }
f.(s1)                           # => #<ActiveRecord::Relation [#<ActsAsTaggableOn::Tag id: 6, name: "居飛車", taggings_count: 5058>, #<ActsAsTaggableOn::Tag id: 29, name: "居玉", taggings_count: 7587>, #<ActsAsTaggableOn::Tag id: 115, name: "嬉野流", taggings_count: 5058>]>
f.(s2)                           # => #<ActiveRecord::Relation [#<ActsAsTaggableOn::Tag id: 6, name: "居飛車", taggings_count: 5058>, #<ActsAsTaggableOn::Tag id: 29, name: "居玉", taggings_count: 7587>, #<ActsAsTaggableOn::Tag id: 115, name: "嬉野流", taggings_count: 5058>]>

require "active_support/core_ext/benchmark"
def _; "%7.2f ms" % Benchmark.ms { 2000.times { yield } } end
p _ { f.(s1) } # => "4051.89 ms"
p _ { f.(s2) } # => "3771.33 ms"
# >> 2529
# >> "4051.89 ms"
# >> "3771.33 ms"
