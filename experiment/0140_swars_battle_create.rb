#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

# list = ActiveRecord::Base.connection.tables.sort.flat_map do |table|
#   ActiveRecord::Base.connection.indexes(table).collect do |obj|
#     [:table, :name, :unique, :columns, :lengths, :orders, :opclasses, :where, :type, :using, :comment].inject({}) { |a, e| a.merge(e => obj.send(e)) }
#   end
# end
# tp list

Swars::User.destroy_all
Swars::Battle.destroy_all
Swars.setup

10.times do
  Swars::Battle.create!
end

# user1 = Swars::User.create!
# user2 = Swars::User.create!
# 
# # ActiveSupport::LogSubscriber.colorize_logging = false
# # logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# 
# battle = Swars::Battle.create! do |e|
#   e.csa_seq = [["-7162GI", 599],  ["+2726FU", 597]]
#   e.memberships.build(user: user1, judge_key: :win,  location_key: :black)
#   e.memberships.build(user: user2, judge_key: :lose, location_key: :white)
# end
# 
# # ActiveRecord::Base.logger = logger
# 
# tp battle.memberships
