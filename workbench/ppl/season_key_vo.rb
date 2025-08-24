require "#{__dir__}/setup"

(Ppl::SeasonKeyVo["S61"]..Ppl::SeasonKeyVo["2"]).to_a.collect(&:to_s) # => ["S61", "S62", "1", "2"]

Ppl::SeasonKeyVo["S49"].spider_class  # => Ppl::AntiquitySpider
Ppl::SeasonKeyVo["30"].spider_class   # => Ppl::MedievalSpider
Ppl::SeasonKeyVo["31"].spider_class   # => Ppl::ModernitySpider
Ppl::SeasonKeyVo["1"].to_zero_padding_s # => "01"
Ppl::SeasonKeyVo.start                # => S49
Ppl::SeasonKeyVo.all                  # => [S49, S50, S51, S52, S53, S54, S55, S56, S57, S58, S59, S60, S61, S62, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200]

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
