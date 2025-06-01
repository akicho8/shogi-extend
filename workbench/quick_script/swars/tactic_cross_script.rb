require "./setup"
QuickScript::Swars::TacticCrossScript.new.cache_write
exit

_ { QuickScript::Swars::TacticCrossScript.new({ show_type: "debug2" }).call } # => "260.43 ms"
exit

QuickScript::Swars::TacticCrossScript.new({}, { batch_limit: 1 }).cache_write
tp QuickScript::Swars::TacticCrossScript.new.aggregate
exit

user1 = Swars::User.create!(grade_key: "九段")
user2 = Swars::User.create!(grade_key: "八段")
battle = ::Swars::Battle.create_with_members!([user1, user2], { strike_plan: "原始棒銀" })
# battles = QuickScript::Swars::TacticCrossScript.mock_setup # => #<Swars::Battle id: 61921042, key: "4e8081e5985f7ed428f876392774e9c1", battled_at: "2025-05-25 15:16:46.000000000 +0900", csa_seq: [], win_user_id: 1074691, turn_max: 31, meta_info: {}, created_at: "2025-05-25 15:16:46.000000000 +0900", updated_at: "2025-05-25 15:16:46.000000000 +0900", start_turn: nil, critical_turn: 13, sfen_body: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPP...", image_turn: nil, outbreak_turn: 15, accessed_at: "2025-05-25 15:16:45.000000000 +0900", sfen_hash: "d076fd22e835a36e988c9a6688ece3e1", xmode_id: 1, preset_id: 1, rule_id: 1, final_id: 1, analysis_version: 3, starting_position: nil, imode_id: 1, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil>
ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
# ids = Swars::Membership.last(1000).collect(&:id)
# scope = Swars::Membership.where(id: Swars::Membership.last(1).collect(&:id))

scope = Swars::Membership.where(id: ids)
e = QuickScript::Swars::TacticCrossScript.new({}, { scope: scope })
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

grade_infos = ::Swars::GradeInfo.find_all(&:range_10kyu_to_9dan).sort_by(&:priority)
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
