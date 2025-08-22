require "#{__dir__}/setup"
tp Ppl::UnofficialSpider.call(season_number: 1, take_size: nil, verbose: false, sleep: 0)
# >> |------------+----------+--------+-----+-----+------+------------------|
# >> | result_key | name     | mentor | age | win | lose | ox               |
# >> |------------+----------+--------+-----+-----+------+------------------|
# >> | 維         | 村松央一 | 平野   |  28 |   7 |    9 | xxxooxoooooxxxxx |
# >> | 維         | 田畑良太 | 大友   |  24 |   9 |    7 | xoooxxoxxoxoooxo |
# >> | 維         | 小泉有明 | 芹沢   |  23 |   6 |   10 | oxxxxxoxxoxxxooo |
# >> | 維         | 伊藤能   | 米長   |  25 |   8 |    8 | oxooxxxoooxxxoox |
# >> | 維         | 荒井孝則 | 西村   |  23 |   5 |   11 | oxxxxoxxxoxoxxox |
# >> | 維         | 古作登   | 松下   |  24 |   9 |    7 | oxxxoooooooxxxox |
# >> | 維         | 高田尚平 | 荒巻   |  25 |   9 |    7 | xooxoxooxxoxxooo |
# >> | 維         | 庄司俊之 | 佐瀬   |  18 |   8 |    8 | oooooxxoxxooxxxx |
# >> | 維         | 木下浩一 | 松田   |  20 |   6 |   10 | oxxxxooxxoxoxxxo |
# >> | 昇         | 中川大輔 | 米長   |  19 |  13 |    3 | oooxooxxoooooooo |
# >> | 維         | 北島忠雄 | 関根   |  21 |   6 |   10 | oxxoooxxxxxxooxx |
# >> | 昇         | 先崎学   | 米長   |  17 |  12 |    4 | oxoooxooooooxoxo |
# >> | 維         | 小池裕樹 | 安恵   |  20 |   6 |   10 | xoxoxxxooxxxoxox |
# >> | 維         | 中山則男 | 板谷進 |  27 |   7 |    9 | xoooxoxxoxooxxxx |
# >> | 維         | 野田敬三 | 森安秀 |  29 |   6 |   10 | xoxxxxoxxxoxxooo |
# >> | 維         | 藤原直哉 | 若松   |  22 |   9 |    7 | xoxooxooxxooooxx |
# >> | 維         | 杉本昌隆 | 板谷進 |  18 |  10 |    6 | xxooooxooxxxoooo |
# >> |------------+----------+--------+-----+-----+------+------------------|
