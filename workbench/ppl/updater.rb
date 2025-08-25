require "#{__dir__}/setup"
Ppl.setup_for_workbench

# ネット → DB
# Ppl::Updater.resume_crawling

# ネット → JSON生成
# Ppl::Updater.json_write


# JSON → DB
Ppl::Updater.import_from_json

Ppl::Season.count               # => 1
Ppl::User.count                 # => 17
Ppl::Membership.count           # => 17
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
