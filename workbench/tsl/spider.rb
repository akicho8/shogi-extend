require "#{__dir__}/setup"
rows = Tsl::Spider.new(generation: 66, max: 21, verbose: false, sleep: 0).call # => [{result_key: "維", start_pos: 1, name: "古賀悠聖", _mentor: "中田功", age: 18, win: 6, lose: 12, ox: "oxxoxxxoxxxxooxxxo"}, {result_key: "昇", start_pos: 2, name: "服部慎一郎", _mentor: "中田章", age: 20, win: 14, lose: 4, ox: "ooooooxoxooooxxooo"}, {result_key: "維", start_pos: 3, name: "関矢寛之", _mentor: "武者野", age: 26, win: 9, lose: 9, ox: "xxooooxoxxoxxoxoxo"}, {result_key: "昇", start_pos: 4, name: "谷合廣紀", _mentor: "中座", age: 25, win: 14, lose: 4, ox: "xxoxooooooooooooox"}, {result_key: "維", start_pos: 5, name: "柵木幹太", _mentor: "増田裕", age: 21, win: 10, lose: 8, ox: "xoxoxxooxoxooxooxo"}, {result_key: "維", start_pos: 6, name: "荒田敏史", _mentor: "石田和", age: 26, win: 8, lose: 10, ox: "xxxxoxoxxxxoooooox"}, {result_key: "維", start_pos: 7, name: "井田明宏", _mentor: "小林健", age: 22, win: 13, lose: 5, ox: "ooxooxooxoooxoxooo"}, {result_key: "維", start_pos: 8, name: "伊藤匠", _mentor: "宮田利", age: 16, win: 9, lose: 9, ox: "xooxxooxxxooxxooox"}, {result_key: "維", start_pos: 9, name: "岡部怜央", _mentor: "加瀬", age: 20, win: 8, lose: 10, ox: "xoxxooxoxooxxxoxxo"}, {result_key: "維", start_pos: 10, name: "上野裕寿", _mentor: "井上", age: 16, win: 7, lose: 11, ox: "xooxxoooxxxoxxoxxx"}, {result_key: "維", start_pos: 11, name: "三田敏弘", _mentor: "中田章", age: 23, win: 9, lose: 9, ox: "oxoooxoxooxxxxxoxo"}, {result_key: "維", start_pos: 12, name: "貫島永州", _mentor: "小林健", age: 21, win: 11, lose: 7, ox: "ooxoooxooxxoxooxox"}, {result_key: "維", start_pos: 13, name: "山川泰煕", _mentor: "広瀬", age: 21, win: 8, lose: 10, ox: "xoooxxxoxxoxxxxooo"}, {result_key: "維", start_pos: 14, name: "小山直希", _mentor: "戸辺", age: 19, win: 13, lose: 5, ox: "oooxxoxxooooxooooo"}, {result_key: "維", start_pos: 15, name: "岡井良樹", _mentor: "大野", age: 24, win: 8, lose: 10, ox: "oxxxoxoxooxooxxoxx"}, {result_key: "維", start_pos: 16, name: "冨田誠也", _mentor: "小林健", age: 23, win: 6, lose: 12, ox: "xxxoxxxxooxxoxoxox"}, {result_key: "維", start_pos: 17, name: "齊藤優希", _mentor: "深浦", age: 23, win: 10, lose: 8, ox: "ooxooxooxxxoxooxxo"}, {result_key: "維", start_pos: 18, name: "徳田拳士", _mentor: "小林健", age: 21, win: 11, lose: 7, ox: "xoxooooxoxoxooooxx"}, {result_key: "維", start_pos: 19, name: "横山友紀", _mentor: "井上", age: 19, win: 9, lose: 9, ox: "xxoxxooooxoxooxxxo"}, {result_key: "維", start_pos: 20, name: "古田龍生", _mentor: "宮田利", age: 22, win: 6, lose: 12, ox: "xxoxxxxxxooxoxoxox"}, {result_key: "次", start_pos: 21, name: "西山朋佳", _mentor: "伊藤博", age: 24, win: 14, lose: 4, ox: "oxoooooxoooxoxoooo"}]
tp rows
# >> |------------+-----------+------------+---------+-----+-----+------+--------------------|
# >> | result_key | start_pos | name       | _mentor | age | win | lose | ox                 |
# >> |------------+-----------+------------+---------+-----+-----+------+--------------------|
# >> | 維         |         1 | 古賀悠聖   | 中田功  |  18 |   6 |   12 | oxxoxxxoxxxxooxxxo |
# >> | 昇         |         2 | 服部慎一郎 | 中田章  |  20 |  14 |    4 | ooooooxoxooooxxooo |
# >> | 維         |         3 | 関矢寛之   | 武者野  |  26 |   9 |    9 | xxooooxoxxoxxoxoxo |
# >> | 昇         |         4 | 谷合廣紀   | 中座    |  25 |  14 |    4 | xxoxooooooooooooox |
# >> | 維         |         5 | 柵木幹太   | 増田裕  |  21 |  10 |    8 | xoxoxxooxoxooxooxo |
# >> | 維         |         6 | 荒田敏史   | 石田和  |  26 |   8 |   10 | xxxxoxoxxxxoooooox |
# >> | 維         |         7 | 井田明宏   | 小林健  |  22 |  13 |    5 | ooxooxooxoooxoxooo |
# >> | 維         |         8 | 伊藤匠     | 宮田利  |  16 |   9 |    9 | xooxxooxxxooxxooox |
# >> | 維         |         9 | 岡部怜央   | 加瀬    |  20 |   8 |   10 | xoxxooxoxooxxxoxxo |
# >> | 維         |        10 | 上野裕寿   | 井上    |  16 |   7 |   11 | xooxxoooxxxoxxoxxx |
# >> | 維         |        11 | 三田敏弘   | 中田章  |  23 |   9 |    9 | oxoooxoxooxxxxxoxo |
# >> | 維         |        12 | 貫島永州   | 小林健  |  21 |  11 |    7 | ooxoooxooxxoxooxox |
# >> | 維         |        13 | 山川泰煕   | 広瀬    |  21 |   8 |   10 | xoooxxxoxxoxxxxooo |
# >> | 維         |        14 | 小山直希   | 戸辺    |  19 |  13 |    5 | oooxxoxxooooxooooo |
# >> | 維         |        15 | 岡井良樹   | 大野    |  24 |   8 |   10 | oxxxoxoxooxooxxoxx |
# >> | 維         |        16 | 冨田誠也   | 小林健  |  23 |   6 |   12 | xxxoxxxxooxxoxoxox |
# >> | 維         |        17 | 齊藤優希   | 深浦    |  23 |  10 |    8 | ooxooxooxxxoxooxxo |
# >> | 維         |        18 | 徳田拳士   | 小林健  |  21 |  11 |    7 | xoxooooxoxoxooooxx |
# >> | 維         |        19 | 横山友紀   | 井上    |  19 |   9 |    9 | xxoxxooooxoxooxxxo |
# >> | 維         |        20 | 古田龍生   | 宮田利  |  22 |   6 |   12 | xxoxxxxxxooxoxoxox |
# >> | 次         |        21 | 西山朋佳   | 伊藤博  |  24 |  14 |    4 | oxoooooxoooxoxoooo |
# >> |------------+-----------+------------+---------+-----+-----+------+--------------------|
