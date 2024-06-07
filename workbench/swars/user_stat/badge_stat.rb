require "./setup"
# tp Swars::User["SugarHuuko"].user_stat.badge_stat.to_debug_hash
# _ { Swars::User["SugarHuuko"].user_stat.badge_stat.as_json } # => "64.36 ms"
# s { Swars::User["SugarHuuko"].user_stat.badge_stat.as_json } # => [{"message"=>"居飛車党", "method"=>"raw", "name"=>"⬆️", "type"=>nil}, {"message"=>"右玉で勝った", "method"=>"raw", "name"=>"➡", "type"=>nil}, {"message"=>"UFO銀で勝った", "method"=>"raw", "name"=>"🛸", "type"=>nil}, {"message"=>"大駒全部捨てて勝った", "method"=>"raw", "name"=>"🧠", "type"=>nil}, {"message"=>"10連勝した", "method"=>"raw", "name"=>"💮", "type"=>nil}, {"message"=>"居玉で勝った", "method"=>"raw", "name"=>"🗿", "type"=>nil}, {"message"=>"開幕千日手をした", "method"=>"raw", "name"=>"❓", "type"=>nil}, {"message"=>"千日手をした", "method"=>"raw", "name"=>"🍌", "type"=>nil}]
# Swars::User["SugarHuuko"].user_stat.win_tag.counts_hash # => {:力戦=>13, :居飛車=>39, :箱入り娘=>1, :銀雲雀=>1, :舟囲い=>6, :居飛車金美濃=>2, :対振り持久戦=>1, :新型雁木=>5, :相掛かり=>1, :▲４五歩早仕掛け=>2, :居玉=>9, :△３三角型空中戦法=>1, :オールド雁木=>1, :原始棒銀=>5, :UFO銀=>5, :角交換型=>3, :角換わり=>1, :右玉=>2, :手得角交換型=>1, :地下鉄飛車=>1, :三段右玉=>1, :垂れ歩=>11, :対振り=>13, :対抗形=>13, :持久戦=>18, :短手数=>17, :急戦=>18, :長手数=>21, :大駒コンプリート=>7, :相居飛車=>26, :継ぎ桂=>2, :腹銀=>1, :ふんどしの桂=>4, :相居玉=>5, :桂頭の銀=>1, :大駒全ブッチ=>1, :背水の陣=>1}

# black = Swars::User.create!
# white = Swars::User.create!
# skill = Bioshogi::Explain::TacticInfo.flat_lookup("ポンポン桂") # => <ポンポン桂>
# info = skill.sample_kif_info
# player = info.container.players.find { |e| e.skill_set.has_skill?(skill) } # => #<Bioshogi::Player:0x000000010d170e18 @container=後手の持駒：金 桂 香
# Swars::Battle.create!(tactic_key: "ポンポン桂") do |e|
#   e.memberships.build(user: black, judge_key: player.location.code == 0 ? :win : :lose)
#   e.memberships.build(user: white, judge_key: player.location.code == 1 ? :win : :lose)
# end
# black.reload.user_stat.all_tag.to_s # => "四間飛車,振り飛車,対抗形,急戦,短手数,ふんどしの桂"
# black.reload.user_stat.win_tag.to_s # => ""
# white.reload.user_stat.all_tag.to_s # => "対振り持久戦,ポンポン桂,箱入り娘,居飛車,対振り,対抗形,急戦,短手数,垂れ歩"
# white.reload.user_stat.win_tag.to_s # => "対振り持久戦,ポンポン桂,箱入り娘,居飛車,対振り,対抗形,急戦,短手数,垂れ歩"

