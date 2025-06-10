# frozen-string-literal: true

# 時間帯別情報
#
# 一次集計: rails r QuickScript::Swars::HourlyActiveUserScript.new.cache_write
# 一次集計: rails r 'QuickScript::Swars::HourlyActiveUserScript.new({}, {batch_limit: 10}).cache_write'
#
module QuickScript
  module Swars
    class HourlyActiveUserScript < Base
      include BatchMethods

      self.title = "【集計専用】ヒートマップ"
      self.description = "「時間帯別対局者数」と「時間帯別相対棋力」用のデータを準備する"
      self.json_link = true

      def header_link_items
        super + [
          { name: "ﾋｰﾄﾏｯﾌﾟ", icon: "chart-box", _v_bind: { href: "/lab/swars/hourly-active-user.html", target: "_self" }, },
        ]
      end

      # http://localhost:4000/lab/swars/hourly_active_user
      # http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general
      def as_general_json
        aggregate
      end

      concerning :AggregateMethods do
        def aggregate_now
          acc = Hash.new do |h, k|
            h[k] = {
              :user_ids          => Set[], # 人数用
              :grade_keys        => [],    # 強さ用
              :memberships_count => 0,     # 対局数
            }
          end
          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size, order: :desc).each.with_index do |scope, batch_index|
            progress_next
            if batch_index >= batch_limit
              break
            end
            collect_time_slot_stats(acc, scope)
          end
          build_time_slot_summary_rows(acc)
        end

        def collect_time_slot_stats(acc, scope)
          # 1. 対局数 - いったん memberships_count 総数を求める (distinct で battled_id を求める方法はブロック間で分断されるので注意)
          s = condition_add(scope)
          s.group(time_key).count.each do |key, count|
            acc[key][:memberships_count] += count
          end

          # 2. 人数 - 「曜日 時 user_id」のユニークな組み合わせを収集して user_id だけを貯めていく
          s = condition_add(scope)
          res = s.distinct.pluck(time_key, "user_id") # => [["3/00", 1075401], ["3/00", 1075402]]
          res.each do |key, user_id|
            acc[key][:user_ids] << user_id # Set
          end

          # 3. 棋力 - 「曜日 時 user_id 棋力」のユニークな組み合わせを収集して棋力だけを貯めていく
          s = condition_add(scope)
          res = s.distinct.pluck(time_key, "user_id", "swars_grades.key") # => [["3/00", 1075401, "二段"], ["3/00", 1075402, "四段"]]
          res.each do |key, user_id, grade_key|
            acc[key][:grade_keys] << grade_key.to_sym # Array
          end
        end

        def build_time_slot_summary_rows(acc)
          acc.values.each do |e|
            if grade_keys = e[:grade_keys].presence
              e[:"強さ"] = grade_keys.sum { |e| ::Swars::GradeInfo.fetch(e).score }.fdiv(grade_keys.size)
            end
          end

          if acc.values.any? { |e| e[:memberships_count].odd? }
            raise "共通対局数が奇数になっている"
          end

          WdayInfo.collect { |wday_info|
            (1.day / 1.hour).times.collect do |hour|
              padded_hour = "%02d" % hour
              key = "#{wday_info.code}#{separator}#{padded_hour}"
              if acc[key][:user_ids].present?
                {
                  :"曜日"   => wday_info.name,
                  :"時"     => hour,
                  :"対局数" => acc[key][:memberships_count] / LocationInfo.count,
                  :"人数"   => acc[key][:user_ids].size,
                  :"強さ"   => acc[key][:"強さ"],
                }
              end
            end
          }.flatten.compact
        end

        def condition_add(scope)
          scope = scope.joins(:battle, :grade)
        end

        # %w: 曜日(0-6) WdayInfo の順と一致している
        # %H: 時(00-23) 常に二桁になる
        def time_key
          @time_key ||= Arel.sql("DATE_FORMAT(#{battled_at}, '%w#{separator}%H')")
        end

        def battled_at
          @battled_at ||= MysqlToolkit.column_tokyo_timezone_cast(:battled_at)
        end

        def separator
          "/"
        end
      end
    end
  end
end
