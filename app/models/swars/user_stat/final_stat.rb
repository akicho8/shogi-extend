# frozen-string-literal: true

module Swars
  module UserStat
    class FinalStat < Base
      # これ true にしないと順番がおかしくなる
      JUDGE_INFO_RECORDS_INCLUDE_EMPTY_LABEL = true # 勝ち負けのラベルの並びを共通化させるため「投了」がなくても「投了」を含める

      delegate *[
        :ids_scope,
      ], to: :@user_stat

      # 勝ち負けでのそれぞれの方法
      def to_chart(judge_key)
        s = ids_scope
        s = s.s_where_judge_key_eq(judge_key)
        s = s.joins(:battle => :final)
        s = s.group(Final.arel_table[:key])

        if JUDGE_INFO_RECORDS_INCLUDE_EMPTY_LABEL
        else
          s = s.order("count_all DESC")
        end
        counts_hash = s.count # { TORYO: 3, CHECKMATE: 1 }

        if counts_hash.present?
          if JUDGE_INFO_RECORDS_INCLUDE_EMPTY_LABEL
            counts_hash = counts_hash.symbolize_keys
            h = {}
            FinalInfo.each do |e|
              if v = counts_hash[e.key]
                h[e.key] = v
              else
                if e.chart_required
                  h[e.key] = 0
                end
              end
            end
          else
            h = counts_hash
          end

          h.collect do |key, value|
            final_info = FinalInfo.fetch(key)
            {
              :key   => key,
              # :name  => final_info.name2(judge_key),
              :name  => final_info.name,
              :value => value,
            }
          end
        end
      end
    end
  end
end
