require "./setup"

if e = ActsAsTaggableOn::Tag.find_by(name: "原始中飛車")
  all_count = e.taggings.count
  e.taggings.in_batches(of: 100) do |relation|
    battle_ids = relation.where(taggable_type: "Swars::Membership").collect { |e| e.taggable.battle_id }.uniq
    Swars::Battle.find(battle_ids).each(&:rebuild)
    exit
  end
end
