require "./setup"
scope = Swars::Membership.where(id: ::Swars::Membership.last(1000).collect(&:id))
object = QuickScript::Swars::TacticListScript.new(scope: scope)
object.cache_write
tp object.call

# >> |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
# >> | tag_name             | win_count | win_ratio           | draw_count | freq_count | freq_ratio           | lose_count | win_lose_count |
# >> |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
# >> | 力戦                 |         7 |  0.5833333333333334 |          0 |         12 |   0.2307692307692308 |          5 |             12 |
# >> | 居玉                 |         6 |  0.4615384615384616 |          0 |         13 |                 0.25 |          7 |             13 |
# >> | 名人に定跡なし       |         7 |                 1.0 |          0 |          7 |   0.1346153846153846 |          0 |              7 |
# >> | 居飛車               |        15 |  0.5357142857142857 |          0 |         28 |   0.5384615384615384 |         13 |             28 |
# >> | 相居飛車             |         6 |                 0.5 |          0 |         12 |   0.2307692307692308 |          6 |             12 |
# >> | 対居飛車             |        13 |  0.4642857142857143 |          0 |         28 |   0.5384615384615384 |         15 |             28 |
# >> | 相居玉               |         4 |                 0.5 |          0 |          8 |  0.15384615384615383 |          4 |              8 |
# >> | 急戦                 |        13 |                 0.5 |          0 |         26 |                  0.5 |         13 |             26 |
# >> | 短手数               |        18 |                 0.5 |          0 |         36 |   0.6923076923076923 |         18 |             36 |
# >> | 大駒全ブッチ         |         1 | 0.14285714285714285 |          0 |          7 |   0.1346153846153846 |          6 |              7 |
# >> | 肩銀                 |         1 |                 0.5 |          0 |          2 | 0.038461538461538464 |          1 |              2 |
# >> | 頭銀                 |         2 |                 0.4 |          0 |          5 |  0.09615384615384616 |          3 |              5 |
# >> | 尻金                 |         1 |  0.3333333333333333 |          0 |          3 | 0.057692307692307696 |          2 |              3 |
# >> | 大駒コンプリート     |         6 |  0.8571428571428571 |          0 |          7 |   0.1346153846153846 |          1 |              7 |
# >> | 歩頭の桂             |         2 |  0.2857142857142857 |          0 |          7 |   0.1346153846153846 |          5 |              7 |
# >> | ふんどしの桂         |         4 |                 0.8 |          0 |          5 |  0.09615384615384616 |          1 |              5 |
# >> | 対振り持久戦         |         0 |                 0.0 |          0 |          3 | 0.057692307692307696 |          3 |              3 |
# >> | 右四間飛車           |         0 |                 0.0 |          0 |          2 | 0.038461538461538464 |          2 |              2 |
# >> | 対振り飛車           |        13 |  0.5416666666666666 |          0 |         24 |   0.4615384615384616 |         11 |             24 |
# >> | 対抗形               |        16 |                 0.5 |          0 |         32 |   0.6153846153846154 |         16 |             32 |
# >> | 持久戦               |        12 |                 0.5 |          0 |         24 |   0.4615384615384616 |         12 |             24 |
# >> | 4手目△3三角戦法     |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 向かい飛車           |         4 |                 0.8 |          0 |          5 |  0.09615384615384616 |          1 |              5 |
# >> | 片美濃囲い           |         3 |                 0.6 |          0 |          5 |  0.09615384615384616 |          2 |              5 |
# >> | 振り飛車             |        11 |  0.4583333333333333 |          0 |         24 |   0.4615384615384616 |         13 |             24 |
# >> | 穴熊の姿焼き         |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 垂れ歩               |         6 |  0.5454545454545454 |          0 |         11 |   0.2115384615384615 |          5 |             11 |
# >> | 角換わり腰掛け銀旧型 |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | カブト囲い           |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 角交換型             |         3 |                 0.5 |          0 |          6 |   0.1153846153846154 |          3 |              6 |
# >> | 長手数               |         8 |                 0.5 |          0 |         16 |   0.3076923076923077 |          8 |             16 |
# >> | 桂頭の銀             |         3 | 0.42857142857142855 |          0 |          7 |   0.1346153846153846 |          4 |              7 |
# >> | たたきの歩           |        10 | 0.47619047619047616 |          0 |         21 |  0.40384615384615385 |         11 |             21 |
# >> | 頭金                 |         3 |                 0.6 |          0 |          5 |  0.09615384615384616 |          2 |              5 |
# >> | 角換わり腰掛け銀     |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 土下座の歩           |         2 |  0.6666666666666666 |          0 |          3 | 0.057692307692307696 |          1 |              3 |
# >> | 腹金                 |         4 |                 0.5 |          0 |          8 |  0.15384615384615383 |          4 |              8 |
# >> | 肩金                 |         5 |  0.7142857142857143 |          0 |          7 |   0.1346153846153846 |          2 |              7 |
# >> | 横歩取り             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 遠見の角             |         0 |                 0.0 |          0 |          3 | 0.057692307692307696 |          3 |              3 |
# >> | △4五角戦法          |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 一間竜               |         5 |               0.625 |          0 |          8 |  0.15384615384615383 |          3 |              8 |
# >> | 連打の歩             |         2 |                 1.0 |          0 |          2 | 0.038461538461538464 |          0 |              2 |
# >> | 左美濃               |         1 |                 0.5 |          0 |          2 | 0.038461538461538464 |          1 |              2 |
# >> | 居飛車の税金         |         3 |                 0.6 |          0 |          5 |  0.09615384615384616 |          2 |              5 |
# >> | 下段の香             |         0 |                 0.0 |          0 |          2 | 0.038461538461538464 |          2 |              2 |
# >> | 控えの桂             |         2 |  0.6666666666666666 |          0 |          3 | 0.057692307692307696 |          1 |              3 |
# >> | 裾銀                 |         3 | 0.42857142857142855 |          0 |          7 |   0.1346153846153846 |          4 |              7 |
# >> | 四間飛車             |         2 |                0.25 |          0 |          8 |  0.15384615384615383 |          6 |              8 |
# >> | 角交換振り飛車       |         0 |                 0.0 |          0 |          3 | 0.057692307692307696 |          3 |              3 |
# >> | 美濃囲い             |         1 |  0.3333333333333333 |          0 |          3 | 0.057692307692307696 |          2 |              3 |
# >> | 手損角交換型         |         0 |                 0.0 |          0 |          3 | 0.057692307692307696 |          3 |              3 |
# >> | 金矢倉               |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 手得角交換型         |         3 |                 1.0 |          0 |          3 | 0.057692307692307696 |          0 |              3 |
# >> | こびん攻め           |         2 |  0.2222222222222222 |          0 |          9 |  0.17307692307692307 |          7 |              9 |
# >> | 腹銀                 |         1 |                 0.5 |          0 |          2 | 0.038461538461538464 |          1 |              2 |
# >> | 逆棒銀               |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | ロケット             |         3 |                 1.0 |          0 |          3 | 0.057692307692307696 |          0 |              3 |
# >> | 2段ロケット          |         3 |                 1.0 |          0 |          3 | 0.057692307692307696 |          0 |              3 |
# >> | 原始中飛車           |         2 |                 1.0 |          0 |          2 | 0.038461538461538464 |          0 |              2 |
# >> | 相振り飛車           |         4 |                 0.5 |          0 |          8 |  0.15384615384615383 |          4 |              8 |
# >> | 背水の陣             |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 早石田               |         1 |  0.3333333333333333 |          0 |          3 | 0.057692307692307696 |          2 |              3 |
# >> | 袖飛車               |         0 |                 0.0 |          0 |          2 | 0.038461538461538464 |          2 |              2 |
# >> | 舟囲いDX             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 米長流急戦矢倉       |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | カニ囲い             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 金頭の桂             |         1 |  0.3333333333333333 |          0 |          3 | 0.057692307692307696 |          2 |              3 |
# >> | 金底の歩             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 腰掛け銀             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | ノーマル四間飛車     |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 石田流本組み         |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 嬉野流               |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 位の確保             |         2 |  0.6666666666666666 |          0 |          3 | 0.057692307692307696 |          1 |              3 |
# >> | 金無双               |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 舟囲い               |         2 |                 1.0 |          0 |          2 | 0.038461538461538464 |          0 |              2 |
# >> | たすきの銀           |         1 |                 0.5 |          0 |          2 | 0.038461538461538464 |          1 |              2 |
# >> | 原始棒銀             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 棒銀                 |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 新嬉野流             |         0 |                 0.0 |          0 |          2 | 0.038461538461538464 |          2 |              2 |
# >> | 鳥刺し               |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 対穴熊               |         2 |  0.6666666666666666 |          0 |          3 | 0.057692307692307696 |          1 |              3 |
# >> | レグスペ             |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 振り飛車穴熊         |         1 |  0.3333333333333333 |          0 |          3 | 0.057692307692307696 |          2 |              3 |
# >> | 穴熊                 |         1 |  0.3333333333333333 |          0 |          3 | 0.057692307692307696 |          2 |              3 |
# >> | 居飛車金無双         |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 初手▲7八飛戦法      |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 居飛車銀冠           |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 地下鉄飛車           |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 三間飛車             |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 5筋位取り中飛車      |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 中飛車左穴熊         |         1 |                 1.0 |          0 |          1 | 0.019230769230769232 |          0 |              1 |
# >> | 2手目△3ニ飛戦法     |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> | 高美濃囲い           |         0 |                 0.0 |          0 |          1 | 0.019230769230769232 |          1 |              1 |
# >> |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
# >> |----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 力戦 | {tag_name: "力戦", win_count: 7, win_ratio: 0.5833333333333334, draw_count: 0, freq_count: 12, freq_ratio: 0.2307692307692308, lose_count: 5, win_lose_count: 12}           |
# >> |                 居玉 | {tag_name: "居玉", win_count: 6, win_ratio: 0.4615384615384616, draw_count: 0, freq_count: 13, freq_ratio: 0.25, lose_count: 7, win_lose_count: 13}                         |
# >> |       名人に定跡なし | {tag_name: "名人に定跡なし", win_count: 7, win_ratio: 1.0, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 0, win_lose_count: 7}                  |
# >> |               居飛車 | {tag_name: "居飛車", win_count: 15, win_ratio: 0.5357142857142857, draw_count: 0, freq_count: 28, freq_ratio: 0.5384615384615384, lose_count: 13, win_lose_count: 28}       |
# >> |             相居飛車 | {tag_name: "相居飛車", win_count: 6, win_ratio: 0.5, draw_count: 0, freq_count: 12, freq_ratio: 0.2307692307692308, lose_count: 6, win_lose_count: 12}                      |
# >> |             対居飛車 | {tag_name: "対居飛車", win_count: 13, win_ratio: 0.4642857142857143, draw_count: 0, freq_count: 28, freq_ratio: 0.5384615384615384, lose_count: 15, win_lose_count: 28}     |
# >> |               相居玉 | {tag_name: "相居玉", win_count: 4, win_ratio: 0.5, draw_count: 0, freq_count: 8, freq_ratio: 0.15384615384615383, lose_count: 4, win_lose_count: 8}                         |
# >> |                 急戦 | {tag_name: "急戦", win_count: 13, win_ratio: 0.5, draw_count: 0, freq_count: 26, freq_ratio: 0.5, lose_count: 13, win_lose_count: 26}                                       |
# >> |               短手数 | {tag_name: "短手数", win_count: 18, win_ratio: 0.5, draw_count: 0, freq_count: 36, freq_ratio: 0.6923076923076923, lose_count: 18, win_lose_count: 36}                      |
# >> |         大駒全ブッチ | {tag_name: "大駒全ブッチ", win_count: 1, win_ratio: 0.14285714285714285, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 6, win_lose_count: 7}    |
# >> |                 肩銀 | {tag_name: "肩銀", win_count: 1, win_ratio: 0.5, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 1, win_lose_count: 2}                          |
# >> |                 頭銀 | {tag_name: "頭銀", win_count: 2, win_ratio: 0.4, draw_count: 0, freq_count: 5, freq_ratio: 0.09615384615384616, lose_count: 3, win_lose_count: 5}                           |
# >> |                 尻金 | {tag_name: "尻金", win_count: 1, win_ratio: 0.3333333333333333, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 2, win_lose_count: 3}           |
# >> |     大駒コンプリート | {tag_name: "大駒コンプリート", win_count: 6, win_ratio: 0.8571428571428571, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 1, win_lose_count: 7} |
# >> |             歩頭の桂 | {tag_name: "歩頭の桂", win_count: 2, win_ratio: 0.2857142857142857, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 5, win_lose_count: 7}         |
# >> |         ふんどしの桂 | {tag_name: "ふんどしの桂", win_count: 4, win_ratio: 0.8, draw_count: 0, freq_count: 5, freq_ratio: 0.09615384615384616, lose_count: 1, win_lose_count: 5}                   |
# >> |         対振り持久戦 | {tag_name: "対振り持久戦", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 3, win_lose_count: 3}                  |
# >> |           右四間飛車 | {tag_name: "右四間飛車", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 2, win_lose_count: 2}                    |
# >> |           対振り飛車 | {tag_name: "対振り飛車", win_count: 13, win_ratio: 0.5416666666666666, draw_count: 0, freq_count: 24, freq_ratio: 0.4615384615384616, lose_count: 11, win_lose_count: 24}   |
# >> |               対抗形 | {tag_name: "対抗形", win_count: 16, win_ratio: 0.5, draw_count: 0, freq_count: 32, freq_ratio: 0.6153846153846154, lose_count: 16, win_lose_count: 32}                      |
# >> |               持久戦 | {tag_name: "持久戦", win_count: 12, win_ratio: 0.5, draw_count: 0, freq_count: 24, freq_ratio: 0.4615384615384616, lose_count: 12, win_lose_count: 24}                      |
# >> |     4手目△3三角戦法 | {tag_name: "4手目△3三角戦法", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}              |
# >> |           向かい飛車 | {tag_name: "向かい飛車", win_count: 4, win_ratio: 0.8, draw_count: 0, freq_count: 5, freq_ratio: 0.09615384615384616, lose_count: 1, win_lose_count: 5}                     |
# >> |           片美濃囲い | {tag_name: "片美濃囲い", win_count: 3, win_ratio: 0.6, draw_count: 0, freq_count: 5, freq_ratio: 0.09615384615384616, lose_count: 2, win_lose_count: 5}                     |
# >> |             振り飛車 | {tag_name: "振り飛車", win_count: 11, win_ratio: 0.4583333333333333, draw_count: 0, freq_count: 24, freq_ratio: 0.4615384615384616, lose_count: 13, win_lose_count: 24}     |
# >> |         穴熊の姿焼き | {tag_name: "穴熊の姿焼き", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                  |
# >> |               垂れ歩 | {tag_name: "垂れ歩", win_count: 6, win_ratio: 0.5454545454545454, draw_count: 0, freq_count: 11, freq_ratio: 0.2115384615384615, lose_count: 5, win_lose_count: 11}         |
# >> | 角換わり腰掛け銀旧型 | {tag_name: "角換わり腰掛け銀旧型", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}          |
# >> |           カブト囲い | {tag_name: "カブト囲い", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                    |
# >> |             角交換型 | {tag_name: "角交換型", win_count: 3, win_ratio: 0.5, draw_count: 0, freq_count: 6, freq_ratio: 0.1153846153846154, lose_count: 3, win_lose_count: 6}                        |
# >> |               長手数 | {tag_name: "長手数", win_count: 8, win_ratio: 0.5, draw_count: 0, freq_count: 16, freq_ratio: 0.3076923076923077, lose_count: 8, win_lose_count: 16}                        |
# >> |             桂頭の銀 | {tag_name: "桂頭の銀", win_count: 3, win_ratio: 0.42857142857142855, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 4, win_lose_count: 7}        |
# >> |           たたきの歩 | {tag_name: "たたきの歩", win_count: 10, win_ratio: 0.47619047619047616, draw_count: 0, freq_count: 21, freq_ratio: 0.40384615384615385, lose_count: 11, win_lose_count: 21} |
# >> |                 頭金 | {tag_name: "頭金", win_count: 3, win_ratio: 0.6, draw_count: 0, freq_count: 5, freq_ratio: 0.09615384615384616, lose_count: 2, win_lose_count: 5}                           |
# >> |     角換わり腰掛け銀 | {tag_name: "角換わり腰掛け銀", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}              |
# >> |           土下座の歩 | {tag_name: "土下座の歩", win_count: 2, win_ratio: 0.6666666666666666, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 1, win_lose_count: 3}     |
# >> |                 腹金 | {tag_name: "腹金", win_count: 4, win_ratio: 0.5, draw_count: 0, freq_count: 8, freq_ratio: 0.15384615384615383, lose_count: 4, win_lose_count: 8}                           |
# >> |                 肩金 | {tag_name: "肩金", win_count: 5, win_ratio: 0.7142857142857143, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 2, win_lose_count: 7}             |
# >> |             横歩取り | {tag_name: "横歩取り", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |             遠見の角 | {tag_name: "遠見の角", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 3, win_lose_count: 3}                      |
# >> |          △4五角戦法 | {tag_name: "△4五角戦法", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                   |
# >> |               一間竜 | {tag_name: "一間竜", win_count: 5, win_ratio: 0.625, draw_count: 0, freq_count: 8, freq_ratio: 0.15384615384615383, lose_count: 3, win_lose_count: 8}                       |
# >> |             連打の歩 | {tag_name: "連打の歩", win_count: 2, win_ratio: 1.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 0, win_lose_count: 2}                      |
# >> |               左美濃 | {tag_name: "左美濃", win_count: 1, win_ratio: 0.5, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 1, win_lose_count: 2}                        |
# >> |         居飛車の税金 | {tag_name: "居飛車の税金", win_count: 3, win_ratio: 0.6, draw_count: 0, freq_count: 5, freq_ratio: 0.09615384615384616, lose_count: 2, win_lose_count: 5}                   |
# >> |             下段の香 | {tag_name: "下段の香", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 2, win_lose_count: 2}                      |
# >> |             控えの桂 | {tag_name: "控えの桂", win_count: 2, win_ratio: 0.6666666666666666, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 1, win_lose_count: 3}       |
# >> |                 裾銀 | {tag_name: "裾銀", win_count: 3, win_ratio: 0.42857142857142855, draw_count: 0, freq_count: 7, freq_ratio: 0.1346153846153846, lose_count: 4, win_lose_count: 7}            |
# >> |             四間飛車 | {tag_name: "四間飛車", win_count: 2, win_ratio: 0.25, draw_count: 0, freq_count: 8, freq_ratio: 0.15384615384615383, lose_count: 6, win_lose_count: 8}                      |
# >> |       角交換振り飛車 | {tag_name: "角交換振り飛車", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 3, win_lose_count: 3}                |
# >> |             美濃囲い | {tag_name: "美濃囲い", win_count: 1, win_ratio: 0.3333333333333333, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 2, win_lose_count: 3}       |
# >> |         手損角交換型 | {tag_name: "手損角交換型", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 3, win_lose_count: 3}                  |
# >> |               金矢倉 | {tag_name: "金矢倉", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                        |
# >> |         手得角交換型 | {tag_name: "手得角交換型", win_count: 3, win_ratio: 1.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 0, win_lose_count: 3}                  |
# >> |           こびん攻め | {tag_name: "こびん攻め", win_count: 2, win_ratio: 0.2222222222222222, draw_count: 0, freq_count: 9, freq_ratio: 0.17307692307692307, lose_count: 7, win_lose_count: 9}      |
# >> |                 腹銀 | {tag_name: "腹銀", win_count: 1, win_ratio: 0.5, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 1, win_lose_count: 2}                          |
# >> |               逆棒銀 | {tag_name: "逆棒銀", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                        |
# >> |             ロケット | {tag_name: "ロケット", win_count: 3, win_ratio: 1.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 0, win_lose_count: 3}                      |
# >> |          2段ロケット | {tag_name: "2段ロケット", win_count: 3, win_ratio: 1.0, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 0, win_lose_count: 3}                   |
# >> |           原始中飛車 | {tag_name: "原始中飛車", win_count: 2, win_ratio: 1.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 0, win_lose_count: 2}                    |
# >> |           相振り飛車 | {tag_name: "相振り飛車", win_count: 4, win_ratio: 0.5, draw_count: 0, freq_count: 8, freq_ratio: 0.15384615384615383, lose_count: 4, win_lose_count: 8}                     |
# >> |             背水の陣 | {tag_name: "背水の陣", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                      |
# >> |               早石田 | {tag_name: "早石田", win_count: 1, win_ratio: 0.3333333333333333, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 2, win_lose_count: 3}         |
# >> |               袖飛車 | {tag_name: "袖飛車", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 2, win_lose_count: 2}                        |
# >> |             舟囲いDX | {tag_name: "舟囲いDX", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |       米長流急戦矢倉 | {tag_name: "米長流急戦矢倉", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                |
# >> |             カニ囲い | {tag_name: "カニ囲い", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |             金頭の桂 | {tag_name: "金頭の桂", win_count: 1, win_ratio: 0.3333333333333333, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 2, win_lose_count: 3}       |
# >> |             金底の歩 | {tag_name: "金底の歩", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |             腰掛け銀 | {tag_name: "腰掛け銀", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |     ノーマル四間飛車 | {tag_name: "ノーマル四間飛車", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}              |
# >> |         石田流本組み | {tag_name: "石田流本組み", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                  |
# >> |               嬉野流 | {tag_name: "嬉野流", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                        |
# >> |             位の確保 | {tag_name: "位の確保", win_count: 2, win_ratio: 0.6666666666666666, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 1, win_lose_count: 3}       |
# >> |               金無双 | {tag_name: "金無双", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                        |
# >> |               舟囲い | {tag_name: "舟囲い", win_count: 2, win_ratio: 1.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 0, win_lose_count: 2}                        |
# >> |           たすきの銀 | {tag_name: "たすきの銀", win_count: 1, win_ratio: 0.5, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 1, win_lose_count: 2}                    |
# >> |             原始棒銀 | {tag_name: "原始棒銀", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |                 棒銀 | {tag_name: "棒銀", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                          |
# >> |             新嬉野流 | {tag_name: "新嬉野流", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 2, freq_ratio: 0.038461538461538464, lose_count: 2, win_lose_count: 2}                      |
# >> |               鳥刺し | {tag_name: "鳥刺し", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                        |
# >> |               対穴熊 | {tag_name: "対穴熊", win_count: 2, win_ratio: 0.6666666666666666, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 1, win_lose_count: 3}         |
# >> |             レグスペ | {tag_name: "レグスペ", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                      |
# >> |         振り飛車穴熊 | {tag_name: "振り飛車穴熊", win_count: 1, win_ratio: 0.3333333333333333, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 2, win_lose_count: 3}   |
# >> |                 穴熊 | {tag_name: "穴熊", win_count: 1, win_ratio: 0.3333333333333333, draw_count: 0, freq_count: 3, freq_ratio: 0.057692307692307696, lose_count: 2, win_lose_count: 3}           |
# >> |         居飛車金無双 | {tag_name: "居飛車金無双", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                  |
# >> |      初手▲7八飛戦法 | {tag_name: "初手▲7八飛戦法", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}               |
# >> |           居飛車銀冠 | {tag_name: "居飛車銀冠", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                    |
# >> |           地下鉄飛車 | {tag_name: "地下鉄飛車", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                    |
# >> |             三間飛車 | {tag_name: "三間飛車", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                      |
# >> |      5筋位取り中飛車 | {tag_name: "5筋位取り中飛車", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}               |
# >> |         中飛車左穴熊 | {tag_name: "中飛車左穴熊", win_count: 1, win_ratio: 1.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 0, win_lose_count: 1}                  |
# >> |     2手目△3ニ飛戦法 | {tag_name: "2手目△3ニ飛戦法", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}              |
# >> |           高美濃囲い | {tag_name: "高美濃囲い", win_count: 0, win_ratio: 0.0, draw_count: 0, freq_count: 1, freq_ratio: 0.019230769230769232, lose_count: 1, win_lose_count: 1}                    |
# >> |----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
