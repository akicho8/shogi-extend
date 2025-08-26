require "#{__dir__}/setup"
Ppl.setup_for_workbench
(Ppl::SeasonKeyVo["S31前"]..Ppl::SeasonKeyVo["S33前"]).each(&:users_update_from_web)

# e = Ppl::AncientSpider.new(season_key_vo: Ppl::SeasonKeyVo["S31前"], take_size: nil, verbose: false, sleep: 0, mock: false)
# tp e.table_hash_array
# tp e.call
# >> |------------+------------+--------+-----+-----+------+--------------|
# >> | result_key | name       | mentor | age | win | lose | ox           |
# >> |------------+------------+--------+-----+-----+------+--------------|
# >> | 維         | 佐藤豊     | 宮松   |  42 |   1 |    9 | xoxxxxxxxx   |
# >> | 維         | 浅沼一     | 小泉   |  31 |   2 |    8 | oxxxxxoxxx   |
# >> | 維         | 佐藤健伍   | 加藤治 |  28 |   7 |    3 | ooooxooxxo   |
# >> | 維         | 大友寛二   | 原田   |  22 |   7 |    3 | oooooxooxx   |
# >> | 維         | 木村嘉孝   | 木村   |  25 |   4 |    6 | oooxxoxxxx   |
# >> | 昇         | 剱持松二   | 荒巻   |  22 |   9 |    1 | oooooxoooo   |
# >> | 維         | 佐藤健伍   | 加藤治 |  29 |   7 |    5 | ooooxoxxoxxo |
# >> | 維         | 大友寛二   | 原田   |  22 |   5 |    7 | xxxoxooxxoox |
# >> | 維         | 木村嘉孝   | 木村   |  26 |   4 |    8 | xoxxxoooxxxx |
# >> | 維         | 浅沼一     | 小泉   |  32 |   6 |    6 | ooxxooxxoxxo |
# >> | 昇         | 佐藤大五郎 | 渡辺   |  20 |   8 |    4 | ooxxxoooooox |
# >> |------------+------------+--------+-----+-----+------+--------------|
