# frozen-string-literal: true

# 一次集計
# rails r QuickScript::Swars::PresetBattleMiningScript.new.cache_write
# rails r 'QuickScript::Swars::PresetBattleMiningScript.new({}, {need_size: 200}).cache_write'
#
# http://localhost:4000/lab/swars/tactic-cross3
#
module QuickScript
  module Swars
    class PresetBattleMiningScript < Base
      include BatchMethods
      include BattleIdMining

      self.title        = "【収集専用】手合割毎対局IDs収集"
      self.description  = "手合割毎の対局IDsを集計確認する"

      def need_size_default
        500
      end

      def human_rows
        rows = aggregate.sort_by { |key, _| PresetInfo[key].code }
        rows.collect do |key, battle_ids|
          {
            "手合割" => item_name_search_link(key),
            "件数"   => battle_ids.size,
          }
        end
      end

      concerning :AggregateMethods do
        def aggregate_now
          progress_start(preset_infos.size)
          preset_infos.inject({}) do |a, e|
            progress_next(e)
            a.merge(e.key => battle_ids_of(e))
          end
        end

        def battle_ids_of(preset_info)
          ids = []
          [
            :base_condition,
          ].each do |e|
            ids = finder(ids, preset_info, e)
          end
          ids
        end

        def finder(ids, preset_info, condition_method)
          if ids.size < need_size
            scope = main_scope
            scope.in_batches(order: :desc, of: batch_size).each.with_index do |scope, batch_index|
              scope = scope.joins(:battle => :preset)
              scope = scope.where(Preset.arel_table[:key].eq(preset_info.key))
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

        def base_condition(scope)
          scope = scope.joins(:grade).order(::Swars::Grade.arel_table[:priority])
        end

        ################################################################################

        def preset_infos
          @preset_infos ||= yield_self do
            av = PresetInfo.swars_preset_infos
            if v = @options[:preset_keys]
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
