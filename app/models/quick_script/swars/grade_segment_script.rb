# frozen-string-literal: true

# 時間帯別棋力
#
# 一次集計: rails r QuickScript::Swars::GradeSegmentScript.new.cache_write
# 一次集計: rails r 'QuickScript::Swars::GradeSegmentScript.new({}, {batch_limit: 1}).cache_write'
#
module QuickScript
  module Swars
    class GradeSegmentScript < Base
      self.title = "棋力別の情報"
      self.description = "「棋力別の平均手数」と「負け方の実態と傾向」用の集計を行う"
      self.general_json_link_show = true

      def header_link_items
        super + [
          { type: "t_link_to", name: "視覚化1", params: { href: "/lab/swars/lose-pattern.html", target: "_self" }, },
          { type: "t_link_to", name: "視覚化2", params: { href: "/lab/swars/turn-average.html", target: "_self" }, },
        ]
      end

      # http://localhost:3000/api/lab/swars/grade-segment.json?json_type=general
      def as_general_json
        aggregate
      end

      concerning :AggregateMethods do
        include BatchMethods

        def available_grade_keys
          @available_grade_keys ||= ::Swars::GradeInfo.find_all(&:lose_pattern).collect(&:key)
        end

        def aggregate_now
          hash = {}
          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size, order: :desc).each.with_index do |scope, batch_index|
            progress_next

            if batch_index >= batch_limit
              break
            end

            scope = condition_add(scope)

            scope.each do |e|
              key = e[:grade_key]
              hash[key] ||= {}
              hash[key].update(e.attributes.symbolize_keys) { |_, a, b| (a || 0) + (b || 0) }
            end
          end

          rows = hash.collect { |grade_key, record| row_build(grade_key, record) }
          rows = rows.sort_by { |e| e["棋力順"] }
        end

        def condition_add(scope)
          scope = scope.joins(:battle => [:imode, :xmode, :final], :grade => [], :judge => [])
          scope = scope.merge(::Swars::Battle.valid_match_only)                             # 数手で終わる対局を除く
          scope = scope.where(::Swars::Grade.arel_table[:key].eq_any(available_grade_keys)) # 10000級を除く
          scope = scope.merge(::Swars::Battle.xmode_eq(["野良", "大会", "指導"]))           # 友達対局を除く
          scope = scope.merge(::Swars::Battle.imode_eq("通常"))                             # スプリントを除く

          # 棋力毎
          scope = scope.group(::Swars::Grade.arel_table[:key])
          scope = scope.select(::Swars::Grade.arel_table[:key].as("grade_key"))

          # 「棋力別の平均手数」用
          if true
            ::Swars::TurnColumnInfo.each do |e|
              scope = scope.select(::Swars::Battle.arel_table[e.key].sum.as("#{e.key}_total"))
            end
            scope = scope.select("COUNT(*) AS memberhip_count")
          end

          # 「負け方の実態と傾向」用
          if true
            scope = scope.select("COUNT(CASE WHEN judges.key = 'lose' THEN TRUE END) AS lose_count")
            ::Swars::FinalInfo.win_or_lose.each do |e|
              scope = scope.select("COUNT(CASE WHEN judges.key = 'lose' AND swars_finals.key = '#{e.key}' THEN TRUE END) AS #{e.key}_count")
            end
          end

          scope
        end

        def row_build(grade_key, record)
          grade_info = ::Swars::GradeInfo[grade_key]

          row = {}
          row["棋力"]   = grade_info.name
          row["棋力順"] = grade_info.priority

          ::Swars::TurnColumnInfo.each do |e|
            row[e.name] = safe_fdiv(record[:"#{e.key}_total"], record[:memberhip_count]) || 0.0
          end

          ::Swars::FinalInfo.win_or_lose.each do |e|
            row[e.grade_segment_label] = safe_fdiv(record[:"#{e.key}_count"], record[:lose_count]) || 0.0
          end

          row
        end

        def safe_fdiv(numerator, denominator)
          if numerator && denominator
            if v = denominator
              if v.nonzero?
                numerator.fdiv(v)
              end
            end
          end
        end
      end
    end
  end
end
