# frozen-string-literal: true

# 時間帯別棋力
#
# 一次集計: rails r QuickScript::Swars::HourlyActiveUserScript.new.cache_write
# 一次集計: rails r 'QuickScript::Swars::HourlyActiveUserScript.new({}, {batch_limit: 1}).cache_write'
#
module QuickScript
  module Swars
    class HourlyActiveUserScript < Base
      self.title = "時間帯別対局者情報"
      self.description = "「時間帯別対局者数」と「時間帯別相対棋力」用のデータを準備する"
      self.general_json_link_show = true

      def header_link_items
        super + [
          { type: "t_link_to", name: "時間帯別対局者数", params: { href: "/lab/swars/hourly-active-user-count.html",    target: "_self" }, },
          { type: "t_link_to", name: "時間帯別相対棋力", params: { href: "/lab/swars/hourly-active-user-strength.html", target: "_self" }, },
        ]
      end

      def call
        aggregate
      end

      # http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general
      def as_general_json
        aggregate
      end

      concerning :AggregateMethods do
        include BatchMethods

        def default_options
          {
            **super,
            :uniq_by_ymhd_user_id => true,
          }
        end

        def aggregate_now
          hash = {}
          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size, order: :desc).each.with_index do |scope, batch_index|
            progress_next

            if batch_limit
              if batch_index >= batch_limit
                break
              end
            end

            scope = uniq_by_ymhd_user_id(scope)
            scope = condition_add(scope)
            scope = scope.group(hour)
            scope = scope.group(day_of_week)
            scope = scope.select("#{hour} AS hour")
            scope = scope.select("#{day_of_week} AS day_of_week")
            scope = scope.select("SUM(swars_grades.priority) AS grade_total")
            scope = scope.select("COUNT(*) AS uniq_user_count")

            scope.each do |e|
              key = [e.hour, e.day_of_week]
              hash[key] ||= {}
              h = hash[key]
              h.update(grade_total: e.grade_total, uniq_user_count: e.uniq_user_count) { |_, a, b| a + b }
            end
          end

          rows = hash.collect { |(hour, day_of_week), e|
            grade_average = e[:grade_total].fdiv(e[:uniq_user_count])
            {
              :day_of_week     => day_of_week,         # 曜日     (X)
              :hour            => hour,                # 時       (Y)
              :grade_average   => grade_average,       # 平均棋力 (Z)
              :uniq_user_count => e[:uniq_user_count], # 対局者数 (Z)
              :grade_total     => e[:grade_total],     # 合計棋力(確認用)
              **describe_grade(grade_average),         # 平均棋力(確認用)
            }
          }

          # grade_average が「小さいほど強い」だと、わかりにくいので「大きいほど強い」にしておく
          max = rows.pluck(:grade_average).max
          rows = rows.collect { |e| e.merge(relative_strength: max - e[:grade_average]) }
          rows = hash_array_minmax_normalize(rows, :relative_strength, :relative_strength)

          # ヒートマップは相対的な人数なので右のメーターに人数を出しても意味がない
          # だから見た目だけの問題で人数を正規化しておく
          rows = hash_array_minmax_normalize(rows, :uniq_user_count, :relative_uniq_user_count)
        end

        def day_of_week
          @day_of_week ||= <<~EOT.squish
            CASE
              WHEN holidays.holiday_on IS NOT NULL THEN "祝日"
              ELSE CASE DAYOFWEEK(#{battled_at})
                WHEN 1 THEN "日"
                WHEN 2 THEN "月"
                WHEN 3 THEN "火"
                WHEN 4 THEN "水"
                WHEN 5 THEN "木"
                WHEN 6 THEN "金"
                WHEN 7 THEN "土"
                ELSE "must not happen"
              END
            END
          EOT
        end

        def condition_add(scope)
          scope = scope.joins(:battle => [:imode, :xmode], :grade => [])
          scope = scope.merge(::Swars::Battle.valid_match_only)
          scope = scope.where(::Swars::Imode.arel_table[:key].eq(:normal))
          scope = scope.where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
          scope = scope.where(::Swars::Grade.arel_table[:key].eq_any(available_grade_keys))
          scope = scope.joins("LEFT JOIN holidays ON DATE(#{battled_at}) = holidays.holiday_on")
        end

        def available_grade_keys
          @available_grade_keys ||= ::Swars::GradeInfo.find_all(&:hourly_active_user).collect(&:key)
        end

        def hour
          @hour ||= "HOUR(#{battled_at})"
        end

        def ymd_h
          @ymd_h ||= "DATE_FORMAT(#{battled_at}, '%Y %m %d %H')"
        end

        def battled_at
          @battled_at ||= MysqlToolkit.column_tokyo_timezone_cast(:battled_at)
        end

        def uniq_by_ymhd_user_id(scope)
          if @options[:uniq_by_ymhd_user_id]
            scope = scope.joins(:battle)
            scope = scope.group(ymd_h)
            scope = scope.group("user_id")
            scope = scope.select("MAX(swars_memberships.id) as max_id")
            ids = scope.collect(&:max_id)
            scope = ::Swars::Membership.where(id: ids)
          end
          scope
        end

        # 1.0 → 九段 100%
        # 1.2 → 九段  80%
        # 1.8 → 九段  20%
        def describe_grade(v)
          base_priority = v.to_i
          rate = (1.0 - (v - base_priority)) * 100
          grade_info = ::Swars::GradeInfo.fetch(base_priority)
          { grade_average_major: grade_info.name, grade_average_minor: rate }
        end

        def hash_array_minmax_normalize(rows, key1, key2)
          values = rows.pluck(key1)
          values = minmax_normalize(values)
          rows.collect.with_index { |e, i| e.merge(key2 => values[i]) }
        end

        def minmax_normalize(values)
          min, max = values.minmax
          range = (max - min).to_f

          if range.zero?
            return Array.new(values.size, 0.0)
          end

          values.collect { |e| (e - min) / range }
        end
      end
    end
  end
end
