module MigrateHelper
  extend self

  # cap production deploy:upload FILES=app/models/migrate_helper.rb
  # cap staging    deploy:upload FILES=app/models/migrate_helper.rb

  # rails r MigrateHelper.run1
  # rails r "tp Swars::Battle"
  # rails r "tp Swars::Membership"
  def run1
    Swars::Rule.unscoped.find_each do |rule|
      tp rule
      Swars::Battle.where(rule_id: nil).where(rule_key: rule.key).update_all(rule_id: rule.id)
    end
    Swars::Final.unscoped.find_each do |final|
      tp final
      Swars::Battle.where(final_id: nil).where(final_key: final.key).update_all(final_id: final.id)
    end
    Preset.unscoped.find_each do |preset|
      tp preset
      Swars::Battle.where(preset_id: nil).where(preset_key: preset.key).update_all(preset_id: preset.id)
      FreeBattle.where(preset_id: nil).where(preset_key: preset.key).update_all(preset_id: preset.id)
    end
    Location.unscoped.find_each do |location|
      tp location
      Swars::Membership.where(location_id: nil).where(location_key: location.key).update_all(location_id: location.id)
    end
    Judge.unscoped.find_each do |judge|
      tp judge
      Swars::Membership.where(judge_id: nil).where(judge_key: judge.key).update_all(judge_id: judge.id)
    end

    p Swars::Battle.where(rule_id: nil).count
    p Swars::Battle.where(final_id: nil).count
    p Swars::Battle.where(preset_id: nil).count
    p FreeBattle.where(preset_id: nil).count
    p Swars::Membership.where(location_id: nil).count
    p Swars::Membership.where(judge_id: nil).count
  end
end
