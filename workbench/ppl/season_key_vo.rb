require "#{__dir__}/setup"
Ppl.setup_for_workbench

tp Ppl::SeasonKeyVo["36"].records
exit


(Ppl::SeasonKeyVo["S31前"]..Ppl::SeasonKeyVo["S48後"]).each do |e|
  p e
  e.users_update_from_web
end
exit

(Ppl::SeasonKeyVo["S61"]..Ppl::SeasonKeyVo["2"]).to_a.collect(&:to_s) # =>

Ppl::SeasonKeyVo["S49"].spider_class    # =>
Ppl::SeasonKeyVo["30"].spider_class     # =>
Ppl::SeasonKeyVo["31"].spider_class     # =>
Ppl::SeasonKeyVo["1"].to_zero_padding_s # =>
Ppl::SeasonKeyVo.start                  # =>

# Ppl::SeasonKeyVo["S49"].users_update_from_web(mock: true)

Ppl::SeasonKeyVo["S48前"].succ.name # =>
Ppl::SeasonKeyVo["S48後"].succ.name # =>
Ppl::SeasonKeyVo["S62"].succ.name   # =>

rows = []
e = Ppl::SeasonKeyVo.start
100.times do
  rows << { name: e.name, position: e.position }
  e = e.succ
end
tp rows

# >> |-------+--------------------------------------------------------------|
# >> |  担当 | Ppl::ModernitySpider                                         |
# >> |    期 | 36                                                           |
# >> |   URL | https://www.shogi.or.jp/match/shoreikai/sandan/36/index.html |
# >> | sleep | 0.5                                                          |
# >> |-------+--------------------------------------------------------------|
# >> |------------+----------+--------+-----+-----+------+--------------------|
# >> | result_key | name     | mentor | age | win | lose | ox                 |
# >> |------------+----------+--------+-----+-----+------+--------------------|
# >> | 維         | 佐藤天彦 | 中田功 |  16 |  10 |    8 | oxxooxxoooxooxxoxo |
# >> | 維         | 津山慎悟 | 有吉   |  24 |   7 |   11 | xxooxxoxoxoxoxxxxo |
# >> | 昇         | 長岡裕也 | 米長   |  19 |  14 |    4 | oxxooooxooxooooooo |
# >> | 維         | 戸辺誠   | 加瀬   |  18 |  11 |    7 | ooxooxoxxxooooxoox |
# >> | 維         | 菊地裕太 | 大島   |  20 |  10 |    8 | xoxooxxoxooooxooxx |
# >> | 維         | 和田澄人 | 森信   |  18 |   9 |    9 | ooxxoxooxoxxoxxxoo |
# >> | 昇         | 広瀬章人 | 勝浦   |  17 |  15 |    3 | oxooooooxooxoooooo |
# >> | 維         | 金井恒太 | 飯野   |  18 |   9 |    9 | xoooxxxoxooxoxoxox |
# >> | 維         | 堀尾博洋 | 所司   |  23 |  12 |    6 | xoooooxxoxooxooxoo |
# >> | 維         | 水津隆義 | 西本   |  26 |  12 |    6 | oxxooxoxoxooooxooo |
# >> | 維         | 髙埼一生 | 米長   |  17 |  10 |    8 | xooxoooooxxoxoxoxx |
# >> | 維         | 本田啓二 | 有吉   |  25 |   8 |   10 | ooxxxxxxxoxoxoooxo |
# >> | 維         | 天野貴元 | 石田   |  18 |   7 |   11 | xoxxxxxxoxoxxxoooo |
# >> | 維         | 村田顕弘 | 中田章 |  18 |  11 |    7 | xxoxxooxxooxoooooo |
# >> | 維         | 中村太地 | 米長   |  16 |  12 |    6 | oooooooooxxxoxoxxo |
# >> | 維         | 荒木宣貴 | 米長   |  18 |   5 |   13 | oxoxoxxoxxxxxoxxxx |
# >> | 次         | 伊藤真吾 | 桜井   |  22 |  14 |    4 | xooxooooooooxoxooo |
# >> | 維         | 中村裕介 | 神谷   |  23 |   5 |   13 | oxxoxxxxxoxooxxxxx |
# >> | 維         | 遠山雄亮 | 加瀬   |  24 |  10 |    8 | ooxxxoxooxoxoxoxoo |
# >> | 維         | 高野悟志 | 佐伯   |  25 |  11 |    7 | oxoxooooooxxxoooxx |
# >> | 維         | 佐藤慎一 | 剱持   |  22 |   6 |   12 | xoxoxooxxxxxxoxoxx |
# >> | 降         | 和田真治 | 桜井   |  21 |   2 |   16 | xxoxxxxxxoxxxxxxxx |
# >> | 維         | 菊池隆   | 森安   |  24 |  11 |    7 | oxooxoxooxoooxoxox |
# >> | 維         | 関口武史 | 小林健 |  24 |   6 |   12 | xoxxoooooxxxxxxxxx |
# >> | 維         | 平田竜樹 | 森信   |  25 |   4 |   14 | oooxxoxxxxxxxxxxxx |
# >> | 維         | 石井直樹 | 中原   |  18 |   5 |   13 | xxxxxoxoxxxoxoxxxo |
# >> | 維         | 田中悠一 | 関根   |  19 |   5 |   13 | xoxxxxxxoooxxxoxxx |
# >> | 維         | 豊島将之 | 桐山   |  14 |  10 |    8 | oxooxxoxxxooxxoooo |
# >> | 維         | 及川拓馬 | 伊藤果 |  17 |   6 |   12 | xxxoxxoxxoxoxoxxox |
# >> | 維         | 糸谷哲郎 | 森信   |  15 |  13 |    5 | xxoxooxoooooooooox |
# >> |------------+----------+--------+-----+-----+------+--------------------|
# >> |------------+----------+--------+-----+-----+------+--------------------|
# >> | result_key | name     | mentor | age | win | lose | ox                 |
# >> |------------+----------+--------+-----+-----+------+--------------------|
# >> | 維         | 佐藤天彦 | 中田功 |  16 |  10 |    8 | oxxooxxoooxooxxoxo |
# >> | 維         | 津山慎悟 | 有吉   |  24 |   7 |   11 | xxooxxoxoxoxoxxxxo |
# >> | 昇         | 長岡裕也 | 米長   |  19 |  14 |    4 | oxxooooxooxooooooo |
# >> | 維         | 戸辺誠   | 加瀬   |  18 |  11 |    7 | ooxooxoxxxooooxoox |
# >> | 維         | 菊地裕太 | 大島   |  20 |  10 |    8 | xoxooxxoxooooxooxx |
# >> | 維         | 和田澄人 | 森信   |  18 |   9 |    9 | ooxxoxooxoxxoxxxoo |
# >> | 昇         | 広瀬章人 | 勝浦   |  17 |  15 |    3 | oxooooooxooxoooooo |
# >> | 維         | 金井恒太 | 飯野   |  18 |   9 |    9 | xoooxxxoxooxoxoxox |
# >> | 維         | 堀尾博洋 | 所司   |  23 |  12 |    6 | xoooooxxoxooxooxoo |
# >> | 維         | 水津隆義 | 西本   |  26 |  12 |    6 | oxxooxoxoxooooxooo |
# >> | 維         | 髙埼一生 | 米長   |  17 |  10 |    8 | xooxoooooxxoxoxoxx |
# >> | 維         | 本田啓二 | 有吉   |  25 |   8 |   10 | ooxxxxxxxoxoxoooxo |
# >> | 維         | 天野貴元 | 石田   |  18 |   7 |   11 | xoxxxxxxoxoxxxoooo |
# >> | 維         | 村田顕弘 | 中田章 |  18 |  11 |    7 | xxoxxooxxooxoooooo |
# >> | 維         | 中村太地 | 米長   |  16 |  12 |    6 | oooooooooxxxoxoxxo |
# >> | 維         | 荒木宣貴 | 米長   |  18 |   5 |   13 | oxoxoxxoxxxxxoxxxx |
# >> | 次         | 伊藤真吾 | 桜井   |  22 |  14 |    4 | xooxooooooooxoxooo |
# >> | 維         | 中村裕介 | 神谷   |  23 |   5 |   13 | oxxoxxxxxoxooxxxxx |
# >> | 維         | 遠山雄亮 | 加瀬   |  24 |  10 |    8 | ooxxxoxooxoxoxoxoo |
# >> | 維         | 高野悟志 | 佐伯   |  25 |  11 |    7 | oxoxooooooxxxoooxx |
# >> | 維         | 佐藤慎一 | 剱持   |  22 |   6 |   12 | xoxoxooxxxxxxoxoxx |
# >> | 降         | 和田真治 | 桜井   |  21 |   2 |   16 | xxoxxxxxxoxxxxxxxx |
# >> | 維         | 菊池隆   | 森安   |  24 |  11 |    7 | oxooxoxooxoooxoxox |
# >> | 維         | 関口武史 | 小林健 |  24 |   6 |   12 | xoxxoooooxxxxxxxxx |
# >> | 維         | 平田竜樹 | 森信   |  25 |   4 |   14 | oooxxoxxxxxxxxxxxx |
# >> | 維         | 石井直樹 | 中原   |  18 |   5 |   13 | xxxxxoxoxxxoxoxxxo |
# >> | 維         | 田中悠一 | 関根   |  19 |   5 |   13 | xoxxxxxxoooxxxoxxx |
# >> | 維         | 豊島将之 | 桐山   |  14 |  10 |    8 | oxooxxoxxxooxxoooo |
# >> | 維         | 及川拓馬 | 伊藤果 |  17 |   6 |   12 | xxxoxxoxxoxoxoxxox |
# >> | 維         | 糸谷哲郎 | 森信   |  15 |  13 |    5 | xxoxooxoooooooooox |
# >> |------------+----------+--------+-----+-----+------+--------------------|
