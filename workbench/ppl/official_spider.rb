require "#{__dir__}/setup"
tp Ppl::UnofficialSpider.call(season_number: 31, take_size: nil, verbose: false, sleep: 0)
# >> |------------+------------+--------+-----+-----+------+--------------------|
# >> | result_key | name       | mentor | age | win | lose | ox                 |
# >> |------------+------------+--------+-----+-----+------+--------------------|
# >> | 維         | 高野悟志   | 佐伯   |  23 |   8 |   10 | xoooxxoxoxooxxxxxo |
# >> | 維         | 遠山雄亮   | 加瀬   |  22 |   7 |   11 | xxxxoxooxxooxoxxxo |
# >> | 維         | 菊地裕太   | 大島   |  18 |   8 |   10 | xxxxoxoxoxoooooxxx |
# >> | 維         | 佐藤佳一郎 | 青野   |  25 |  11 |    7 | oooooxxxxooxoooxox |
# >> | 維         | 村山慈明   | 桜井   |  18 |  10 |    8 | ooooxxxxooxoxxxooo |
# >> | 維         | 城間春樹   | 泉     |  25 |  11 |    7 | xoooooxxoxoxooxxoo |
# >> | 昇         | 横山泰明   | 桜井   |  21 |  12 |    6 | oxooooxoooxoxxxooo |
# >> | 維         | 佐藤和俊   | 加瀬   |  24 |  11 |    7 | ooxxxxxoxoxooooooo |
# >> | 維         | 津山慎悟   | 有吉   |  22 |  11 |    7 | xoxoxoooooooxxxoxo |
# >> | 維         | 本田啓二   | 有吉   |  23 |   6 |   12 | oxxoxxxxxxoxoxooxx |
# >> | 維         | 村中秀史   | 高柳   |  21 |  10 |    8 | xoxoooooxxxoxxxooo |
# >> | 維         | 片上大輔   | 森信   |  21 |  12 |    6 | oooxxxooooxoooxoxo |
# >> | 維         | 西尾明     | 青野   |  23 |  12 |    6 | oooxxooooxxxoooxoo |
# >> | 維         | 水津隆義   | 橋本   |  24 |   1 |   17 | xxxxxxxxxxxxxxxoxx |
# >> | 維         | 阪口悟     | 木下晃 |  23 |   9 |    9 | oooxxooxxoxxxooxox |
# >> | 維         | 島本亮     | 小林健 |  22 |   7 |   11 | xxxxooooxoxxxoxxox |
# >> | 維         | 菊池隆     | 森安正 |  22 |   7 |   11 | xxoxxxoxoxoooxoxxx |
# >> | 維         | 堀尾博洋   | 所司   |  21 |  12 |    6 | xoooooxoxxooxoooxo |
# >> | 維         | 佐藤慎一   | 剱持   |  20 |  10 |    8 | oxooooxxooxxxoooxx |
# >> | 昇         | 藤倉勇樹   | 桜井   |  22 |  13 |    5 | xoxoooxooooxoooxoo |
# >> | 維         | 平田竜樹   | 森信   |  23 |   7 |   11 | oxxooxxooxxxoxxxox |
# >> | 維         | 前田真周   | 剱持   |  22 |   4 |   14 | xxxxxxoxxooxxxoxxx |
# >> | 維         | 伊藤真吾   | 桜井   |  20 |  10 |    8 | oxxxooooxoxxoxooox |
# >> | 維         | 野島崇宏   | 剱持   |  24 |   7 |   11 | oxoxxoxxxxoooxxoxx |
# >> |------------+------------+--------+-----+-----+------+--------------------|
