# frozen-string-literal: true

#
# 戦法毎にその戦法を使った battle.id 収集しておく
#
# 一次集計: rails r QuickScript::Swars::TacticBattleAggregator.new.cache_write
#

module QuickScript
  module Swars
    class TacticBattleAggregator
      include CacheMod

      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
        end
      end

      def initialize(options = {})
        @options = {}.merge(options)
      end

      def call
        aggregate
      end

      def aggregate_now
        Bioshogi::Analysis::TacticInfo.all_elements.each.with_index.inject({}) do |a, (item, i)|
          a.merge(item.key => battle_ids_of(item, i))
        end
      end

      def battle_ids_of(item, i)
        p [Time.current.to_fs(:ymdhms), item, i.fdiv(Bioshogi::Analysis::TacticInfo.all_elements.size)] if false

        ids = []
        ids = finder(item, ids, :win_only_conditon)
        ids = finder(item, ids, :general_conditon)
        ids = finder(item, ids, :base_conditon)
        ids
      end

      def finder(item, ids, condition_method)
        if ids.size < need_size
          if tag = ActsAsTaggableOn::Tag.find_by(name: item.key)
            taggings = tag.taggings
            batch_total = taggings.count.ceildiv(batch_size)
            taggings.in_batches(order: :desc, of: batch_size).each.with_index do |taggings, batch_index|
              if Rails.env.development? || Rails.env.production? || Rails.env.staging?
                p [Time.current.to_fs(:ymdhms), "#{batch_index}/#{batch_total}", item, condition_method]
              end
              taggings = taggings.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags")
              taggable_ids = taggings.pluck(:taggable_id)
              taggable_ids.size <= batch_size or raise "must not happen"

              ########################################

              scope = ::Swars::Membership.where(id: taggable_ids)
              scope = send(condition_method, scope)
              battle_ids = scope.pluck(:battle_id)         # => [57595006, 57487831]
              battle_ids.size <= taggable_ids.size or raise "must not happen"
              battle_ids -= ids # 取得済みのIDは除外する
              if battle_ids.present?
                p [Time.current.to_fs(:ymdhms), item, ids.size, "+#{battle_ids.size}"] if false
                ids += battle_ids
                if ids.size >= need_size
                  ids = ids.take(need_size)
                  p [Time.current.to_fs(:ymdhms), "break"] if false
                  break
                end
              end
            end
          end
        end
        ids
      end

      # その戦法で勝った棋譜がほしいので最初の条件には「勝ち」を入れる
      def win_only_conditon(scope)
        scope = scope.joins(:judge).where(Judge.arel_table[:key].eq(:win))
        scope = general_conditon(scope)
      end

      # それで見つからない場合もあるので次は条件を緩くする
      def general_conditon(scope)
        scope = scope.joins(battle: :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
        scope = base_conditon(scope)
      end

      # それで見つからなかったら全部とる
      def base_conditon(scope)
        scope = scope.joins(:grade).order(::Swars::Grade.arel_table[:priority])
      end

      def need_size
        (@options[:need_size] || (Rails.env.local? ? 2 : 50)).to_i
      end

      # need_size なら効率は良いが段位が低い対局も拾われる可能性が高くなる
      # したがって 本番では 1000 にすること
      # 直近 1000 件のなかから段位の高い順に need_size 件拾われる
      def batch_size
        @options[:batch_size] || (Rails.env.local? ? need_size : 1000)
      end
    end
  end
end
