require "#{__dir__}/setup"
# tp Tsl::League.count

sql
scope = Tsl::User.all
scope = scope.includes(:memberships => [:user, :league])
scope = scope.joins(:memberships => [:user, :league])
scope = scope.merge(Tsl::League.where(generation: 71))
tp scope

# user = Tsl::User.first
# tp user.memberships                 # => #<ActiveRecord::Associations::CollectionProxy [#<Tsl::Membership id: 1, league_id: 1, user_id: 1, result_key: "none", start_pos: 1, age: nil, win: 6, lose: 12, ox: "xxoxoxoxxxoxxxoxox", previous_runner_up_count: 0, seat_count: 1, created_at: "2023-12-18 11:52:29.059288000 +0900", updated_at: "2023-12-18 11:52:29.059288000 +0900">]>
# scope = Tsl::User.where(name: ["都成竜馬", "徳田拳士"])
# tp scope.first.memberships.collect { |e| e.league.attributes }
# tp scope.first.memberships

# sql
# scope = Tsl::User.where(name: ["都成竜馬", "徳田拳士"])
# scope = scope.includes(:memberships => [:user, :league])
# hv = {}
# scope.each do |user|
#   user.memberships.each do |membership|
#     hv[membership.league.generation] ||= {}
#     hv[membership.league.generation][user.id] = membership
#   end
# end
# tp hv


# >>   SQL (1.3ms)  SELECT `tsl_users`.`id` AS t0_r0, `tsl_users`.`name` AS t0_r1, `tsl_users`.`min_age` AS t0_r2, `tsl_users`.`max_age` AS t0_r3, `tsl_users`.`memberships_count` AS t0_r4, `tsl_users`.`runner_up_count` AS t0_r5, `tsl_users`.`promotion_membership_id` AS t0_r6, `tsl_users`.`created_at` AS t0_r7, `tsl_users`.`updated_at` AS t0_r8, `tsl_memberships`.`id` AS t1_r0, `tsl_memberships`.`league_id` AS t1_r1, `tsl_memberships`.`user_id` AS t1_r2, `tsl_memberships`.`result_key` AS t1_r3, `tsl_memberships`.`start_pos` AS t1_r4, `tsl_memberships`.`age` AS t1_r5, `tsl_memberships`.`win` AS t1_r6, `tsl_memberships`.`lose` AS t1_r7, `tsl_memberships`.`ox` AS t1_r8, `tsl_memberships`.`previous_runner_up_count` AS t1_r9, `tsl_memberships`.`seat_count` AS t1_r10, `tsl_memberships`.`created_at` AS t1_r11, `tsl_memberships`.`updated_at` AS t1_r12, `users_tsl_memberships`.`id` AS t2_r0, `users_tsl_memberships`.`name` AS t2_r1, `users_tsl_memberships`.`min_age` AS t2_r2, `users_tsl_memberships`.`max_age` AS t2_r3, `users_tsl_memberships`.`memberships_count` AS t2_r4, `users_tsl_memberships`.`runner_up_count` AS t2_r5, `users_tsl_memberships`.`promotion_membership_id` AS t2_r6, `users_tsl_memberships`.`created_at` AS t2_r7, `users_tsl_memberships`.`updated_at` AS t2_r8, `tsl_leagues`.`id` AS t3_r0, `tsl_leagues`.`generation` AS t3_r1, `tsl_leagues`.`created_at` AS t3_r2, `tsl_leagues`.`updated_at` AS t3_r3 FROM `tsl_users` INNER JOIN `tsl_memberships` ON `tsl_memberships`.`user_id` = `tsl_users`.`id` INNER JOIN `tsl_users` `users_tsl_memberships` ON `users_tsl_memberships`.`id` = `tsl_memberships`.`user_id` INNER JOIN `tsl_leagues` ON `tsl_leagues`.`id` = `tsl_memberships`.`league_id` WHERE `tsl_leagues`.`generation` = 71 /*application='ShogiWeb'*/
# >> |-----+------------+-----------+----------+-------------------+-----------------+---------------------+---------------------------+---------------------------|
# >> | id  | name       | min_age | max_age | memberships_count | runner_up_count | promotion_membership_id | created_at                | updated_at                |
# >> |-----+------------+-----------+----------+-------------------+-----------------+---------------------+---------------------------+---------------------------|
# >> |  30 | 柵木幹太   |        18 |       24 |                14 |               1 |                  72 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:53 +0900 |
# >> |  35 | 上野裕寿   |        15 |       19 |                10 |               1 |                  73 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:54 +0900 |
# >> |  36 | 三田敏弘   |        17 |       26 |                19 |               1 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:51 +0900 |
# >> |  37 | 貫島永州   |        19 |       25 |                14 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:55 +0900 |
# >> |  38 | 山川泰熙   |        19 |       25 |                13 |               0 |                  74 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:55 +0900 |
# >> |  39 | 小山直希   |        17 |       22 |                11 |               0 |                  72 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:53 +0900 |
# >> |  42 | 斎藤優希   |        21 |       28 |                14 |               1 |                  76 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:58 +0900 |
# >> |  45 | 古田龍生   |        19 |       25 |                13 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:51 +0900 |
# >> |  48 | 中沢良輔   |        20 |       25 |                11 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:55 +0900 |
# >> |  49 | 森本才跳   |        17 |       21 |                 8 |               0 |                  72 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:53 +0900 |
# >> |  50 | 川村悠人   |        18 |       26 |                16 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:59 +0900 |
# >> |  51 | 相川浩治   |        21 |       25 |                 9 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:50 +0900 |
# >> |  52 | 田中大貴   |        20 |       25 |                12 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:57 +0900 |
# >> |  53 | 宮田大暉   |        19 |       25 |                13 |               0 |                     | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:57 +0900 |
# >> |  54 | 宮嶋健太   |        20 |       23 |                 8 |               0 |                  73 | 2023-12-18 11:52:29 +0900 | 2025-08-11 15:56:54 +0900 |
# >> |  56 | 吉田桂悟   |        19 |       24 |                11 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:58 +0900 |
# >> |  60 | 片山史龍   |        15 |       20 |                11 |               1 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:58 +0900 |
# >> |  61 | 斎藤光寿   |        19 |       24 |                11 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:58 +0900 |
# >> |  62 | 高橋佑二郎 |        21 |       24 |                 7 |               0 |                  74 | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:55 +0900 |
# >> |  63 | 関祐人     |        19 |       23 |                10 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:58 +0900 |
# >> |  64 | 岡本詢也   |        18 |       22 |                10 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:57:00 +0900 |
# >> |  65 | 入馬尚輝   |        19 |       24 |                10 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:57:00 +0900 |
# >> |  66 | 熊谷俊紀   |        23 |       25 |                 5 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:51 +0900 |
# >> |  67 | 中七海     |        22 |       25 |                 8 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:56:55 +0900 |
# >> |  68 | 福田晴紀   |        19 |       24 |                10 |               0 |                     | 2023-12-18 11:52:30 +0900 | 2025-08-11 15:57:00 +0900 |
# >> | 184 | 木村友亮   |        20 |       24 |                 9 |               0 |                     | 2025-08-11 15:56:49 +0900 | 2025-08-11 15:56:58 +0900 |
# >> | 185 | 宮原暁月   |        19 |       23 |                 9 |               0 |                     | 2025-08-11 15:56:49 +0900 | 2025-08-11 15:56:58 +0900 |
# >> | 186 | 倉谷将弘   |        25 |       27 |                 5 |               0 |                     | 2025-08-11 15:56:49 +0900 | 2025-08-11 15:56:53 +0900 |
# >> | 187 | 生垣寛人   |        17 |       21 |                 9 |               0 |                     | 2025-08-11 15:56:49 +0900 | 2025-08-11 15:56:58 +0900 |
# >> | 188 | 西山晴大   |        26 |       28 |                 5 |               0 |                     | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:56:55 +0900 |
# >> | 189 | 小窪碧     |        15 |       19 |                 8 |               0 |                     | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:56:59 +0900 |
# >> | 190 | 岩村凛太朗 |        15 |       18 |                 8 |               1 |                     | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:56:58 +0900 |
# >> | 191 | 麻生喜久   |        24 |       26 |                 5 |               0 |                     | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:56:54 +0900 |
# >> | 192 | 藤本渚     |        16 |       16 |                 2 |               0 |                  71 | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:56:51 +0900 |
# >> | 193 | 山城正樹   |        19 |       22 |                 8 |               0 |                     | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:56:58 +0900 |
# >> | 194 | 北村啓太郎 |        17 |       21 |                 8 |               0 |                     | 2025-08-11 15:56:50 +0900 | 2025-08-11 15:57:00 +0900 |
# >> | 195 | 廣森航汰   |        21 |       24 |                 7 |               0 |                     | 2025-08-11 15:56:51 +0900 | 2025-08-11 15:57:00 +0900 |
# >> | 196 | 吉池隆真   |        17 |       19 |                 5 |               0 |                  75 | 2025-08-11 15:56:51 +0900 | 2025-08-11 15:56:57 +0900 |
# >> | 197 | 斎藤裕也   |        24 |       24 |                 1 |               0 |                  71 | 2025-08-11 15:56:51 +0900 | 2025-08-11 15:56:51 +0900 |
# >> | 198 | 清水航     |        24 |       27 |                 6 |               0 |                     | 2025-08-11 15:56:51 +0900 | 2025-08-11 15:56:58 +0900 |
# >> | 199 | 増田晃之郎 |        21 |       24 |                 7 |               0 |                     | 2025-08-11 15:56:51 +0900 | 2025-08-11 15:56:58 +0900 |
# >> |-----+------------+-----------+----------+-------------------+-----------------+---------------------+---------------------------+---------------------------|
