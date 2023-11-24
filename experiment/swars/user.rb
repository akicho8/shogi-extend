require File.expand_path('../../../config/environment', __FILE__)

user = Swars::User.first

# user.profile                    # => #<Swars::Profile id: 1, user_id: 29, ban_at: "2023-11-24 16:02:30.000000000 +0900", ban_crowled_at: "2023-11-24 16:02:30.000000000 +0900", ban_crowl_count: 3, created_at: "2023-11-24 15:35:38.000000000 +0900", updated_at: "2023-11-24 16:02:30.000000000 +0900">
# # user.build_profile              # => #<Swars::Profile id: nil, user_id: 29, ban_at: nil, ban_crowled_at: nil, ban_crowl_count: nil, created_at: nil, updated_at: nil>
# user.save!
user.ban!

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

tp Swars::User

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

# >> |----+------------+----------+---------------------------+-------------------+---------------------------+---------------------------+---------------------------|
# >> | id | user_key   | grade_id | last_reception_at         | search_logs_count | created_at                | updated_at                | ban_at                    |
# >> |----+------------+----------+---------------------------+-------------------+---------------------------+---------------------------+---------------------------|
# >> | 29 | tosssy     |       40 | 2023-11-24 21:08:28 +0900 |                27 | 2023-11-23 19:22:16 +0900 | 2023-11-24 21:08:50 +0900 | 2023-11-24 21:08:50 +0900 |
# >> | 30 | muaqua2023 |        2 |                           |                 0 | 2023-11-23 19:22:16 +0900 | 2023-11-24 16:26:03 +0900 |                           |
# >> | 31 | SuperBeber |       40 |                           |                 0 | 2023-11-23 19:22:16 +0900 | 2023-11-23 21:16:28 +0900 |                           |
# >> | 32 | aotamaaaa  |       40 |                           |                 0 | 2023-11-23 19:22:16 +0900 | 2023-11-23 21:16:28 +0900 |                           |
# >> | 33 | 70gogo     |       40 |                           |                 0 | 2023-11-23 19:22:17 +0900 | 2023-11-23 21:16:28 +0900 |                           |
# >> | 58 | DevUser1   |       40 |                           |                 0 | 2023-11-24 18:45:09 +0900 | 2023-11-24 18:45:10 +0900 |                           |
# >> | 59 | YamadaTaro |        7 |                           |                 0 | 2023-11-24 18:45:09 +0900 | 2023-11-24 18:45:10 +0900 |                           |
# >> | 60 | DevUser2   |       40 |                           |                 0 | 2023-11-24 18:45:10 +0900 | 2023-11-24 18:45:10 +0900 |                           |
# >> | 61 | DevUser3   |       40 |                           |                 0 | 2023-11-24 18:45:10 +0900 | 2023-11-24 18:45:10 +0900 |                           |
# >> |----+------------+----------+---------------------------+-------------------+---------------------------+---------------------------+---------------------------|
