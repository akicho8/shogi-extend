require "#{__dir__}/setup"
Ppl.setup_for_workbench

# ネット → DB
# Ppl::Updater.resume_crawling

# ネット → JSON生成
season_key_vo = Ppl::SeasonKeyVo.start
all = []
begin
  loop do
    p season_key_vo
    all << season_key_vo.records
    season_key_vo = season_key_vo.succ
  end
rescue OpenURI::HTTPError
end
Pathname("all.json").write(all.to_json)

# JSON → DB
all = JSON.parse(Pathname("all.json").read, symbolize_names: true)
season_key_vo = Ppl::SeasonKeyVo.start
all.each do |rows|
  p season_key_vo
  Ppl::Updater.update_raw(season_key_vo, rows)
  season_key_vo = season_key_vo.succ
end

# rows = Ppl::AntiquitySpider.new("S49", take_size: nil, verbose: false, sleep: 0, mock: true).call
# Ppl::Updater.update_raw("S49", rows)

# Ppl::Updater.resume_crawling(season_key_begin: "S62", limit: 2)
# Ppl::Updater.resume_crawling(season_key_begin: "30",  limit: 2)
# Ppl::Updater.resume_crawling(season_key_begin: "S49", limit: 2)

# Ppl::Updater.latest_key         # => "S49"
# exit
#
# Ppl::Updater.update_raw("1", { name: "A" })
# Ppl::Updater.update_raw("2", { name: "B" })
# tp Ppl::Season
# tp Ppl::User
# tp Ppl::Membership
# >> |-------+--------------------------------------------------------------------------------|
# >> |  担当 | Ppl::AntiquitySpider                                                           |
# >> |    期 | S49                                                                            |
# >> |   URL | https://www.ne.jp/asahi/yaston/shogi/syoreikai/iitoko/seiseki/49nendo_3dan.htm |
# >> | sleep | 0.5                                                                            |
# >> |-------+--------------------------------------------------------------------------------|
# >> |------------+------------+--------+-----+-----------------------------------------------------------+-----+------|
# >> | result_key | name       | mentor | age | ox                                                        | win | lose |
# >> |------------+------------+--------+-----+-----------------------------------------------------------+-----+------|
# >> | 維         | 伊藤果     | 高柳   |  24 | xoxxooooxxxxxooxooxoooxxooxxxxoxxxxxooxxoxoooxooxooxxxxoo |     |      |
# >> | 維         | 鈴木英春   | 坂口   |  24 | xxoxxxxxxxxxxxxxooooxoxoxoooooxxoxoxxoxxxxoxoooxooxxooox  |     |      |
# >> | 昇         | 椎橋金司   | 松下   |  25 | xxooxoooxxoooxoooo                                        |  12 |    4 |
# >> | 維         | 菊地常夫   | 広津   |  25 | xxooxxooxxoxoxxooxxxxxxoooxxxooxoxxoxxoooxxooxxoxoxooxoxo |     |      |
# >> | 維         | 沼春雄     | 佐瀬   |  26 | ooxoxooxxoxoxxoxxoxxoxooxxxxxoooooxxoooxxooxxoooxxoxoxoxx |     |      |
# >> | 昇         | 飯野健二   | 関根   |  20 | ooxooxxxoxxoooxoxxxxoxoxxxxxoxxoooxoxoooooxxxoooooo       |  12 |    4 |
# >> | 維         | 武市三郎   | 丸田   |  21 | xoxxxoxxoooxxxxoxoxxxxxxoooxxoxoooxxxxxxoxoxxxxxoxxxxxox  |     |      |
# >> | 維         | 桐谷広人   | 升田   |  25 | oxxxooxooooxooxxxxoxoooxxxxoooxooxxooxooxxxxoooxxxoooxxo  |     |      |
# >> | 維         | 有野芳人   | 下平   |  26 | oxoxoxoxooooxooxxxooxooooxxooxxxxxooxxxooxoxoxxooxooxx    |     |      |
# >> | 維         | 土佐浩司   | 清野   |  20 | xoooxxxoooxoooxooxoxoxxoxoxxxxxxxo                        |     |      |
# >> | 維         | 松浦隆一   | 丸田   |  23 | oxoooxoxoxxoxoooxxoooooxxxxooxxooo                        |     |      |
# >> | 維         | 武者野勝巳 | 花村   |  21 | xox                                                       |     |      |
# >> | 維         | 酒井順吉   | 藤内   |  24 | xxxxxoxoxoxoxxoxxoxxxxoxxooxxooxxxxxoxoxxooxooooxoxxxooxo |     |      |
# >> | 維         | 青木清     | 熊谷   |  26 | xxoooxoxxxxoxxoxoxoooxxxxoxxoxxooxxxxoxoxoxxxoxxxoo       |     |      |
# >> | 維         | 板橋等     | 板谷   |  26 | oooxxxxxoxxoxoxxoxxxooxxxoooxxoxox                        |     |      |
# >> | 維         | 中田章道   | 富山   |  23 | xooxxxxxooxxxoxoooxxoooxxxxxxooxxooooxooxoxxoooooxooox    |     |      |
# >> | 昇         | 前田祐司   | 賀集   |  20 | oxxooooooxoooxoo                                          |  12 |    4 |
# >> |------------+------------+--------+-----+-----------------------------------------------------------+-----+------|
# >> |-------+--------------------------------------------------------------------------------|
# >> |  担当 | Ppl::AntiquitySpider                                                           |
# >> |    期 | S50                                                                            |
# >> |   URL | https://www.ne.jp/asahi/yaston/shogi/syoreikai/iitoko/seiseki/50nendo_3dan.htm |
# >> | sleep | 0.5                                                                            |
# >> |-------+--------------------------------------------------------------------------------|
# >> |------------+------------+--------+-----+-----+------+--------------------------------------------------------------------------|
# >> | result_key | name       | mentor | age | win | lose | ox                                                                       |
# >> |------------+------------+--------+-----+-----+------+--------------------------------------------------------------------------|
# >> | 昇         | 伊藤果     | 高柳   |  24 |  12 |    4 | xooxxoooooooxo                                                           |
# >> | 維         | 鈴木英春   | 坂口   |  25 |     |      | xoxxxxxoxooxxxxxxxxoxxooxxooxxxoooxxooxoooxxxoooxooxxoooxoooxxxxxxoxxxox |
# >> | 昇         | 菊地常夫   | 広津   |  26 |  12 |    3 | xxoxooooooxoxoooo                                                        |
# >> | 昇         | 沼春雄     | 佐瀬   |  26 |  12 |    4 | xoooxxxxoxooooxxooooooxxoo                                               |
# >> | 維         | 武市三郎   | 丸田   |  22 |     |      | ooxxxxoxxxxoxxooxooxoxxooxooxoxxxooxooxooooxoxxoxoxxxxoxxoxoxoxoxxooxox  |
# >> | 昇         | 桐谷広人   | 升田   |  25 |  12 |    4 | oxoxoxoxoooooxoxxxoooooo                                                 |
# >> | 維         | 有野芳人   | 下平   |  27 |     |      | xooxxxxooxxoxoxxxxxooxooxoxxxxxoooooooo                                  |
# >> | 昇         | 土佐浩司   | 清野   |  20 |  12 |    4 | oxooooxxxxxxoooxooxooxoxxxooxoxxxooxxoxoxoxxooxoxoooooxxooxoooo          |
# >> | 維         | 松浦隆一   | 丸田   |  24 |     |      | ooxxxooooxxxoxooxxoxoxxxxoxooxooooxoxxoxxxxxoxxxxoxooooxxxoooooooxxxoxxo |
# >> | 維         | 武者野勝巳 | 花村   |  22 |     |      | oxxoxoxoxxxxxxxxooxoxxoxxoxxooxoxooxxoxoxoxxxxoxxxoxooxooxxoooxxxoooxxxx |
# >> | 維         | 大島映二   | 高柳   |  18 |     |      | xoxxxoxxxoooxxxxoxxoxx                                                   |
# >> | 維         | 田中寅彦   | 高柳   |  18 |     |      | xooooo                                                                   |
# >> | 昇         | 酒井順吉   | 藤内   |  25 |  12 |    4 | xxxoxxoxxoxoxoooxooxoxooooxxoxoxoxoooooxxxooxxxoxxxoooxxooooxoxxooxooooo |
# >> | 維         | 青木清     | 熊谷   |  27 |     |      | oxoxxxxxoxooxoxxxxoxxooxxxxxxxooxxxoxooxoxxxxxxoxooooxxooooxooxxxx       |
# >> | 維         | 板橋等     | 板谷   |  27 |     |      | xoxxoxxxxoooxxxxxx                                                       |
# >> | 維         | 中田章道   | 富山   |  24 |     |      | xxxoooxooxxxxxoooxxoxxxxxxxoooooooxxoxxoxoxoxooxoxoxooxoxxoxxxxoooxooxx  |
# >> | 維         | 東和男     | 高島   |  21 |     |      | oooxooxxxooxxxxooxoxxxxoooooxxxooooxoxxxxxxxxxxxoxxxooxxo                |
# >> | 維         | 森信雄     | 南口   |  25 |     |      | xooxxxooxoxxxoxxxoxxxxxoxoxxxooxxoooxxxooooooxoo                         |
# >> | 維         | 小林健二   | 板谷   |  18 |     |      | xxxooxxxxxooxxoxoooooooo                                                 |
# >> | 維         | 児玉孝一   | 岡崎   |  25 |     |      | xoxxxxxoo                                                                |
# >> |------------+------------+--------+-----+-----+------+--------------------------------------------------------------------------|
# >> |----+-----+----------+---------------------------+---------------------------|
# >> | id | key | position | created_at                | updated_at                |
# >> |----+-----+----------+---------------------------+---------------------------|
# >> |  1 | S49 |        0 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  2 | S50 |        1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |----+-----+----------+---------------------------+---------------------------|
# >> |----+---------+-----------+------------+---------+---------+-----------------+---------+-----------+-------------------------+---------------+---------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> | id | rank_id | mentor_id | name       | age_min | age_max | runner_up_count | win_max | win_ratio | promotion_membership_id | promotion_win | promotion_season_position | memberships_first_id | memberships_last_id | deactivated_membership_id | memberships_count | created_at                | updated_at                |
# >> |----+---------+-----------+------------+---------+---------+-----------------+---------+-----------+-------------------------+---------------+---------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> |  1 |       1 |         1 | 伊藤果     |      24 |      24 |                 |      12 |  0.521127 |                      18 |            12 |                         1 |                    1 |                  18 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  2 |       3 |         2 | 鈴木英春   |      24 |      25 |                 |         |  0.421875 |                         |               |                           |                    2 |                  19 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  3 |       1 |         3 | 椎橋金司   |      25 |      25 |                 |      12 |  0.666667 |                       3 |            12 |                         0 |                    3 |                   3 |                         3 |                 1 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  4 |       1 |         4 | 菊地常夫   |      25 |      26 |                 |      12 |  0.513514 |                      20 |            12 |                         1 |                    4 |                  20 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  5 |       1 |         5 | 沼春雄     |      26 |      26 |                 |      12 |   0.53012 |                      21 |            12 |                         1 |                    5 |                  21 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  6 |       1 |         6 | 飯野健二   |      20 |      20 |                 |      12 |  0.529412 |                       6 |            12 |                         0 |                    6 |                   6 |                         6 |                 1 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  7 |       3 |         7 | 武市三郎   |      21 |      22 |                 |         |  0.401575 |                         |               |                           |                    7 |                  22 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  8 |       1 |         8 | 桐谷広人   |      25 |      25 |                 |      12 |    0.5625 |                      23 |            12 |                         1 |                    8 |                  23 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |  9 |       3 |         9 | 有野芳人   |      26 |      27 |                 |         |  0.505376 |                         |               |                           |                    9 |                  24 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 10 |       1 |        10 | 土佐浩司   |      20 |      20 |                 |      12 |  0.525773 |                      25 |            12 |                         1 |                   10 |                  25 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:19 +0900 |
# >> | 11 |       3 |         7 | 松浦隆一   |      23 |      24 |                 |         |  0.518868 |                         |               |                           |                   11 |                  26 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 12 |       3 |        11 | 武者野勝巳 |      21 |      22 |                 |         |       0.4 |                         |               |                           |                   12 |                  27 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 13 |       1 |        12 | 酒井順吉   |      24 |      25 |                 |      12 |  0.488372 |                      30 |            12 |                         1 |                   13 |                  30 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:19 +0900 |
# >> | 14 |       3 |        13 | 青木清     |      26 |      27 |                 |         |  0.393162 |                         |               |                           |                   14 |                  31 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 15 |       3 |        14 | 板橋等     |      26 |      27 |                 |         |  0.365385 |                         |               |                           |                   15 |                  32 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 16 |       3 |        15 | 中田章道   |      23 |      24 |                 |         |     0.488 |                         |               |                           |                   16 |                  33 |                           |                 2 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 17 |       1 |        16 | 前田祐司   |      20 |      20 |                 |      12 |      0.75 |                      17 |            12 |                         0 |                   17 |                  17 |                        17 |                 1 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:19 +0900 |
# >> | 18 |       3 |         1 | 大島映二   |      18 |      18 |                 |         |  0.318182 |                         |               |                           |                   28 |                  28 |                           |                 1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 19 |       3 |         1 | 田中寅彦   |      18 |      18 |                 |         |  0.833333 |                         |               |                           |                   29 |                  29 |                           |                 1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 20 |       3 |        17 | 東和男     |      21 |      21 |                 |         |  0.421053 |                         |               |                           |                   34 |                  34 |                           |                 1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 21 |       3 |        18 | 森信雄     |      25 |      25 |                 |         |  0.458333 |                         |               |                           |                   35 |                  35 |                           |                 1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 22 |       3 |        14 | 小林健二   |      18 |      18 |                 |         |  0.541667 |                         |               |                           |                   36 |                  36 |                           |                 1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 23 |       3 |        19 | 児玉孝一   |      25 |      25 |                 |         |  0.333333 |                         |               |                           |                   37 |                  37 |                           |                 1 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |----+---------+-----------+------------+---------+---------+-----------------+---------+-----------+-------------------------+---------------+---------------------------+----------------------+---------------------+---------------------------+-------------------+---------------------------+---------------------------|
# >> |----+-----------+---------+-----------+-----+-----+------+--------------------------------------------------------------------------+---------------------------+---------------------------|
# >> | id | season_id | user_id | result_id | age | win | lose | ox                                                                       | created_at                | updated_at                |
# >> |----+-----------+---------+-----------+-----+-----+------+--------------------------------------------------------------------------+---------------------------+---------------------------|
# >> |  1 |         1 |       1 |         4 |  24 |     |      | xoxxooooxxxxxooxooxoooxxooxxxxoxxxxxooxxoxoooxooxooxxxxoo                | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  2 |         1 |       2 |         4 |  24 |     |      | xxoxxxxxxxxxxxxxooooxoxoxoooooxxoxoxxoxxxxoxoooxooxxooox                 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  3 |         1 |       3 |         1 |  25 |  12 |    4 | xxooxoooxxoooxoooo                                                       | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  4 |         1 |       4 |         4 |  25 |     |      | xxooxxooxxoxoxxooxxxxxxoooxxxooxoxxoxxoooxxooxxoxoxooxoxo                | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  5 |         1 |       5 |         4 |  26 |     |      | ooxoxooxxoxoxxoxxoxxoxooxxxxxoooooxxoooxxooxxoooxxoxoxoxx                | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  6 |         1 |       6 |         1 |  20 |  12 |    4 | ooxooxxxoxxoooxoxxxxoxoxxxxxoxxoooxoxoooooxxxoooooo                      | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  7 |         1 |       7 |         4 |  21 |     |      | xoxxxoxxoooxxxxoxoxxxxxxoooxxoxoooxxxxxxoxoxxxxxoxxxxxox                 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  8 |         1 |       8 |         4 |  25 |     |      | oxxxooxooooxooxxxxoxoooxxxxoooxooxxooxooxxxxoooxxxoooxxo                 | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> |  9 |         1 |       9 |         4 |  26 |     |      | oxoxoxoxooooxooxxxooxooooxxooxxxxxooxxxooxoxoxxooxooxx                   | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 10 |         1 |      10 |         4 |  20 |     |      | xoooxxxoooxoooxooxoxoxxoxoxxxxxxxo                                       | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 11 |         1 |      11 |         4 |  23 |     |      | oxoooxoxoxxoxoooxxoooooxxxxooxxooo                                       | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 12 |         1 |      12 |         4 |  21 |     |      | xox                                                                      | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 13 |         1 |      13 |         4 |  24 |     |      | xxxxxoxoxoxoxxoxxoxxxxoxxooxxooxxxxxoxoxxooxooooxoxxxooxo                | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 14 |         1 |      14 |         4 |  26 |     |      | xxoooxoxxxxoxxoxoxoooxxxxoxxoxxooxxxxoxoxoxxxoxxxoo                      | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 15 |         1 |      15 |         4 |  26 |     |      | oooxxxxxoxxoxoxxoxxxooxxxoooxxoxox                                       | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 16 |         1 |      16 |         4 |  23 |     |      | xooxxxxxooxxxoxoooxxoooxxxxxxooxxooooxooxoxxoooooxooox                   | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 17 |         1 |      17 |         1 |  20 |  12 |    4 | oxxooooooxoooxoo                                                         | 2025-08-23 20:36:17 +0900 | 2025-08-23 20:36:17 +0900 |
# >> | 18 |         2 |       1 |         1 |  24 |  12 |    4 | xooxxoooooooxo                                                           | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 19 |         2 |       2 |         4 |  25 |     |      | xoxxxxxoxooxxxxxxxxoxxooxxooxxxoooxxooxoooxxxoooxooxxoooxoooxxxxxxoxxxox | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 20 |         2 |       4 |         1 |  26 |  12 |    3 | xxoxooooooxoxoooo                                                        | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 21 |         2 |       5 |         1 |  26 |  12 |    4 | xoooxxxxoxooooxxooooooxxoo                                               | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 22 |         2 |       7 |         4 |  22 |     |      | ooxxxxoxxxxoxxooxooxoxxooxooxoxxxooxooxooooxoxxoxoxxxxoxxoxoxoxoxxooxox  | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 23 |         2 |       8 |         1 |  25 |  12 |    4 | oxoxoxoxoooooxoxxxoooooo                                                 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 24 |         2 |       9 |         4 |  27 |     |      | xooxxxxooxxoxoxxxxxooxooxoxxxxxoooooooo                                  | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 25 |         2 |      10 |         1 |  20 |  12 |    4 | oxooooxxxxxxoooxooxooxoxxxooxoxxxooxxoxoxoxxooxoxoooooxxooxoooo          | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 26 |         2 |      11 |         4 |  24 |     |      | ooxxxooooxxxoxooxxoxoxxxxoxooxooooxoxxoxxxxxoxxxxoxooooxxxoooooooxxxoxxo | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 27 |         2 |      12 |         4 |  22 |     |      | oxxoxoxoxxxxxxxxooxoxxoxxoxxooxoxooxxoxoxoxxxxoxxxoxooxooxxoooxxxoooxxxx | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 28 |         2 |      18 |         4 |  18 |     |      | xoxxxoxxxoooxxxxoxxoxx                                                   | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 29 |         2 |      19 |         4 |  18 |     |      | xooooo                                                                   | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 30 |         2 |      13 |         1 |  25 |  12 |    4 | xxxoxxoxxoxoxoooxooxoxooooxxoxoxoxoooooxxxooxxxoxxxoooxxooooxoxxooxooooo | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 31 |         2 |      14 |         4 |  27 |     |      | oxoxxxxxoxooxoxxxxoxxooxxxxxxxooxxxoxooxoxxxxxxoxooooxxooooxooxxxx       | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 32 |         2 |      15 |         4 |  27 |     |      | xoxxoxxxxoooxxxxxx                                                       | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 33 |         2 |      16 |         4 |  24 |     |      | xxxoooxooxxxxxoooxxoxxxxxxxoooooooxxoxxoxoxoxooxoxoxooxoxxoxxxxoooxooxx  | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 34 |         2 |      20 |         4 |  21 |     |      | oooxooxxxooxxxxooxoxxxxoooooxxxooooxoxxxxxxxxxxxoxxxooxxo                | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 35 |         2 |      21 |         4 |  25 |     |      | xooxxxooxoxxxoxxxoxxxxxoxoxxxooxxoooxxxooooooxoo                         | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 36 |         2 |      22 |         4 |  18 |     |      | xxxooxxxxxooxxoxoooooooo                                                 | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> | 37 |         2 |      23 |         4 |  25 |     |      | xoxxxxxoo                                                                | 2025-08-23 20:36:18 +0900 | 2025-08-23 20:36:18 +0900 |
# >> |----+-----------+---------+-----------+-----+-----+------+--------------------------------------------------------------------------+---------------------------+---------------------------|
