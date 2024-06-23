require "./setup"
ids_scope = Swars::User["bsplive"].stat.style_stat.ids_scope
membership = ids_scope[3]               # => #<Swars::Membership id: 97836968, battle_id: 49030093, user_id: 22122, grade_id: 2, position: 1, created_at: "2024-05-14 22:17:28.000000000 +0900", updated_at: "2024-05-31 18:30:39.000000000 +0900", grade_diff: -4, think_max: 14, op_user_id: 14916, think_last: 2, think_all_avg: 1, think_end_avg: 4, ai_drop_total: 0, judge_id: 1, location_id: 2, style_id: 3, ek_score_without_cond: 5, ek_score_with_cond: nil, ai_wave_count: 0, ai_two_freq: 0.24, ai_noizy_two_max: 3, ai_gear_freq: 0.0, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil, other_tag_list: nil>
info = membership.battle.fast_parsed_info # => * attributes
player = info.container.players.first     # => #<Bioshogi::Player:0x000000011171e320 @container=後手の持駒：なし
# membership.style_update
list = []
list += player.skill_set.attack_infos    # => [<原始中飛車>, <相振り飛車>, <角交換振り飛車>]
list += player.skill_set.defense_infos   # => [<原始中飛車>, <相振り飛車>, <角交換振り飛車>]

Bioshogi::Explain::DistributionRatio[:"向かい飛車"] # => {:index=>12, :name=>:向かい飛車, :count=>2147, :emission_ratio=>0.02413932675226552, :diff_from_avg=>0.02072635746898907, :rarity_key=>:rarity_key_N}
Bioshogi::Explain::DistributionRatio[:"相振り飛車"] # => nil

h = Hash.new(0)
list.each do |e|
  if e = Bioshogi::Explain::DistributionRatio[e.key]
    h[e[:rarity_key]] += 1
  end
end
h                               # => {:rarity_key_N=>2}



        # rarity_infos = infos.collect { |e|
        #   if e = Bioshogi::Explain::DistributionRatio[e.key]
        #     RarityInfo.fetch(e[:rarity_key])
        #   end
        # }.compact
        # 
        # # 複数ある場合は rarity_info.code の小さいものにする
        # if rarity_info = rarity_infos.min_by(&:code)
        #   self.style = rarity_info.style_info.db_record!
        # else
        #   self.style = nil
        # end
  

