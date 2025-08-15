require "#{__dir__}/setup"

all = (28..77).collect { |e| Ppl::Spider.new(season_number: e).call }
Pathname("all.json").write(all.to_json)
exit

rows = Ppl::Spider.new(season_number: 66, take_size: 1, verbose: false, sleep: 0).call # => 
attrs = rows.sole               # => 
attrs[:result_key] # => 
attrs[:start_pos]  # => 
attrs[:name]       # => 
attrs[:age]        # => 
attrs[:lose]       # => 
attrs[:ox]         # => 
# >> |-------+--------------------------------------------------------------|
# >> |    期 | 47                                                           |
# >> |   URL | https://www.shogi.or.jp/match/shoreikai/sandan/47/index.html |
# >> | sleep | 1                                                            |
# >> |-------+--------------------------------------------------------------|
# >> |------------+-----------+------------+--------+-----+-----+------+--------------------|
# >> | result_key | start_pos | name       | mentor | age | win | lose | ox                 |
# >> |------------+-----------+------------+--------+-----+-----+------+--------------------|
# >> | 維         |         1 | 渡辺大夢   | 石田   |  21 |   7 |   11 | xoooxoxxoxxxoxxoxx |
# >> | 昇         |         2 | 佐々木勇気 | 石田   |  15 |  14 |    4 | oxoxoooxoxoooooooo |
# >> | 維         |         3 | 杉本和陽   | 米長   |  18 |   6 |   12 | xxxoxxoxooxxoxoxxx |
# >> | 昇         |         4 | 船江恒平   | 井上   |  22 |  13 |    5 | oxoxxoxooooooooxoo |
# >> | 維         |         5 | 森村賢平   | 宮田利 |  20 |   8 |   10 | ooxxxoxxxooxxxooxo |
# >> | 維         |         6 | 藤森哲也   | 塚田   |  22 |   9 |    9 | xoooooxoxxxoxxxoxo |
# >> | 次         |         7 | 竹内雄悟   | 森信   |  22 |  13 |    5 | oooooxoooooxoxxoxo |
# >> | 維         |         8 | 斎藤慎太郎 | 畠山鎮 |  16 |  13 |    5 | ooooooxoooxxxoxooo |
# >> | 維         |         9 | 宮本広志   | 森安   |  24 |  13 |    5 | ooxoooxoxxoxoooooo |
# >> | 維         |        10 | 竹内貴浩   | 杉本   |  22 |   7 |   11 | xxxoxxxxxxooooooxx |
# >> | 維         |        11 | 菊地裕太   | 大島   |  26 |  10 |    8 | oxoxxooooxxoxooxox |
# >> | 維         |        12 | 阿部光瑠   | 中村修 |  15 |   7 |   11 | oxxoxoxxoooxoxxxxx |
# >> | 維         |        13 | 西田拓也   | 森信   |  18 |   3 |   15 | xoxxxxooxxxxxxxxxx |
# >> | 維         |        14 | 井出隼平   | 田丸   |  18 |   6 |   12 | oxxxoxoxxxxxoxxoxo |
# >> | 維         |        15 | 門倉啓太   | 石田   |  22 |  11 |    7 | xoooooxxoooxoxxoxo |
# >> | 維         |        16 | 天野貴元   | 石田   |  24 |   9 |    9 | oxoxxxxoxxxoooooox |
# >> | 維         |        17 | 都成竜馬   | 谷川   |  20 |   7 |   11 | xxoxxxxoxxoxooxxoo |
# >> | 維         |        18 | 荒木宣貴   | 米長   |  23 |  12 |    6 | oooxoooooxooxxooxx |
# >> | 維         |        19 | 小泉祐     | 西村   |  21 |   7 |   11 | xxoxxxooxooxxxxoxo |
# >> | 維         |        20 | 渡辺愛生   | 安恵   |  22 |  10 |    8 | xoxoxxxooxoooooxxo |
# >> | 維         |        21 | 石井直樹   | 中原   |  23 |   6 |   12 | xxoxxxoxxoxxoxxoox |
# >> | 維         |        22 | 石田直裕   | 所司   |  21 |   4 |   14 | xxxoxoxxoxxxxoxxxx |
# >> | 維         |        23 | 星野良生   | 西村   |  21 |  12 |    6 | oxooooooxoooxxooxx |
# >> | 維         |        24 | 三宅潤     | 中村修 |  23 |   8 |   10 | xoxooooxxoxxoxxxxo |
# >> | 維         |        25 | 森下裕也   | 小林健 |  24 |   9 |    9 | xoxxoxoxxooooxxoox |
# >> | 維         |        25 | 伊藤和夫   | 剱持   |  21 |  11 |    7 | ooxxxxxoooxxoooooo |
# >> | 維         |        27 | 鈴木肇     | 所司   |  22 |   9 |    9 | ooxooooxxoxoxoxxxx |
# >> | 維         |        28 | 慶田義法   | 井上   |  17 |  10 |    8 | xxoxooxoxxxooooxoo |
# >> | 維         |        29 | 高見泰地   | 石田   |  16 |   9 |    9 | ooxxxoxoxooxooxxox |
# >> | 維         |        30 | 池永天志   | 小林健 |  16 |   5 |   13 | xoxxooxxoxxxxxxxox |
# >> | 維         |        31 | 石井健太郎 | 所司   |  17 |   8 |   10 | oxxooxoxoxoxxxxoox |
# >> | 維         |        32 | 千田翔太   | 森信   |  15 |  10 |    8 | xxooxxoxooxooxoo   |
# >> | 維         |        33 | 八代弥     | 青野   |  16 |  11 |    7 | oxooxxxooxooooxoxo |
# >> |------------+-----------+------------+--------+-----+-----+------+--------------------|
# >> |------------+-----------+------------+--------+-----+-----+------+--------------------|
# >> | result_key | start_pos | name       | mentor | age | win | lose | ox                 |
# >> |------------+-----------+------------+--------+-----+-----+------+--------------------|
# >> | 維         |         1 | 渡辺大夢   | 石田   |  21 |   7 |   11 | xoooxoxxoxxxoxxoxx |
# >> | 昇         |         2 | 佐々木勇気 | 石田   |  15 |  14 |    4 | oxoxoooxoxoooooooo |
# >> | 維         |         3 | 杉本和陽   | 米長   |  18 |   6 |   12 | xxxoxxoxooxxoxoxxx |
# >> | 昇         |         4 | 船江恒平   | 井上   |  22 |  13 |    5 | oxoxxoxooooooooxoo |
# >> | 維         |         5 | 森村賢平   | 宮田利 |  20 |   8 |   10 | ooxxxoxxxooxxxooxo |
# >> | 維         |         6 | 藤森哲也   | 塚田   |  22 |   9 |    9 | xoooooxoxxxoxxxoxo |
# >> | 次         |         7 | 竹内雄悟   | 森信   |  22 |  13 |    5 | oooooxoooooxoxxoxo |
# >> | 維         |         8 | 斎藤慎太郎 | 畠山鎮 |  16 |  13 |    5 | ooooooxoooxxxoxooo |
# >> | 維         |         9 | 宮本広志   | 森安   |  24 |  13 |    5 | ooxoooxoxxoxoooooo |
# >> | 維         |        10 | 竹内貴浩   | 杉本   |  22 |   7 |   11 | xxxoxxxxxxooooooxx |
# >> | 維         |        11 | 菊地裕太   | 大島   |  26 |  10 |    8 | oxoxxooooxxoxooxox |
# >> | 維         |        12 | 阿部光瑠   | 中村修 |  15 |   7 |   11 | oxxoxoxxoooxoxxxxx |
# >> | 維         |        13 | 西田拓也   | 森信   |  18 |   3 |   15 | xoxxxxooxxxxxxxxxx |
# >> | 維         |        14 | 井出隼平   | 田丸   |  18 |   6 |   12 | oxxxoxoxxxxxoxxoxo |
# >> | 維         |        15 | 門倉啓太   | 石田   |  22 |  11 |    7 | xoooooxxoooxoxxoxo |
# >> | 維         |        16 | 天野貴元   | 石田   |  24 |   9 |    9 | oxoxxxxoxxxoooooox |
# >> | 維         |        17 | 都成竜馬   | 谷川   |  20 |   7 |   11 | xxoxxxxoxxoxooxxoo |
# >> | 維         |        18 | 荒木宣貴   | 米長   |  23 |  12 |    6 | oooxoooooxooxxooxx |
# >> | 維         |        19 | 小泉祐     | 西村   |  21 |   7 |   11 | xxoxxxooxooxxxxoxo |
# >> | 維         |        20 | 渡辺愛生   | 安恵   |  22 |  10 |    8 | xoxoxxxooxoooooxxo |
# >> | 維         |        21 | 石井直樹   | 中原   |  23 |   6 |   12 | xxoxxxoxxoxxoxxoox |
# >> | 維         |        22 | 石田直裕   | 所司   |  21 |   4 |   14 | xxxoxoxxoxxxxoxxxx |
# >> | 維         |        23 | 星野良生   | 西村   |  21 |  12 |    6 | oxooooooxoooxxooxx |
# >> | 維         |        24 | 三宅潤     | 中村修 |  23 |   8 |   10 | xoxooooxxoxxoxxxxo |
# >> | 維         |        25 | 森下裕也   | 小林健 |  24 |   9 |    9 | xoxxoxoxxooooxxoox |
# >> | 維         |        25 | 伊藤和夫   | 剱持   |  21 |  11 |    7 | ooxxxxxoooxxoooooo |
# >> | 維         |        27 | 鈴木肇     | 所司   |  22 |   9 |    9 | ooxooooxxoxoxoxxxx |
# >> | 維         |        28 | 慶田義法   | 井上   |  17 |  10 |    8 | xxoxooxoxxxooooxoo |
# >> | 維         |        29 | 高見泰地   | 石田   |  16 |   9 |    9 | ooxxxoxoxooxooxxox |
# >> | 維         |        30 | 池永天志   | 小林健 |  16 |   5 |   13 | xoxxooxxoxxxxxxxox |
# >> | 維         |        31 | 石井健太郎 | 所司   |  17 |   8 |   10 | oxxooxoxoxoxxxxoox |
# >> | 維         |        32 | 千田翔太   | 森信   |  15 |  10 |    8 | xxooxxoxooxooxoo   |
# >> | 維         |        33 | 八代弥     | 青野   |  16 |  11 |    7 | oxooxxxooxooooxoxo |
# >> |------------+-----------+------------+--------+-----+-----+------+--------------------|
