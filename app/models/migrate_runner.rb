# ▼ローカル更新
# rails r MigrateRunner.new.call

# ▼本番更新
# cap production deploy:upload FILES=app/models/migrate_runner.rb
# RAILS_ENV=production bundle exec bin/rails r 'MigrateRunner.new.call'
# RAILS_ENV=production nohup bundle exec bin/rails r 'MigrateRunner.new.call' &
# tailf nohup.out

class MigrateRunner
  def call
    public_methods.grep(/\A(step\w+)/).sort.each do |e|
      p [Time.now.to_s, e, :begin]
      ms = Benchmark.ms { public_send(e) }
      AppLog.important("[#{e}][完了] (#{ms})")
      p [Time.now.to_s, e, :end]
    end
    nil
  end

  # def step1
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

  # def step1_delete
  #   [
  #     # "大隅囲い",
  #     # "三手囲い",
  #     # "高田流左玉",
  #     # "ロケット",
  #     # "手得角交換型",
  #     # "手損角交換型",
  #     # "角交換型",
  #     # "角換わり新型",
  #     # "新丸山ワクチン",
  #     # "矢倉左美濃急戦",
  #     "2手目△6二銀戦法",
  #   ].each do |name|
  #     tag_delete(name)
  #   end
  # end

  # def step2_rename
  #   list = {
  #     # "中田功XP"           => "コーヤン流三間飛車",
  #     # "平目"               => "ヒラメ戦法",
  #     # "急戦棒銀"           => "対矢倉急戦棒銀",
  #     # '▲3七銀戦法'        => "矢倉▲3七銀戦法",
  #     # "▲５五龍中飛車"     => "▲5五龍中飛車",
  #     # "▲３七銀戦法"       => "▲3七銀戦法",
  #     # "都成流△３一金"     => "都成流△3一金",
  #     # "△３三角型空中戦法" => "△3三角型空中戦法",
  #     # "△３三桂戦法"       => "△3三桂戦法",
  #     # "△２三歩戦法"       => "△2三歩戦法",
  #     # "△４五角戦法"       => "△4五角戦法",
  #     # "▲５七金戦法"       => "▲5七金戦法",
  #     # "△３三飛戦法"       => "△3三飛戦法",
  #     # "菜々河流△４四角"   => "菜々河流△4四角",
  #     # "天彦流▲６六角"     => "天彦流▲6六角",
  #     # "▲４六銀右急戦"     => "▲4六銀右急戦",
  #     # "▲４六銀左急戦"     => "▲4六銀左急戦",
  #     # "▲４五歩早仕掛け"   => "▲4五歩早仕掛け",
  #     # "超速▲３七銀"       => "超速▲3七銀戦法",
  #     # "超速▲3七銀"        => "超速▲3七銀戦法",
  #     # "初手７八銀戦法"     => "初手▲7八銀戦法",
  #     # "初手7八銀戦法"      => "初手▲7八銀戦法",
  #     # "初手３六歩戦法"     => "初手▲3六歩戦法",
  #     # "初手3六歩戦法"      => "初手▲3六歩戦法",
  #     # "2手目△３ニ飛戦法"  => "2手目△3ニ飛戦法",
  #     # "2手目△74歩戦法"    => "2手目△7四歩戦法",
  #     # "4手目△３三角戦法"  => "4手目△3三角戦法",
  #     # "2手目△62銀"        => "2手目△6二銀戦法",
  #     # "2手目△6二銀"       => "2手目△6二銀戦法",
  #     "阪田流向飛車" => "阪田流向かい飛車",
  #   }
  #   list.each do |from, to|
  #     # p [from, to, :try]
  #     if tag = ActsAsTaggableOn::Tag.find_by(name: from)
  #       begin
  #         tag.update!(name: to)
  #         p [from, to, :update]
  #       rescue ActiveRecord::RecordInvalid
  #         tag_delete(tag.name)
  #       end
  #     end
  #   end
  # end

  # def step3_rebuild
  #   s = Swars::Battle.all
  #   batch_size = 1000
  #   all_count = s.count.ceildiv(batch_size)
  #   s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
  #     p [batch, all_count, batch.fdiv(all_count)]
  #     # s = s.where(Swars::Battle.arel_table[:updated_at].lt(Time.parse("2024/10/28 12:25")))
  #     s = s.where.not(analysis_version: Bioshogi::ANALYSIS_VERSION)
  #     s.each { |e| e.rebuild(tries: 1) }
  #     puts
  #   end
  # end

  # def step4
  #   [
  #     # ["手得角交換型", "attack_tags",  "note_tags",   ],
  #     # ["手損角交換型", "attack_tags",  "note_tags",   ],
  #     # ["角交換型",     "attack_tags",  "note_tags",   ],
  #   ].each do |name, from, to|
  #     context_change(name, from, to)
  #   end
  # end

  # def step5_onirokuryu_dokkan_bisya
  #   if e = ActsAsTaggableOn::Tag.find_by(name: "原始中飛車")
  #     batch_size = 100
  #     all_count = e.taggings.where(taggable_type: "Swars::Membership").count
  #     e.taggings.in_batches(of: batch_size, order: :desc).each_with_index do |relation, batch|
  #       p [batch, all_count, batch.fdiv(all_count)]
  #       battle_ids = relation.where(taggable_type: "Swars::Membership").collect { |e| e.taggable.battle_id }.uniq
  #       Swars::Battle.find(battle_ids).each(&:rebuild)
  #     end
  #   end
  # end

  def step6_rebuild_for_auto_crawl_user_keys
    ::Swars::User::Vip.auto_crawl_user_keys.each do |user_key|
      p user_key
      if user = Swars::User[user_key]
        s = user.battles
        batch_size = 1000
        all_count = s.count.ceildiv(batch_size)
        s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
          p [batch, all_count, batch.fdiv(all_count)]
          s = s.where.not(analysis_version: Bioshogi::ANALYSIS_VERSION)
          s.each { |e| e.rebuild(tries: 1) }
          puts
        end
      end
    end
  end

  private

  def tag_delete(name)
    p [:tag_delete, name]
    if e = ActsAsTaggableOn::Tag.find_by(name: name)
      e.taggings.in_batches do |relation|
        p relation.count
        relation.where(taggable_type: "Swars::Membership").destroy_all
      end
    end
  end

  def context_change(name, from, to)
    p [:context_change, name, from, to]
    if tag = ActsAsTaggableOn::Tag.find_by(name: name)
      tag.taggings.where(context: from, taggable_type: "Swars::Membership").in_batches(use_ranges: true) do |relation|
        relation.each do |e|
          e.context = to
          e.save!
        end
      end
    end
  end
end
