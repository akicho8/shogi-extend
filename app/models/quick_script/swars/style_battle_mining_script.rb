# frozen-string-literal: true

# 一次集計
# rails r QuickScript::Swars::StyleBattleMiningScript.new.cache_write
# rails r 'QuickScript::Swars::StyleBattleMiningScript.new({}, {need_size: 200}).cache_write'
#
# http://localhost:4000/lab/swars/tactic-cross3
#
module QuickScript
  module Swars
    class StyleBattleMiningScript < Base
      include BatchMethods
      include BattleIdMining

      self.title        = "【収集専用】スタイル毎対局IDs収集"
      self.description  = "スタイル毎の対局IDsを集計確認する"

      def need_size_default
        500
      end

      def human_rows
        rows = aggregate.sort_by { |key, _| ::Swars::StyleInfo[key].code }
        rows.collect do |key, battle_ids|
          {
            "スタイル" => item_name_search_link(key),
            "件数"     => battle_ids.size,
          }
        end
      end

      concerning :AggregateMethods do
        def aggregate_now
          progress_start(style_infos.size)
          style_infos.inject({}) do |a, e|
            progress_next(e)
            a.merge(e.key => battle_ids_of(e))
          end
        end

        def battle_ids_of(style_info)
          ids = []
          [
            :win_only_conditon,
            :general_conditon,
            :base_condition,
          ].each do |e|
            ids = finder(ids, style_info, e)
          end
          ids
        end

        def finder(ids, style_info, condition_method)
          if ids.size < need_size
            scope = main_scope
            scope.in_batches(order: :desc, of: batch_size).each.with_index do |scope, batch_index|
              scope = scope.joins(:style)
              scope = scope.where(::Swars::Style.arel_table[:key].eq(style_info.key))
              scope = send(condition_method, scope)

              battle_ids = scope.pluck(:battle_id)
              ids = (ids + battle_ids).uniq
              if ids.size >= need_size
                ids = ids.take(need_size)
                break
              end
            end
          end
          ids
        end

        ################################################################################

        # 最初の条件には「勝ち」を入れる
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

        def style_infos
          @style_infos ||= yield_self do
            av = ::Swars::StyleInfo.values
            if v = @options[:style_keys]
              set = v.collect(&:to_sym).to_set
              av = av.find_all { |e| set.include?(e.key) }
            end
            av
          end
        end
      end
    end
  end
end
