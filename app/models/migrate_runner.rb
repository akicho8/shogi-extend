# cap production deploy:upload FILES=app/models/migrate_runner.rb
# cap staging    deploy:upload FILES=app/models/migrate_runner.rb
# rails r MigrateRunner.new.call
# rails r "tp Swars::Battle"
# rails r "tp Swars::Membership"

class MigrateRunner
  def call
    run2
    run3
    nil
  end

  def run2
    # if e = ActsAsTaggableOn::Tag.find_by(name: "ロケット")
    #   e.taggings.in_batches do |relation|
    #     p relation.count
    #     relation.where(context: "technique_tags").each do |e|
    #       e.update!(context: "note_tags")
    #     end
    #   end
    # end
    # t = ActsAsTaggableOn::Tag.find_by(name: "ロケット")
    # p t.taggings_count
    # p t.taggings.count

    [
      "大隅囲い",
      "三手囲い",
      "高田流左玉",
      "ロケット",
    ].each do |name|
      tag_delete(name)
    end

    {
      "33金型早繰り銀" => "△3三金型早繰り銀",
      "▲７二飛亜急戦" => "△7二飛亜急戦",
      "▲７八飛戦法"   => "初手▲7八飛戦法",
      "▲８五飛車戦法" => "中座飛車",
      "かまいたち戦法" => "英春流かまいたち戦法",
      "久夢流"         => "間宮久夢流",
      "４→３戦法"     => "戸部流4→3戦法",
      "５筋位取り"     => "5筋位取り",
      "６筋位取り"     => "6筋位取り",
    }.each do |from, to|
      p [from, to]
      ActsAsTaggableOn::Tag.find_by(name: from)&.update!(name: to)
    end
  end

  def run3
    # AppLog.important("#{user_key} start")
    s = Swars::Battle.all
    s = s.where(Swars::Battle.arel_table[:updated_at].lt(Time.parse("2024/10/18 00:00")))
    all_count = s.count.ceildiv(1000)
    s.in_batches(use_ranges: true).each_with_index do |relation, batch|
      p [batch, all_count, batch.fdiv(all_count)]
      relation.each(&:rebuild)
      puts
    end
  end

  def tag_delete(name)
    p [:tag_delete, name]
    if e = ActsAsTaggableOn::Tag.find_by(name: name)
      e.taggings.in_batches do |relation|
        relation.where(taggable_type: "Swars::Membership").destroy_all
      end
    end
  end

  # def run1
  #   Swars::Rule.unscoped.find_each do |rule|
  #     tp rule
  #     Swars::Battle.where(rule_id: nil).where(rule_key: rule.key).update_all(rule_id: rule.id)
  #   end
  #   Swars::Final.unscoped.find_each do |final|
  #     tp final
  #     Swars::Battle.where(final_id: nil).where(final_key: final.key).update_all(final_id: final.id)
  #   end
  #   Preset.unscoped.find_each do |preset|
  #     tp preset
  #     Swars::Battle.where(preset_id: nil).where(preset_key: preset.key).update_all(preset_id: preset.id)
  #     FreeBattle.where(preset_id: nil).where(preset_key: preset.key).update_all(preset_id: preset.id)
  #   end
  #   Location.unscoped.find_each do |location|
  #     tp location
  #     Swars::Membership.where(location_id: nil).where(location_key: location.key).update_all(location_id: location.id)
  #   end
  #   Judge.unscoped.find_each do |judge|
  #     tp judge
  #     Swars::Membership.where(judge_id: nil).where(judge_key: judge.key).update_all(judge_id: judge.id)
  #   end
  #
  #   p Swars::Battle.where(rule_id: nil).count
  #   p Swars::Battle.where(final_id: nil).count
  #   p Swars::Battle.where(preset_id: nil).count
  #   p FreeBattle.where(preset_id: nil).count
  #   p Swars::Membership.where(location_id: nil).count
  #   p Swars::Membership.where(judge_id: nil).count
  # end
end
