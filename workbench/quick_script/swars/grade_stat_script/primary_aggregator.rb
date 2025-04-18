require "./setup"

scope = Swars::Membership.where(id: Swars::Membership.last(200).collect(&:id))
instance = QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(scope: scope)
tp instance.aggregate
# tp instance.aggregate[:counts_hash].values.sum { |e| e[:membership][:__tag_nothing__] } # => 196
# tp instance.aggregate[:counts_hash].values.sum { |e| e[:user][:__tag_nothing__] }       # => 124
exit

# p _ { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(batch_size: 500000).call }
# p QuickScript::Swars::GradeStatScript::PrimaryAggregator.new.population_count
# p QuickScript::Swars::GradeStatScript::PrimaryAggregator.new.call
# scope = Swars::Membership.where(id: Swars::Membership.last(200).collect(&:id))
# _ { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(scope: scope).call } # => "32.49 ms"
# s { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(scope: scope).call } # => {:memberships_count=>2, :counts_hash=>{"三段"=>{"__tag_nothing__"=>1, "高美濃囲い"=>1, "振り飛車"=>1, "大駒コンプリート"=>1, "対居飛車"=>1, "対抗形"=>1, "持久戦"=>1, "長手数"=>1, "割り打ちの銀"=>1}, "四段"=>{"__tag_nothing__"=>1, "対振り持久戦"=>1, "舟囲い"=>1, "居飛車"=>1, "対振り飛車"=>1, "大駒全ブッチ"=>1, "対抗形"=>1, "持久戦"=>1, "長手数"=>1}}, :primary_aggregated_at=>Sun, 25 Aug 2024 10:48:23.623478000 JST +09:00, :primary_aggregation_second=>0.006454}

# Swars::Battle.order(id: :desc).limit(30).destroy_all

s = Swars::Membership.where(id: Swars::Membership.unscoped.last(5).collect(&:id))
s.group("user_id").count # =>
tp s.collect(&:info)

s.count # =>
s.joins(:grade).group("swars_grades.key").count # =>
tp s.joins(:grade).group("swars_grades.key").joins(:taggings => :tag).group("tags.name").count # =>

# sql
s.joins(:grade).select(:user_id, "swars_grades.key").distinct.count # =>

s.joins(:grade).select(:user_id, "swars_grades.key").distinct.group("swars_grades.key").count # =>
tp s.joins(:grade).select(:user_id, "swars_grades.key").distinct.group("swars_grades.key").joins(:taggings => :tag).group("tags.name").count # =>
# >> [2024-10-27 19:09:26][QuickScript::Swars::GradeStatScript::PrimaryAggregator] Processing relation #0
# >> |------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | 10級 | {:user=>{:__tag_nothing__=>2, "対居飛車"=>2, "居玉"=>1, "居飛車"=>2, "急戦"=>1, "持久戦"=>1, "相居飛車"=>2, "矢倉早囲い"=>1, "短手数"=>1, "総矢倉"=>1, "角換わり"=>1, "長手数"=>1}, :membership=>{:__tag_nothing__=>2, "角換わり"=>1, "居玉"=>1, "居飛車"=>2, "相居飛車"=>2, "対居飛車"=>2, "急戦"=>1, "長手数"=>1, "矢倉早囲い...                                  |
# >> |  1級 | {:user=>{:__tag_nothing__=>21, "5筋位取り中飛車"=>1, "UFO銀"=>1, "ふんどしの桂"=>6, "へなちょこ急戦"=>1, "カニ囲い"=>1, "ツノ銀雁木"=>1, "三間飛車"=>1, "初手7八銀戦法"=>1, "初手▲7八飛戦法"=>1, "力戦"=>4, "原始棒銀"=>2, "右四間飛車"=>2, "右玉"=>1, "向かい飛車"=>1, "四間飛車"=>2, "垂れ歩"=>7, "大駒コンプリート"=>6, "大駒全ブッチ"=>5, "対居飛車"=...       |
# >> |  2級 | {:user=>{:__tag_nothing__=>23, "5筋位取り中飛車"=>2, "ふんどしの桂"=>2, "カブト囲い"=>2, "三間飛車"=>1, "初手7八銀戦法"=>1, "力戦"=>8, "原始中飛車"=>2, "原始棒銀"=>1, "右四間飛車"=>1, "右四間飛車急戦"=>1, "向かい飛車"=>2, "四間飛車"=>3, "垂れ歩"=>2, "大駒コンプリート"=>2, "大駒全ブッチ"=>1, "対居飛車"=>14, "対抗形"=>14, "対振り持久戦"=>1, "対振り飛...   |
# >> |  3級 | {:user=>{:__tag_nothing__=>9, "5筋位取り中飛車"=>2, "ふんどしの桂"=>4, "カニ囲い"=>1, "パックマン戦法"=>1, "レグスペ"=>1, "中住まい"=>1, "力戦"=>1, "右四間飛車"=>2, "向かい飛車"=>1, "四間飛車"=>2, "垂れ歩"=>2, "大駒全ブッチ"=>1, "嬉野流"=>1, "対居飛車"=>6, "対抗形"=>4, "対振り飛車"=>4, "居玉"=>4, "居飛車"=>6, "左美濃"=>1, "急戦"=>8, "持久...             |
# >> |  4級 | {:user=>{:__tag_nothing__=>4, "初手7八銀戦法"=>1, "原始棒銀"=>1, "四間飛車"=>2, "大駒コンプリート"=>2, "対居飛車"=>4, "対抗形"=>2, "居玉"=>1, "居飛車"=>2, "左美濃"=>1, "急戦"=>4, "振り飛車"=>2, "棒銀"=>2, "相居玉"=>1, "相居飛車"=>2, "短手数"=>3, "美濃囲い"=>1, "腰掛け銀"=>1, "角換わり早繰り銀"=>1, "長手数"=>1, "高美濃囲い"=>1}, :memb...                  |
# >> |  5級 | {:user=>{:__tag_nothing__=>3, "一手損角換わり"=>1, "力戦"=>1, "原始棒銀"=>1, "右四間飛車"=>2, "右四間飛車急戦"=>1, "右玉"=>1, "垂れ歩"=>2, "大駒コンプリート"=>1, "大駒全ブッチ"=>1, "対居飛車"=>3, "対抗形"=>1, "対振り持久戦"=>1, "対振り飛車"=>1, "居玉"=>3, "居飛車"=>3, "左山囲い"=>1, "急戦"=>2, "持久戦"=>1, "桂頭の銀"=>1, "棒銀"=>1, "相居玉...            |
# >> |  6級 | {:user=>{:__tag_nothing__=>5, "5筋位取り中飛車"=>1, "はく式四間飛車"=>1, "原始棒銀"=>1, "四間飛車"=>1, "垂れ歩"=>3, "大駒コンプリート"=>1, "大駒全ブッチ"=>1, "嬉野流"=>1, "対居飛車"=>4, "対抗形"=>3, "対振り飛車"=>2, "居玉"=>1, "居飛車"=>2, "居飛車穴熊"=>1, "急戦"=>4, "手損角交換型"=>1, "持久戦"=>2, "振り飛車"=>3, "桂頭の銀"=>1, "棒銀"=>2, ...            |
# >> |  7級 | {:user=>{:__tag_nothing__=>1, "対振り飛車"=>1, "手得角交換型"=>1, "持久戦"=>1, "振り飛車"=>1, "早石田"=>1, "桂頭の銀"=>1, "相振り飛車"=>1, "長手数"=>1}, :membership=>{:__tag_nothing__=>1, "早石田"=>1, "手得角交換型"=>1, "対振り飛車"=>1, "振り飛車"=>1, "相振り飛車"=>1, "持久戦"=>1, "長手数"=>1, "桂頭の銀"=>1}}                                              |
# >> |  8級 | {:user=>{:__tag_nothing__=>1, "四間飛車"=>1, "対居飛車"=>1, "対抗形"=>1, "急戦"=>1, "振り飛車"=>1, "桂頭の銀"=>1, "片美濃囲い"=>1, "長手数"=>1}, :membership=>{:__tag_nothing__=>1, "四間飛車"=>1, "片美濃囲い"=>1, "振り飛車"=>1, "対居飛車"=>1, "対抗形"=>1, "急戦"=>1, "長手数"=>1, "桂頭の銀"=>1}}                                                              |
# >> | 七段 | {:user=>{:__tag_nothing__=>2, "5筋位取り中飛車"=>1, "ふんどしの桂"=>1, "三間飛車"=>1, "力戦"=>1, "垂れ歩"=>1, "大駒コンプリート"=>1, "大駒全ブッチ"=>1, "対居飛車"=>2, "対抗形"=>2, "対振り飛車"=>2, "居飛車"=>1, "急戦"=>2, "持久戦"=>2, "振り飛車"=>1, "振り飛車穴熊"=>1, "桂頭の銀"=>1, "相居飛車"=>1, "相振り飛車"=>1, "短手数"=>2, "美濃囲い"=>1,...           |
# >> | 三段 | {:user=>{:__tag_nothing__=>11, "5筋位取り中飛車"=>1, "ちょんまげ美濃"=>1, "カニ囲い"=>1, "三間飛車"=>2, "入玉"=>1, "力戦"=>1, "右四間飛車"=>1, "右玉"=>1, "向かい飛車"=>2, "四間飛車"=>5, "垂れ歩"=>3, "大駒コンプリート"=>1, "大駒全ブッチ"=>2, "対居飛車"=>7, "対抗形"=>6, "対振り飛車"=>5, "居飛車"=>3, "幽霊角"=>1, "急戦"=>2, "持久戦"=>9, "振...              |
# >> | 九段 | {:user=>{:__tag_nothing__=>1, "UFO銀"=>1, "入玉"=>1, "対居飛車"=>1, "居飛車"=>1, "持久戦"=>1, "相居飛車"=>1, "相掛かり棒銀"=>1, "金底の歩"=>1, "長手数"=>1}, :membership=>{:__tag_nothing__=>1, "相掛かり棒銀"=>1, "UFO銀"=>1, "居飛車"=>1, "入玉"=>1, "相居飛車"=>1, "対居飛車"=>1, "持久戦"=>1, "長手数"=>1, "金底の歩"=>1...                                     |
# >> | 二段 | {:user=>{:__tag_nothing__=>9, "5筋位取り中飛車"=>1, "ふんどしの桂"=>1, "エルモ囲い"=>1, "ダイレクト向かい飛車"=>1, "一手損角換わり"=>1, "中原囲い"=>1, "中飛車左穴熊"=>1, "入玉"=>1, "右四間飛車"=>2, "向かい飛車"=>1, "垂れ歩"=>3, "大駒コンプリート"=>1, "大駒全ブッチ"=>2, "対居飛車"=>4, "対抗形"=>4, "対振り飛車"=>6, "居玉"=>1, "居飛車"=>4, "居飛車穴熊"=... |
# >> | 五段 | {:user=>{:__tag_nothing__=>6, "▲3七銀戦法"=>1, "四枚美濃"=>1, "四枚銀冠"=>1, "垂れ歩"=>2, "大駒全ブッチ"=>1, "対居飛車"=>2, "対抗形"=>4, "対振り持久戦"=>1, "対振り飛車"=>4, "居飛車"=>6, "左美濃"=>2, "急戦"=>2, "持久戦"=>4, "相居飛車"=>2, "短手数"=>1, "端棒銀"=>1, "糸谷流右玉"=>1, "腰掛け銀"=>1, "舟囲い"=>1, "金矢倉"=>1, "銀立ち矢倉"=>...                |
# >> | 八段 | {:user=>{:__tag_nothing__=>1, "オールド雁木"=>1, "割り打ちの銀"=>1, "力戦"=>1, "大駒コンプリート"=>1, "対居飛車"=>1, "居飛車"=>1, "急戦"=>1, "持久戦"=>1, "相居飛車"=>1, "長手数"=>1}, :membership=>{:__tag_nothing__=>3, "力戦"=>2, "居飛車"=>3, "相居飛車"=>3, "対居飛車"=>3, "持久戦"=>2, "長手数"=>3, "割り打ちの銀"=>1, "オールド...                           |
# >> | 六段 | {:user=>{:__tag_nothing__=>3, "2手目△7四歩戦法"=>1, "初手3六歩戦法"=>1, "割り打ちの銀"=>1, "垂れ歩"=>1, "大駒コンプリート"=>1, "対居飛車"=>1, "対抗形"=>3, "対振り持久戦"=>1, "対振り飛車"=>3, "居飛車"=>3, "左美濃"=>1, "急戦"=>1, "持久戦"=>2, "振り飛車"=>1, "桂頭の銀"=>1, "相居飛車"=>1, "相振り飛車"=>1, "短手数"=>1, "端棒銀"=>1, "舟囲い"=>1...            |
# >> | 初段 | {:user=>{:__tag_nothing__=>21, "5筋位取り中飛車"=>1, "UFO銀"=>2, "ふんどしの桂"=>5, "やばボーズ流"=>1, "エルモ囲い"=>1, "カブト囲い"=>1, "ボナンザ囲い"=>2, "三間飛車"=>2, "中住まい"=>1, "串カツ囲い"=>1, "入玉"=>1, "初手▲7八飛戦法"=>1, "割り打ちの銀"=>2, "力戦"=>1, "原始棒銀"=>2, "右四間飛車"=>3, "右四間飛車急戦"=>3, "向かい飛車"=>2, "四枚美濃"=...      |
# >> | 四段 | {:user=>{:__tag_nothing__=>6, "2手目△3ニ飛戦法"=>1, "へなちょこ急戦"=>1, "カブト囲い"=>1, "力戦"=>2, "向かい飛車"=>1, "四間飛車"=>1, "地下鉄飛車"=>1, "垂れ歩"=>2, "大駒コンプリート"=>1, "大駒全ブッチ"=>1, "対居飛車"=>5, "対抗形"=>3, "対振り飛車"=>2, "居玉"=>2, "居飛車"=>5, "急戦"=>4, "持久戦"=>3, "振り飛車"=>2, "振り飛車穴熊"=>1, "桂頭の銀"=...         |
# >> |------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
