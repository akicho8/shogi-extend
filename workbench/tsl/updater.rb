require "#{__dir__}/setup"
Tsl.destroy_all
Tsl::Updater.update_for_local(generations: [*28..100], sleep: 1)

# sql
# Tsl::Updater.update_from_web(66, verbose: false, max: 1)
# rows = [
#   # { result_key: "維", start_pos: 1, name: "古賀悠聖",   _mentor: "中田功", age: 18, win: 6,  lose: 12, ox: "oxxoxxxoxxxxooxxxo" },
#   { result_key: "昇", start_pos: 2, name: "服部慎一郎", _mentor: "中田章", age: 20, win: 14, lose: 4,  ox: "ooooooxoxooooxxooo" },
#   # { result_key: "維", start_pos: 3, name: "関矢寛之",   _mentor: "武者野", age: 26, win: 9,  lose: 9,  ox: "xxooooxoxxoxxoxoxo" },
#   # { result_key: "昇", start_pos: 4, name: "谷合廣紀",   _mentor: "中座",   age: 25, win: 14, lose: 4,  ox: "xxoxooooooooooooox" },
#   # { result_key: "維", start_pos: 5, name: "柵木幹太",   _mentor: "増田裕", age: 21, win: 10, lose: 8,  ox: "xoxoxxooxoxooxooxo" },
#   # { result_key: "維", start_pos: 6, name: "荒田敏史",   _mentor: "石田和", age: 26, win: 8,  lose: 10, ox: "xxxxoxoxxxxoooooox" },
#   # { result_key: "維", start_pos: 7, name: "井田明宏",   _mentor: "小林健", age: 22, win: 13, lose: 5,  ox: "ooxooxooxoooxoxooo" },
#   # { result_key: "維", start_pos: 8, name: "伊藤匠",     _mentor: "宮田利", age: 16, win: 9,  lose: 9,  ox: "xooxxooxxxooxxooox" },
#   # { result_key: "維", start_pos: 9, name: "岡部怜央",   _mentor: "加瀬",   age: 20, win: 8,  lose: 10, ox: "xoxxooxoxooxxxoxxo" },
#   # { result_key: "維", start_pos: 10, name: "上野裕寿",  _mentor: "井上",   age: 16, win: 7,  lose: 11, ox: "xooxxoooxxxoxxoxxx" },
#   # { result_key: "維", start_pos: 11, name: "三田敏弘",  _mentor: "中田章", age: 23, win: 9,  lose: 9,  ox: "oxoooxoxooxxxxxoxo" },
#   # { result_key: "維", start_pos: 12, name: "貫島永州",  _mentor: "小林健", age: 21, win: 11, lose: 7,  ox: "ooxoooxooxxoxooxox" },
#   # { result_key: "維", start_pos: 13, name: "山川泰煕",  _mentor: "広瀬",   age: 21, win: 8,  lose: 10, ox: "xoooxxxoxxoxxxxooo" },
#   # { result_key: "維", start_pos: 14, name: "小山直希",  _mentor: "戸辺",   age: 19, win: 13, lose: 5,  ox: "oooxxoxxooooxooooo" },
#   # { result_key: "維", start_pos: 15, name: "岡井良樹",  _mentor: "大野",   age: 24, win: 8,  lose: 10, ox: "oxxxoxoxooxooxxoxx" },
#   # { result_key: "維", start_pos: 16, name: "冨田誠也",  _mentor: "小林健", age: 23, win: 6,  lose: 12, ox: "xxxoxxxxooxxoxoxox" },
#   # { result_key: "維", start_pos: 17, name: "齊藤優希",  _mentor: "深浦",   age: 23, win: 10, lose: 8,  ox: "ooxooxooxxxoxooxxo" },
#   # { result_key: "維", start_pos: 18, name: "徳田拳士",  _mentor: "小林健", age: 21, win: 11, lose: 7,  ox: "xoxooooxoxoxooooxx" },
#   # { result_key: "維", start_pos: 19, name: "横山友紀",  _mentor: "井上",   age: 19, win: 9,  lose: 9,  ox: "xxoxxooooxoxooxxxo" },
#   # { result_key: "維", start_pos: 20, name: "古田龍生",  _mentor: "宮田利", age: 22, win: 6,  lose: 12, ox: "xxoxxxxxxooxoxoxox" },
#   # { result_key: "次", start_pos: 21, name: "西山朋佳",  _mentor: "伊藤博", age: 24, win: 14, lose: 4,  ox: "oxoooooxoooxoxoooo" },
# ]

# Tsl::Updater.test(5, "alice", "維持")
# Tsl::Updater.test(6, "alice", "次点")
# Tsl::Updater.test(7, "alice", "次点")
# Tsl::Updater.test(8, "alice", "昇段")
# Tsl::Updater.update_raw(9, { name: "bob", result_key: "次点" })
tp Tsl::League
tp Tsl::User
tp Tsl::Membership
# >> |----+------------+---------------------------+---------------------------|
# >> | id | generation | created_at                | updated_at                |
# >> |----+------------+---------------------------+---------------------------|
# >> |  5 |          8 | 2025-08-13 19:00:36 +0900 | 2025-08-13 19:00:36 +0900 |
# >> |----+------------+---------------------------+---------------------------|
# >> |----+-------+---------+---------+-------------------+-----------------+-------------------------+----------------------+-------------------+-------------------+----------------+----------------+---------------------------+---------------------------|
# >> | id | name  | min_age | max_age | memberships_count | runner_up_count | promotion_membership_id | promotion_generation | min_membership_id | max_membership_id | min_generation | max_generation | created_at                | updated_at                |
# >> |----+-------+---------+---------+-------------------+-----------------+-------------------------+----------------------+-------------------+-------------------+----------------+----------------+---------------------------+---------------------------|
# >> |  5 | alice |         |         |                 1 |               0 |                       5 |                    8 |                 5 |                 5 |              8 |              8 | 2025-08-13 19:00:36 +0900 | 2025-08-13 19:00:36 +0900 |
# >> |----+-------+---------+---------+-------------------+-----------------+-------------------------+----------------------+-------------------+-------------------+----------------+----------------+---------------------------+---------------------------|
# >> |----+-----------+---------+-----------+-----------+-----+-----+------+----+--------------------------+------------+---------------------------+---------------------------|
# >> | id | league_id | user_id | result_id | start_pos | age | win | lose | ox | previous_runner_up_count | seat_count | created_at                | updated_at                |
# >> |----+-----------+---------+-----------+-----------+-----+-----+------+----+--------------------------+------------+---------------------------+---------------------------|
# >> |  5 |         5 |       5 |         1 |         0 |     |   0 |    0 |    |                        0 |          1 | 2025-08-13 19:00:36 +0900 | 2025-08-13 19:00:36 +0900 |
# >> |----+-----------+---------+-----------+-----------+-----+-----+------+----+--------------------------+------------+---------------------------+---------------------------|
