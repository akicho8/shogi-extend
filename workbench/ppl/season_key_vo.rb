require "#{__dir__}/setup"

(Ppl::SeasonKeyVo["S61"]..Ppl::SeasonKeyVo["2"]).to_a.collect(&:to_s) # => ["S61", "S62", "1", "2"]

Ppl::SeasonKeyVo["S49"].spider_class    # => Ppl::AntiquitySpider
Ppl::SeasonKeyVo["30"].spider_class     # => Ppl::MedievalSpider
Ppl::SeasonKeyVo["31"].spider_class     # => Ppl::ModernitySpider
Ppl::SeasonKeyVo["1"].to_zero_padding_s # => "01"
Ppl::SeasonKeyVo.start                  # => S49

Ppl::SeasonKeyVo["S49"].users_update_from_web(mock: true)
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
