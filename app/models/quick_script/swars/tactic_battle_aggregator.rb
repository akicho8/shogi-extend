# frozen-string-literal: true

# 「戦法ランキング」「戦法一覧」用の一次集計で、戦法毎にその戦法を使った battle.id 収集しておく
# この収集したIDを使って棋譜検索に戦法名から棋譜検索に飛ぶ
#
# rails r QuickScript::Swars::TacticBattleAggregator.new.cache_write
#
module QuickScript
  module Swars
    class TacticBattleAggregator < Aggregator
      def aggregate_now
        target_items.inject({}) do |a, e|
          a.merge(e.key => battle_ids_of(e))
        end
      end

      def battle_ids_of(item)
        ids = []
        ids = finder(ids, item, :win_only_conditon)
        ids = finder(ids, item, :general_conditon)
        ids = finder(ids, item, :base_conditon)
        ids
      end

      def finder(ids, item, condition_method)
        if ids.size < need_size
          if tag = ActsAsTaggableOn::Tag.find_by(name: item.key)
            scope = tag.taggings # main_scope は使わず tag から引いている
            progress_start(scope.count.ceildiv(batch_size))
            scope.in_batches(order: :desc, of: batch_size).each.with_index do |scope, batch_index|
              progress_next(item.key)

              scope = scope.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags")
              taggable_ids = scope.pluck(:taggable_id)
              taggable_ids.size <= batch_size or raise "must not happen"

              ########################################

              scope = ::Swars::Membership.where(id: taggable_ids)
              scope = send(condition_method, scope)
              battle_ids = scope.pluck(:battle_id)         # => [57595006, 57487831]
              battle_ids.size <= taggable_ids.size or raise "must not happen"
              ids = (ids + battle_ids).uniq
              if ids.size >= need_size
                ids = ids.take(need_size)
                break
              end
            end
          end
        end
        ids
      end

      ################################################################################

      def need_size
        (@options[:need_size] || (Rails.env.local? ? 2 : 50)).to_i
      end

      ################################################################################

      # その戦法で勝った棋譜がほしいので最初の条件には「勝ち」を入れる
      def win_only_conditon(scope)
        scope = scope.joins(:judge).where(Judge.arel_table[:key].eq(:win))
        scope = general_conditon(scope)
      end

      # それで見つからない場合もあるので「負け」の対局も探す
      def general_conditon(scope)
        scope = scope.joins(battle: :imode).where(::Swars::Imode.arel_table[:key].eq(:normal))
        scope = base_conditon(scope)
      end

      # それで見つからなかったら全部とるけど野良は絶対とする
      def base_conditon(scope)
        scope = scope.joins(battle: :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
        scope = scope.joins(:grade).order(::Swars::Grade.arel_table[:priority])
      end

      ################################################################################

      def target_items
        if v = @options[:item_keys]
          v.collect { |e| Bioshogi::Analysis::TacticInfo.flat_fetch(e) }
        else
          Bioshogi::Analysis::TacticInfo.all_elements
        end
      end
    end
  end
end
