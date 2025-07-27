# ▼ローカル更新
# rails r MigrateRunner.new.call
#
# ▼本番更新
# cap production deploy:upload FILES=app/models/migrate_runner.rb
# # RAILS_ENV=production bundle exec bin/rails r 'MigrateRunner.new.call'
# RAILS_ENV=production nohup bundle exec bin/rails r 'MigrateRunner.new.call' &
# tailf nohup.out
#
# ▼手数の多いレコード数
# cap production rails:runner CODE='p Swars::Battle.where("turn_max >= 220").count'
#
class MigrateRunner
  def call
    public_methods.grep(/\A(step\w+)/).sort.each do |e|
      p [Time.now.to_s, e, :begin]
      AppLog.important(subject: "[#{e}][開始]")
      sec = TimeTrial.realtime { public_send(e) }
      sec_human = ActiveSupport::Duration.build(sec).inspect
      AppLog.important(subject: "[#{e}][完了] #{sec_human}")
      p [Time.now.to_s, e, :end]
    end
    nil
  end

  def step13_両者の最終対局がかなり前の対局を全部消す
    Swars::Battle.in_batches do |scope|
      scope = scope.vip_except
      scope = scope.joins(memberships: :user)
      scope = scope.group("swars_battles.id")
      scope = scope.having("MAX(swars_users.latest_battled_at) < ?", 3.month.ago)
      puts scope.size
      STDOUT.flush
      begin
        Retryable.retryable(on: ActiveRecord::Deadlocked, tries: 10, sleep: 1) do
          scope.destroy_all
        end
      rescue ActiveRecord::Deadlocked => error
        p error
        
        
=======
  def step1_tag_rename
    list = {
      "対矢倉急戦棒銀"           => "速攻棒銀",
      "一間飛車穴熊"             => "一間飛車右穴熊",
      "対ひねり飛車たこ金戦法"   => "たこ金戦法",
      "2手目△3ニ飛戦法"         => "2手目△3二飛戦法",
      "飯島流相掛かり引き角戦法" => "飯島流相掛かり引き角",
      "金銀橋"                   => "リッチブリッジ",
      "パンツを脱ぐ"             => "パンティを脱ぐ",
      "超速▲3七銀戦法"          => "超速▲3七銀",
      "背水の陣"                 => "屍の舞",
    }
    list.each do |from, to|
      # p [from, to, :try]
      if tag = ActsAsTaggableOn::Tag.find_by(name: from)
        begin
          tag.update!(name: to)
          p [from, to, :update]
        rescue ActiveRecord::RecordInvalid => error
          p error
          # tag_delete(tag.name)
        end
>>>>>>> 3147790e8 ([feat] 新しい bioshogi に対応する)
      end
    end
  end

<<<<<<< HEAD
  # def step12_最近対局していない人の対局を全部消す
  #   battles_max_gt = 0
  #   process_count = 0
  #   process_count_max = 10000*4*100
  #   catch(:break) do
  #     Swars::User.in_batches(order: :desc) do |scope|
  #       scope = scope.vip_except
  #       scope = scope.where(latest_battled_at: ...3.month.ago)
  #       scope = scope.joins(:battles)
  #       scope = scope.group("swars_users.id")
  #       scope = scope.having("COUNT(swars_battles.id) > ?", battles_max_gt)
  #       scope.each do |user|
  #         battles_max2 = battles_max_gt
  #         battles = user.battles
  #         battles = battles.order(accessed_at: :desc).offset(battles_max2)
  #         process_count += battles.size
  #         tp([{ "日時" => Time.current, ID: user.id, "名前" => user.key, "最終対局" => user.latest_battled_at.to_s, "削除件数" => battles.size}])
  #         STDOUT.flush
  #         begin
  #           Retryable.retryable(on: ActiveRecord::Deadlocked, tries: 10, sleep: 1) do
  #             battles.destroy_all
  #           end
  #         rescue ActiveRecord::Deadlocked => error
  #           p error
  #         end
  #         p [process_count, process_count_max]
  #         if process_count >= process_count_max
  #           throw(:break)
  #         end
  #       end
=======
  # def step2_tag_delete
  #   list = [
  #     # "三間飛車系",
  #     # "中飛車系",
  #     # "右玉系",
  #     # "向かい飛車系",
  #     # "四間飛車系",
  #     # "対三間飛車系",
  #     # "対中飛車系",
  #     # "対右玉系",
  #     # "対向かい飛車系",
  #     # "対四間飛車系",
  #     # "対居飛車",
  #     # "対引き角系",
  #     # "対振り飛車",
  #     # "対横歩取り系",
  #     # "対相掛かり系",
  #     # "対筋違い角系",
  #     # "対角換わり系",
  #     # "引き角系",
  #     # "横歩取り系",
  #     # "片穴熊",
  #     # "相掛かり系",
  #     # "空中楼閣",
  #     # "筋違い角系",
  #     # "角換わり系",
  #
  #     "対穴熊",
  #     "対居飛車",
  #     "対振り飛車",
  #     "片穴熊",
  #     "空中楼閣",
  #   ]
  #   list.each do |from, to|
  #     if tag = ActsAsTaggableOn::Tag.find_by(name: from)
  #       tag_delete(tag.name)
>>>>>>> 3147790e8 ([feat] 新しい bioshogi に対応する)
  #     end
  #   end
  # end

<<<<<<< HEAD
  def step10_一般_直近50件を残してすべて削除する
    battles_max_gt = 50
    process_count = 0
    process_count_max = 10000*4*10
    catch(:break) do
      Swars::User.in_batches(order: :desc) do |scope|
=======
  def step10_直近50件を残してすべて削除する
=======
  def step3_直近50件を残してすべて削除する
>>>>>>> 3147790e8 ([feat] 新しい bioshogi に対応する)
    battles_max_gt = 50
    process_count = 0
    process_count_max = 10
    catch(:break) do
      Swars::User.in_batches do |scope|
>>>>>>> 8486d7473 ([feat] migrate_runner の調整)
        scope = scope.vip_except
        scope = scope.joins(:battles)
        scope = scope.group("swars_users.id")
        scope = scope.having("COUNT(swars_battles.id) > ?", battles_max_gt)
        scope.each do |user|
<<<<<<< HEAD
          battles_max2 = battles_max_gt
          battles = user.battles
          battles = battles.order(accessed_at: :desc).offset(battles_max2)
          process_count += battles.size
          tp([{ "日時" => Time.current, ID: user.id, "名前" => user.key, "削除件数" => battles.size}])
          STDOUT.flush
          begin
            Retryable.retryable(on: ActiveRecord::Deadlocked, tries: 10, sleep: 1) do
=======
          if Swars::User::Vip.auto_crawl_user_keys.include?(user.key)
            battles_max2 = 200
          else
            battles_max2 = 50
          end
          battles = user.battles
          battles = battles.order(accessed_at: :desc).offset(battles_max2)
          tp([{ "日時" => Time.current, ID: user.id, "名前" => user.key, "削除件数" => battles.size}])
          begin
            Retryable.retryable(on: ActiveRecord::Deadlocked) do
>>>>>>> 8486d7473 ([feat] migrate_runner の調整)
              battles.destroy_all
            end
          rescue ActiveRecord::Deadlocked => error
            p error
          end
<<<<<<< HEAD
          p [process_count, process_count_max]
          if process_count >= process_count_max
            throw(:break)
          end
        end
      end
    end
  end

  def step11_VIP_直近200件を残してすべて削除する
    battles_max_gt = 200
    process_count = 0
    process_count_max = 10000*4*200
    catch(:break) do
      Swars::User.in_batches(order: :asc) do |scope|
        scope = scope.vip_only
        scope = scope.joins(:battles)
        scope = scope.group("swars_users.id")
        scope = scope.having("COUNT(swars_battles.id) > ?", battles_max_gt)
        scope.each do |user|
          battles_max2 = battles_max_gt
          battles = user.battles
          battles = battles.order(accessed_at: :desc).offset(battles_max2)
          process_count += battles.size
          tp([{ "日時" => Time.current, ID: user.id, "名前" => user.key, "削除件数" => battles.size}])
          STDOUT.flush
          begin
            Retryable.retryable(on: ActiveRecord::Deadlocked, tries: 10, sleep: 1) do
              battles.destroy_all
            end
          rescue ActiveRecord::Deadlocked => error
            p error
          end
          p [process_count, process_count_max]
=======
          process_count += 1
>>>>>>> 8486d7473 ([feat] migrate_runner の調整)
          if process_count >= process_count_max
            throw(:break)
          end
        end
      end
    end
  end

  # def step6_rebuild_for_auto_crawl_user_keys
  #   ::Swars::User::Vip.auto_crawl_user_keys.each.with_index do |user_key, i|
  #     if i.modulo(50).zero?
  #       AppLog.important("#{i} / #{::Swars::User::Vip.auto_crawl_user_keys.size}")
  #     end
  #     p user_key
  #     if user = Swars::User[user_key]
  #       s = user.battles
  #       batch_size = 1000
  #       all_count = s.count.ceildiv(batch_size)
  #       s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
  #         p [batch, all_count, batch.fdiv(all_count)]
  #         # s = s.where.not(analysis_version: Bioshogi::ANALYSIS_VERSION)
  #         s.each { |e| e.rebuild(tries: 1) }
  #         puts
  #       end
  #     end
  #   end
  # end

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
  #     # "2手目△6二銀戦法",
  #   ].each do |name|
  #     tag_delete(name)
  #   end
  # end

  # def step3_rebuild
  #   s = Swars::Battle.all
  #   batch_size = 1000
  #   all_count = s.count.ceildiv(batch_size)
  #   s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
  #     p [batch, all_count, batch.fdiv(all_count)]
  #     # s = s.where(Swars::Battle.arel_table[:updated_at].lt(Time.parse("2024/10/28 12:25")))
  #     # s = s.where.not(analysis_version: Bioshogi::ANALYSIS_VERSION - 1)
  #     s = s.where("analysis_version < #{Bioshogi::ANALYSIS_VERSION}")
  #     # s = s.where("analysis_version < 2")
  #     s.each { |e| e.rebuild(tries: 1) }
  #     puts
  #   end
  # end

  #   # def step3_rebuild
  #   #   s = Swars::Battle.all
  #   #   batch_size = 1000
  #   #   all_count = s.count.ceildiv(batch_size)
  #   #   s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
  #   #     p [batch, all_count, batch.fdiv(all_count)]
  #   #     # s = s.where(Swars::Battle.arel_table[:updated_at].lt(Time.parse("2024/10/28 12:25")))
  #   #     # s = s.where.not(analysis_version: Bioshogi::ANALYSIS_VERSION - 1)
  #   #     s = s.where("analysis_version < #{Bioshogi::ANALYSIS_VERSION}")
  #   #     # s = s.where("analysis_version < 2")
  #   #     s.each { |e| e.rebuild(tries: 1) }
  #   #     puts
  #   #   end
  #   # end
  #
  # def step4
  #   [
  #     # ["手得角交換型", "attack_tags",  "note_tags",   ],
  #     # ["手損角交換型", "attack_tags",  "note_tags",   ],
  #     # ["角交換型",     "attack_tags",  "note_tags",   ],
  #   ].each do |name, from, to|
  #     context_change(name, from, to)
  #   end
  # end

  # def step5_都成流_更新
  #   [
  #     "都成流△3一金",
  #     "端玉には端歩",
  #   ].each do |name|
  #     p name
  #     if e = ActsAsTaggableOn::Tag.find_by(name: name)
  #       batch_size = 100
  #       all_count = e.taggings.where(taggable_type: "Swars::Membership").count
  #       e.taggings.in_batches(of: batch_size, order: :desc).each_with_index do |relation, batch|
  #         p [batch, all_count, batch.fdiv(all_count)]
  #         battle_ids = relation.where(taggable_type: "Swars::Membership").collect { |e| e.taggable&.battle_id }.compact.uniq
  #         s = Swars::Battle.where(id: battle_ids)
  #         s = s.where.not(analysis_version: Bioshogi::ANALYSIS_VERSION)
  #         s.each(&:rebuild)
  #         puts
  #       end
  #     end
  #   end
  # end

  # def step7_style_update_for_auto_crawl_user_keys
  #   ::Swars::User::Vip.auto_crawl_user_keys.each do |user_key|
  #     p user_key
  #     if user = Swars::User[user_key]
  #       s = user.battles
  #       batch_size = 100
  #       all_count = s.count.ceildiv(batch_size)
  #       s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
  #         p [batch, all_count, batch.fdiv(all_count)]
  #         s.each do |e|
  #           before = e.memberships.collect(&:style).compact.collect(&:key)
  #           e.send(:style_update_all)
  #           begin
  #             e.memberships.each(&:save!)
  #           rescue => error
  #             p error
  #           end
  #           after = e.reload.memberships.collect(&:style).compact.collect(&:key)
  #           print before == after ? "." : "U"
  #           STDOUT.flush
  #         end
  #         puts
  #       end
  #     end
  #   end
  # end

  # def step7_hard_rename
  #   list = {
  #     "戸部流4→3戦法" => "戸辺流4→3戦法",
  #   }
  #   list.each do |from, to|
  #     tag = ActsAsTaggableOn::Tag.find_by!(name: from)
  #     tag.update!(name: to)
  #     p [from, to, :update]
  #   end
  # end

  # def step8_手数の多い対局を読み直して全駒と玉単騎のタグをつける
  #   s = ::Swars::Battle.all
  #   batch_size = 2000
  #   all_count = s.count.ceildiv(batch_size)
  #   s.in_batches(order: :desc, of: batch_size).each_with_index do |s, batch|
  #     p [batch, all_count, batch.fdiv(all_count)]
  #     s.each do |e|
  #       if e.turn_max >= 200
  #         if e.memberships.any? { |e| e.note_tag_list.include?("大駒全ブッチ") || e.note_tag_list.include?("大駒コンプリート") }
  #           e.rebuild
  #           e.reload
  #           if e.memberships.any? { |e| e.note_tag_list.include?("全駒") }
  #             print "A"
  #           end
  #           if e.memberships.any? { |e| e.note_tag_list.include?("玉単騎") }
  #             print "1"
  #           end
  #           STDOUT.flush
  #         end
  #       end
  #     end
  #     puts
  #   end
  # end

  # def step9_集計
  # end

  # # cap production deploy:upload FILES=app/models/swars/membership_extra.rb
  # # RAILS_ENV=production nohup bundle exec bin/rails r 'Swars::MembershipExtra.create_if_nothing' &
  # def step10_membership_extra_create_if_nothing
  #   # production 更新
  #   # r = t.advance(days: 0)...t.advance(days: 1)
  #   # Swars::MembershipExtra.delete_all
  #   # ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
  #   t = Time.current.beginning_of_day
  #   r = "2000-01-01".to_time..."2021-12-01".to_time
  #   m = Swars::Membership.membership_extra_missing
  #   b = Swars::Battle.where(battled_at: r).where(memberships: m)
  #   total = b.count
  #   AppLog.info(subject: "create_if_nothing", body: b.count)
  #   offset = 0
  #   b.find_in_batches do |av|
  #     AppLog.info(subject: "create_if_nothing", body: [offset, total, offset.fdiv(total)])
  #     av.each(&:membership_extra_create_if_nothing)
  #     offset += av.size
  #   end
  #   # tp Swars::MembershipExtra
  #   AppLog.info(subject: "create_if_nothing", body: "完了")
  # end

  private

  def tag_delete(name)
    p [:tag_delete, name]
    if e = ActsAsTaggableOn::Tag.find_by(name: name)
      e.taggings.in_batches do |relation|
        p [Time.current]
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
