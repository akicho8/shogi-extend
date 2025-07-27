# frozen-string-literal: true

# 「戦法ランキング」「戦法一覧」用の一次集計で、戦法毎にその戦法を使った battle.id 収集しておく
# この収集したIDを使って棋譜検索に戦法名から棋譜検索に飛ぶ
#
# rails r QuickScript::Swars::TacticBattleMiningScript.new.cache_write
# rails r 'QuickScript::Swars::TacticBattleMiningScript.new({}, {need_size: 200}).cache_write'
#
# http://localhost:4000/lab/swars/tactic-cross1
#
module QuickScript
  module Swars
    class TacticBattleMiningScript < Base
      include BatchMethods
      include BattleIdMining

      self.title        = "【収集専用】戦法毎対局IDs収集"

      self.description  = "戦法毎の対局IDsを集計確認する"

      def need_size_default
        200
      end

      def human_rows
        rows = aggregate.sort_by { |key, _| key }
        rows.collect do |key, battle_ids|
          {
            "戦法" => item_name_search_link(key),
            "件数" => battle_ids.size,
          }
        end
      end

      concerning :AggregateMethods do
        def aggregate_now
          progress_start(target_items.size)
          target_items.inject({}) do |a, e|
            progress_next(e)
            a.merge(e.key => battle_ids_of(e))
          end
        end

        def battle_ids_of(item)
          ids = []
          ids = finder(ids, item, :win_only_conditon)
          ids = finder(ids, item, :general_conditon)
          ids = finder(ids, item, :base_condition)
          ids
        end

        def finder(ids, item, condition_method)
          if ids.size < need_size
            if tag = ActsAsTaggableOn::Tag.find_by(name: item.key)
              scope = tag.taggings # main_scope は使わず tag から引いている
              scope.in_batches(order: :desc, of: batch_size).each.with_index do |scope, batch_index|
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

        # その戦法で勝った棋譜がほしいので最初の条件には「勝ち」を入れる
        def win_only_conditon(scope)
          scope = scope.joins(:judge).where(Judge.arel_table[:key].eq(:win))
          scope = general_conditon(scope)
        end

        # それで見つからない場合は勝ち条件を外す
        def general_conditon(scope)
          scope = scope.joins(battle: :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
          scope = base_condition(scope)
        end

        # それでも見つからない場合は野良条件を外す
        def base_condition(scope)
          scope = scope.joins(battle: :imode).where(::Swars::Imode.arel_table[:key].eq(:normal))
          scope = scope.joins(:grade).order(::Swars::Grade.arel_table[:priority])
        end

        ################################################################################

        def target_items
          @target_items ||= yield_self do
            av = Bioshogi::Analysis::TagIndex.values
            if v = @options[:item_keys]
              set = v.collect { |e| Bioshogi::Analysis::TagIndex.fetch(e) }.to_set
              av = av.find_all { |e| set.include?(e) }
            end
            av
          end
        end
      end
    end
  end
end
