require "./setup"
Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.to_win_lose_h(:"角不成", swap: true)   # => {win: 6, lose: 0}
Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.to_win_lose_h(:"飛車不成", swap: true) # => {win: 0, lose: 1}
Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.lose_with?(:"角不成")                    # => true
Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.win_with?(:"角不成")                 # => false
Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.lose_with?(:"飛車不成")                  # => false
Swars::User["chrono_"].stat(sample_max: 1000).op_tag_stat.win_with?(:"飛車不成")               # => true

# op_tag_stat.ratios_hash[:"角不成"] # => 0.3076923076923077
# op_tag_stat.ratios_hash[:"角不成"] # => 0.3076923076923077
# exit
#
# tp Swars::User["BOUYATETSU5"].stat.badge_stat.execution_time_explain
# tp Swars::User["anpirika"].stat.badge_stat.execution_time_explain

# _ { Swars::User["BOUYATETSU5"].stat.badge_stat.as_json } # => "64.36 ms"
# s { Swars::User["BOUYATETSU5"].stat.badge_stat.as_json } # => [{"message"=>"居飛車党", "method"=>"raw", "name"=>"⬆️", "type"=>nil}, {"message"=>"右玉で勝った", "method"=>"raw", "name"=>"➡", "type"=>nil}, {"message"=>"UFO銀で勝った", "method"=>"raw", "name"=>"🛸", "type"=>nil}, {"message"=>"大駒全部捨てて勝った", "method"=>"raw", "name"=>"🧠", "type"=>nil}, {"message"=>"10連勝した", "method"=>"raw", "name"=>"💮", "type"=>nil}, {"message"=>"居玉で勝った", "method"=>"raw", "name"=>"🗿", "type"=>nil}, {"message"=>"開幕千日手をした", "method"=>"raw", "name"=>"❓", "type"=>nil}, {"message"=>"千日手をした", "method"=>"raw", "name"=>"🍌", "type"=>nil}]
