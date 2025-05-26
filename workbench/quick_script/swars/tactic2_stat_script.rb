require "./setup"
QuickScript::Swars::Tactic2StatScript.new({}, {batch_limit: 1}).cache_write
tp QuickScript::Swars::Tactic2StatScript.new.aggregate
exit


user1 = Swars::User.create!(grade_key: "九段")
user2 = Swars::User.create!(grade_key: "八段")
battle = ::Swars::Battle.create_with_members!([user1, user2], {strike_plan: "原始棒銀"})
# battles = QuickScript::Swars::Tactic2StatScript.mock_setup # => #<Swars::Battle id: 61921042, key: "4e8081e5985f7ed428f876392774e9c1", battled_at: "2025-05-25 15:16:46.000000000 +0900", csa_seq: [], win_user_id: 1074691, turn_max: 31, meta_info: {}, created_at: "2025-05-25 15:16:46.000000000 +0900", updated_at: "2025-05-25 15:16:46.000000000 +0900", start_turn: nil, critical_turn: 13, sfen_body: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", image_turn: nil, outbreak_turn: 15, accessed_at: "2025-05-25 15:16:45.000000000 +0900", sfen_hash: "d076fd22e835a36e988c9a6688ece3e1", xmode_id: 1, preset_id: 1, rule_id: 1, final_id: 1, analysis_version: 3, starting_position: nil, imode_id: 1, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil>
ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
# ids = Swars::Membership.last(1000).collect(&:id)
# scope = Swars::Membership.where(id: Swars::Membership.last(1).collect(&:id))

scope = Swars::Membership.where(id: ids)
e = QuickScript::Swars::Tactic2StatScript.new({}, {scope: scope})
counts_hash, membership_counts_hash = e.aggregate_now
counts_hash
tp membership_counts_hash

hv = counts_hash # => 
tp hv
hv = hv.group_by { |(grade_key, tag_name, judge_key), count| [grade_key, tag_name] } # => 
tp hv
hv = hv.transform_values { |a| a.inject(JudgeInfo.zero_default_hash) { |a, ((_, _, judge_key), count)| a.merge(judge_key.to_sym => count) } } # => 
tp hv

records = hv.collect do |(grade_key, tag_name), e|
  { :grade_key => grade_key, :tag_name => tag_name, **e }
end
tp records

records = records.collect do |e|
  freq_count = e[:win] + e[:lose] + e[:draw]
  win_ratio  = e[:win].fdiv(freq_count)
  item = Bioshogi::Analysis::TacticInfo.flat_lookup(e[:tag_name])
  membership_count = membership_counts_hash[e[:grade_key]]
  {
    :"棋力"      => e[:grade_key],
    :"種類"      => item.human_name,
    :"スタイル"  => item.style_info.name,
    :"名前"      => item.name,
    :"勝率"      => win_ratio,
    :"頻度"      => freq_count.fdiv(membership_count),
    :"出現数"    => freq_count,
    # **e,
  }
end
tp records
# exit

# ここまでを保存しておく

records = records.find_all { |e| e[:"種類"].in?(["戦法", "囲い"]) }
tp records

records_per_grades = records.group_by { |e| e[:"棋力"].to_sym }.transform_values { |e| e.sort_by { |e| -e[:"勝率"] } }
records_per_grades              # => 
tp records_per_grades
top_n = records_per_grades.values.collect(&:size).max # => 

grade_infos = ::Swars::GradeInfo.find_all(&:gteq10).sort_by(&:priority)
grade_infos                     # => 

rankings = top_n.times.collect do |i|
  hv = {}
  hv["#"] = i.next
  grade_infos.each do |grade_info|
    hv[grade_info.key] = records_per_grades.dig(grade_info.key, i, :"名前")
  end
  hv
end
tp rankings # => 

# >> 2025-05-25 17:38:46 1/1019   0.10 % T1 Tactic2StatScript
# >> 2025-05-25 17:38:47 2/1019   0.20 % T0 Tactic2StatScript
# >> 2025-05-25T08:38:47.230Z pid=2072 tid=ds INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |     day7 | {records: [], memberships_count: 0, win_lose_draw_total: 0}                                                                                                                                                                                                                 |
# >> |    day30 | {records: [{tag_name: "三間飛車", win_count: 15860, win_ratio: 0.4941271769947347, draw_count: 91, freq_count: 32097, freq_ratio: 0.03258036225440637, lose_count: 16146}, {tag_name: "居玉", win_count: 87595, win_ratio: 0.4835842483865803, draw_count: 287, freq_c...   |
# >> |    day60 | {records: [{tag_name: "ツノ銀雁木", win_count: 14069, win_ratio: 0.4930263526773198, draw_count: 89, freq_count: 28536, freq_ratio: 0.010680807932603412, lose_count: 14378}, {tag_name: "居飛車", win_count: 793297, win_ratio: 0.4972825814410656, draw_count: 4668, f... |
# >> | infinite | {records: [{tag_name: "新嬉野流", win_count: 32973, win_ratio: 0.5111221342096697, draw_count: 165, freq_count: 64511, freq_ratio: 0.01774748290067121, lose_count: 31373}, {tag_name: "居飛車", win_count: 1081001, win_ratio: 0.4971673902645425, draw_count: 6773, f...  |
# >> |----------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
