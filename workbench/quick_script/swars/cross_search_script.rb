require "./setup"

puts "#{QuickScript::Swars::CrossSearchScript::TagCondInfo[:and]}"
exit

QuickScript::Swars::CrossSearchScript.new.bookmark_url # => "http://localhost:4000/lab/swars/cross-search?bg_request_key=&bookmark_url_key=false&download_key=&exec=true&final_keys=&open_action_key=&preset_keys=&query=&range_size=&request_size=&rule_keys=&x_grade_diff_key=&x_grade_keys=&x_judge_keys=&x_style_keys=&x_tags=&x_tags_cond_key=&x_user_keys=&xmode_keys=&y_grade_keys=&y_style_keys=&y_tags=&y_tags_cond_key=&y_user_keys="
puts QuickScript::Swars::CrossSearchScript.new.mail_body

# _ { ::Swars::User.where(key: "bsplive") } # => "7.26 ms"
# exit
# sql
# p QuickScript::Swars::CrossSearchScript.new(x_user_keys: "bsplive", exec: "true").call

# puts QuickScript::Swars::CrossSearchScript.new.empty_message # => nil
# puts QuickScript::Swars::CrossSearchScript.new.empty_message # => nil
# exit

# QuickScript::Swars::CrossSearchScript.new({exec: "true", download_key: "on"}, {current_user: User.admin}).mail_notify
# exit

# tp Swars::Battle.group(:preset).count.keys.collect(&:name)
# QuickScript::Swars::CrossSearchScript.new(x_style_keys: "王道").x_style_infos.collect(&:name) # => ["王道"]
# exit

# ::Swars::Xmode["野良"]          # =>

# QuickScript::Swars::CrossSearchScript.new(x_tags: "居飛車", exec: "true", _method: "get").as_json[:redirect_to][:to] # =>
# _ { QuickScript::Swars::CrossSearchScript.new(x_tags: "居飛車", exec: "true", _method: "get").all_ids } # =>
# _ { QuickScript::Swars::CrossSearchScript.new(x_tags: "居飛車", exec: "true", _method: "get").all_ids } # =>
# sql
# QuickScript::Swars::CrossSearchScript.new(x_tags: "居飛車", x_judge_keys: "勝ち", exec: "true", _method: "get").all_ids.size # =>
# >> http://localhost:4000/swars/search?query=id%3A50130657%2C50130658%2C50130659%2C50130660%2C50130661%2C50130662%2C50130663%2C50130664%2C50130665%2C50130666%2C50130667%2C50130668%2C50130669%2C50130670%2C50130671%2C50130672%2C50130673%2C50130674%2C50130675%2C50130676%2C50130677%2C50130678%2C50130679%2C50130680%2C50130681%2C50130682%2C50130683%2C50130684%2C50130685%2C50130686%2C50130687%2C50130688%2C50130689%2C50130690%2C50130691%2C50130692%2C50130694%2C50130695%2C50130696%2C50130697%2C50130698%2C50130699%2C50130700%2C50130701%2C50130702%2C50130703%2C50130704%2C50130705%2C50130706%2C50130707
# >> 
# >> 検索対象件数: 10000
# >> 抽出希望件数: 50
# >> 結果表示: 同じタブで開く
# >> ZIPダウンロード: しない
# >> バックグラウンド実行: しない
# >> 抽出: 50
# >> 
# >> ▼再実行用URL (ブックマーク用URL)
# >> http://localhost:4000/lab/swars/cross-search?bg_request_key=&bookmark_url_key=false&download_key=&exec=true&final_keys=&open_action_key=&preset_keys=&query=&range_size=&request_size=&rule_keys=&x_grade_diff_key=&x_grade_keys=&x_judge_keys=&x_style_keys=&x_tags=&x_tags_cond_key=&x_user_keys=&xmode_keys=&y_grade_keys=&y_style_keys=&y_tags=&y_tags_cond_key=&y_user_keys=
