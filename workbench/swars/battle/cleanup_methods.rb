require "./setup"

# Rails.application.credentials[:battle_cleanup_except_users]

# Swars::Battle.user_only(Rails.application.credentials[:battle_cleanup_except_users]).count # => 99513

# Swars::Battle.limit(5).cleanup1(verbose: true)
# Swars::Battle.limit(2500).cleanup2(verbose: true)
# Swars::Battle.limit(10).joins(memberships: :user).merge(Swars::User.where.not(user_key: ["kinakom0chi", "SugarHuuko"])).count # => 10

# sql
# Swars::Battle.ban_only.count # => 4620

sql
# Swars::Battle.joins(:memberships => :user).merge(Swars::User.ban_only).count # => 4641
# Swars::Battle.where(id: Swars::Battle.joins(:memberships => :user).merge(Swars::User.ban_only)).count # => 4620

# Swars::Battle.ban_only2.count    # => 4620
# Swars::Battle.ban_except2.count  # => 1672162

Swars::Battle.user_only(["kinakom0chi"]).count    # => 4
Swars::Battle.user_only2(["kinakom0chi"]).count    # => 4

# Swars::Battle.ban_only.count    # => 4620
# Swars::Battle.ban_only2.count   # => 4641
# Swars::Battle.ban_except.count  # => 1672162

# Swars::Battle.where(id: Swars::Battle.joins(:memberships).where(user: Swars::User.ban_only)).count # =>

# Swars::Battle.count                                                                                           # => 1672183
# Swars::Battle.includes(:memberships).merge(Swars::Membership.where(user: Swars::User.ban_only)).distinct.count   # =>
# Swars::Battle.eager_load(:memberships).merge(Swars::Membership.where(user: Swars::User.ban_except)).count # => 1672162

# ActiveRecord::Base.logger = nil
# battles = Swars::Battle.joins(memberships: :user).merge(Swars::User.ban_only).includes(:memberships).to_a
# battles.each do |e|
#   if e.memberships.all? { |e| e.user.ban_at }
#     p e.id
#   end
# end
#
# Swars41387528

# Swars::Battle.user_only(["kinakom0chi"]).count # => 4

# _ { Swars::Battle.pro_except.count }  # => "669.79 ms"
# _ { Swars::Grade.fetch("十段").battles.count } # => "121.75 ms"

# >>   Swars::Battle Count (3.0ms)  SELECT COUNT(*) FROM `swars_battles` INNER JOIN `swars_memberships` ON `swars_memberships`.`battle_id` = `swars_battles`.`id` INNER JOIN `swars_users` ON `swars_users`.`id` = `swars_memberships`.`user_id` WHERE `swars_users`.`user_key` = 'kinakom0chi'
# >>   Swars::Battle Count (0.7ms)  SELECT COUNT(DISTINCT `swars_battles`.`id`) FROM `swars_battles` LEFT OUTER JOIN `swars_memberships` ON `swars_memberships`.`battle_id` = `swars_battles`.`id` LEFT OUTER JOIN `swars_users` ON `swars_users`.`id` = `swars_memberships`.`user_id` WHERE `swars_users`.`user_key` = 'kinakom0chi'
