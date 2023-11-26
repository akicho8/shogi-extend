require File.expand_path('../../../config/environment', __FILE__)

# user = Swars::User.find_by(key: "YamadaTaro") # => #<Swars::User id: 59, user_key: "YamadaTaro", grade_id: 7, last_reception_at: nil, search_logs_count: 0, created_at: "2023-11-24 18:45:09.000000000 +0900", updated_at: "2023-11-24 18:45:10.000000000 +0900", ban_at: nil>
# user.ban!

# user = Swars::User.first
# # user.profile                    # => #<Swars::Profile id: 1, user_id: 29, ban_at: "2023-11-24 16:02:30.000000000 +0900", ban_crawled_at: "2023-11-24 16:02:30.000000000 +0900", ban_crawled_count: 3, created_at: "2023-11-24 15:35:38.000000000 +0900", updated_at: "2023-11-24 16:02:30.000000000 +0900">
# # # user.build_profile              # => #<Swars::Profile id: nil, user_id: 29, ban_at: nil, ban_crawled_at: nil, ban_crawled_count: nil, created_at: nil, updated_at: nil>
# # user.save!
# user.ban!

# Swars::Battle.ban_record_except.count # => 30
# Swars::Battle.ban_record_only.count   # => 1
# Swars::Battle.count                   # => 31
#
# Swars::User.where.missing(:profile).find_each(&:save!)
# Swars::User.where.missing(:profile).count # => 0
#
# tp Swars::User
# tp Swars::Profile
# battle Swars::Battle.first

# Swars::User.ban_crawl_scope(ban_crawled_count_lteq: 10).count # => 0
# Swars::User.ban_crawled_count_lteq(0).count # => 9

# ActiveSupport::LogSubscriber.colorize_logging = false
# logger = ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# 
# Swars::User.where(latest_battled_at: nil).find_each { |e| e.update!(latest_battled_at: user.memberships.joins(:battle).maximum(Swars::Battle.arel_table[:battled_at])) }

tp Swars::User

# Swars::User.where(Swars::User.arel_table[:latest_battled_at].gt(Swars::Profile.arel_table[:ban_crawled_at]))




# tp Swars::User
# tp Swars::Profile
# tp Swars::User.ban_crawl_scope

# user = Swars::User.first
# my = user.memberships
# user.key                        # => "tosssy"
# 
# ActiveSupport::LogSubscriber.colorize_logging = false
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
# 
# user.op_users.collect(&:key)    # => ["muaqua2023"]
# user.op_users.ban_only          # => #<ActiveRecord::AssociationRelation []>

# op = user.op_memberships
# m = op.where(user: Swars::User.ban_only)
# m.pluck(:battle_id)             # => []

# >> |----+------------+----------+---------------------------+-------------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | user_key   | grade_id | last_reception_at         | search_logs_count | created_at                | updated_at                | ban_at                    | latest_battled_at         |
# >> |----+------------+----------+---------------------------+-------------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | 29 | tosssy     |       40 | 2023-11-25 10:46:35 +0900 |                28 | 2023-11-23 19:22:16 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2023-11-01 20:41:03 +0900 |
# >> | 30 | muaqua2023 |        2 | 2023-11-24 21:29:49 +0900 |                 6 | 2023-11-23 19:22:16 +0900 | 2023-11-25 20:48:13 +0900 | 2023-11-25 20:48:13 +0900 | 2023-11-01 20:41:03 +0900 |
# >> | 31 | SuperBeber |       40 |                           |                 0 | 2023-11-23 19:22:16 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2023-10-29 16:42:45 +0900 |
# >> | 32 | aotamaaaa  |       40 |                           |                 0 | 2023-11-23 19:22:16 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2023-10-29 16:31:03 +0900 |
# >> | 33 | 70gogo     |       40 |                           |                 0 | 2023-11-23 19:22:17 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2023-10-29 16:16:55 +0900 |
# >> | 58 | DevUser1   |       40 |                           |                 0 | 2023-11-24 18:45:09 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2020-01-01 12:34:01 +0900 |
# >> | 59 | YamadaTaro |        7 | 2023-11-25 10:25:27 +0900 |                 2 | 2023-11-24 18:45:09 +0900 | 2023-11-25 20:48:13 +0900 | 2023-11-25 20:48:13 +0900 | 2020-01-01 12:34:03 +0900 |
# >> | 60 | DevUser2   |       40 |                           |                 0 | 2023-11-24 18:45:10 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2020-01-01 12:34:02 +0900 |
# >> | 61 | DevUser3   |       40 |                           |                 0 | 2023-11-24 18:45:10 +0900 | 2023-11-25 20:39:36 +0900 |                           | 2020-01-01 12:34:03 +0900 |
# >> |----+------------+----------+---------------------------+-------------------+---------------------------+---------------------------+---------------------------+---------------------------|
