#!/usr/bin/env ruby
require File.expand_path('../../../../config/environment', __FILE__)
# tp Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_list.time_stats

# s = Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_list.new_scope
# s.joins(:battle => :final).where(Swars::Final.arel_table[:key].eq("DRAW_SENNICHI")).count  # => 50
#
# s = Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_list.new_scope
# s.joins(:battle).where(Swars::Battle.arel_table[:final_id].eq(Swars::Final["DRAW_SENNICHI"])).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 AND `swars_battles`.`final_id` = NULL ORDER BY `swars_battles`.`battled_at` DESC LIMIT 50"
#
# s = Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_list.new_scope
# s.joins(:battle).where(Swars::Battle.arel_table[:final_id].eq(Swars::Final["DRAW_SENNICHI"].id)).count

user = Swars::User.find_by!(user_key: "SugarHuuko")
user.memberships.joins(:battle).merge(Swars::Battle.where(win_user_id: nil)).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 AND `swars_battles`.`win_user_id` IS NULL"

user = Swars::User.find_by!(user_key: "SugarHuuko")
user.memberships.joins(:battle).merge(Swars::Battle.where(win_user_id: nil)).to_sql # => "SELECT `swars_memberships`.* FROM `swars_memberships` INNER JOIN `swars_battles` ON `swars_battles`.`id` = `swars_memberships`.`battle_id` WHERE `swars_memberships`.`user_id` = 17413 AND `swars_battles`.`win_user_id` IS NULL"

Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_list.start_draw_ratio # => 0.18
Swars::User.find_by!(user_key: "SugarHuuko").user_info.medal_list.draw_ratio       # => 0.14
