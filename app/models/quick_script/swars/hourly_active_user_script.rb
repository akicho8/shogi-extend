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

      self.title = "時間帯別情報"
      self.description = "「時間帯別対局者数」と「時間帯別相対棋力」用のデータを準備する"
      self.json_link = true

      SEPARATOR = "/"

      def header_link_items
        super + [
          { name: "ｺﾞｰﾙﾃﾞﾝﾀｲﾑ",  _v_bind: { href: "/lab/swars/hourly-active-user-count.html",    target: "_self" }, },
          { name: "棋力ﾋｰﾄﾏｯﾌﾟ", _v_bind: { href: "/lab/swars/hourly-active-user-strength.html", target: "_self" }, },
        ]
      end

      # http://localhost:4000/lab/swars/hourly_active_user
      # http://localhost:3000/api/lab/swars/hourly_active_user.json?json_type=general
      def as_general_json
        aggregate
      end

      concerning :AggregateMethods do
        def aggregate_now
          dhash = Hash.new do |h, k|
            h[k] = {
              :user_ids   => Set[], # 人数用(ユニーク)
              :grade_keys => [],    # 強さ用
            }
          end

          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size, order: :desc).each.with_index do |scope, batch_index|
            progress_next

            if batch_index >= batch_limit
              break
            end

            # 「曜日 時 user_id」のユニークな組み合わせを収集して user_id だけを貯めていく
            s = condition_add(scope)
            res = s.distinct.pluck(time_key, "user_id") # => [["3/00", 1075401], ["3/00", 1075402]]
            res.each do |key, user_id|
              dhash[key][:user_ids] << user_id # Set
            end

            # 「曜日 時 user_id 棋力」のユニークな組み合わせを収集して棋力だけを貯めていく
            s = condition_add(scope)
            res = s.distinct.pluck(time_key, "user_id", "swars_grades.key") # => [["3/00", 1075401, "二段"], ["3/00", 1075402, "四段"]]
            res.each do |key, user_id, grade_key|
              dhash[key][:grade_keys] << grade_key.to_sym # Array
            end
          end

          dhash.values.each do |e|
            if grade_keys = e[:grade_keys].presence
              e[:"強さ"] = grade_keys.sum { |e| ::Swars::GradeInfo.fetch(e).score }.fdiv(grade_keys.size)
            end
          end

          items = [].tap do |items|
            WdayInfo.each do |wday_info|
              (1.day / 1.hour).times do |hour|
                hour_key = "%02d" % hour
                key = "#{wday_info.code}#{SEPARATOR}#{hour_key}"
                unless dhash[key][:user_ids].empty?
                  items << {
                    :"曜日" => wday_info.name,
                    :"時"   => hour,
                    :"人数" => dhash[key][:user_ids].size,
                    :"強さ" => dhash[key][:"強さ"],
                  }
                end
              end
            end
          end

          items = MinmaxNormalizer.merge(items, :"強さ", out_min: -1.0)
        end

        # %w: 曜日(0-6) WdayInfo の並びと一致している
        # %H: 時(00-23) 常に二桁になる
        def time_key
          @time_key ||= Arel.sql("DATE_FORMAT(#{battled_at}, '%w#{SEPARATOR}%H')")
        end

        def condition_add(scope)
          scope = scope.joins(:battle, :grade)
        end

        def battled_at
          @battled_at ||= MysqlToolkit.column_tokyo_timezone_cast(:battled_at)
        end
      end
    end
  end
end
