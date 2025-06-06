# frozen-string-literal: true

# 一次集計
# rails r QuickScript::Swars::StandardScoreScript.new.cache_write
# rails r 'QuickScript::Swars::StandardScoreScript.new({}, batch_size: Float::INFINITY).cache_write'
# rails r 'QuickScript::Swars::StandardScoreScript.new({}, batch_limit: 1).cache_write'

module QuickScript
  module Swars
    class StandardScoreScript < Base
      include SwarsSearchHelperMethods
      include BatchMethods

      self.title = "将棋ウォーズ偏差値"
      self.description = "将棋ウォーズのガチ勢棋力帯を対象にした偏差値を求める"
      self.json_link = true

      SEPARATOR = "/"

      def header_link_items
        super + [
          { name: "詳細", icon: "chart-box", _v_bind: { href: "/lab/swars/user-dist.html",      target: "_self", }, },
          { name: "全体", icon: "chart-box", _v_bind: { href: "/lab/swars/standard-score.html", target: "_self", }, },
        ]
      end

      def call
        values = [
          { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: { "max-width" => "800px", margin: "auto" }, :class => "is-unselectable is-centered", },
          simple_table(human_rows, always_table: true),
        ]
        v_stack(values, style: { "gap" => "1rem" })
      end

      # http://localhost:3000/api/lab/swars/standard-score.json?json_type=general
      def as_general_json
        ::Swars::GradeInfo.active_only.flat_map do |grade_info|
          {
            "棋力"   => grade_info.name,
            "人数"   => freq_count(grade_info),
          }
        end
      end

      def human_rows
        rows.collect do |e|
          {}.tap do |row|
            row["棋力"]   = item_name_search_link(e["棋力"])
            row["偏差値"] = e["偏差値"].try { "%.0f" % self }
            row["上位"]   = e["上位"].try { "%.3f %%" % (self * 100.0) }
            row["割合"]   = e["割合"].try { "%.3f %%" % (self * 100.0) }
            if Rails.env.local?
              row["基準値"] = e["基準値"].try { "%.3f" % self }
            end
            row["人数"] = e["人数"]
          end
        end
      end

      def rows
        sd_merged_grade_infos.collect do |e|
          {}.tap do |row|
            row["棋力"] = e[:grade_info].name
            if Rails.env.local?
              row["階級値"] = e["階級値"]
              row["基準値"] = e["基準値"]
            end
            row["偏差値"] = e["偏差値"]
            row["上位"] = e["累計相対度数"]
            row["割合"] = e["相対度数"]
            row["人数"] = freq_count(e[:grade_info])
          end
        end
      end

      def sd_merged_grade_infos
        @sd_merged_grade_infos ||= yield_self do
          av = grade_infos.collect do |grade_info|
            { :grade_info => grade_info, "度数" => freq_count(grade_info) }
          end
          StandardDeviation.call(av)
        end
      end

      def grade_infos
        @grade_infos ||= ::Swars::GradeInfo.find_all(&:visualize)
      end

      ################################################################################

      def user_total_count
        grade_infos.sum { |e| freq_count(e) }
      end

      ################################################################################

      def title
        "#{super} (#{user_total_count}人)"
      end

      ################################################################################

      concerning :ChartMethods do
        def chart_source
          @chart_source ||= grade_infos.reverse.collect do |grade_info|
            { :name => grade_info.name, :count => freq_count(grade_info) }
          end
        end

        def custom_chart_params
          {
            data: {
              labels: chart_source.collect { |e| e[:name].remove(/[段級]/) },
              datasets: [
                { data: chart_source.collect { |e| e[:count] } },
              ],
            },
            scales_y_axes_ticks: nil,
            scales_y_axes_display: false,
          }
        end
      end

      ################################################################################

      concerning :AggregateAccessorMethods do
        def freq_count(grade_info)
          aggregate[grade_info.key.to_sym] || 0
        end
      end

      ################################################################################

      concerning :AggregateMethods do
        class_methods do
          def mock_setup
            alice = ::Swars::User.create!
            bob = ::Swars::User.create!
            carol = ::Swars::User.create!
            battles = []
            battles << ::Swars::Battle.create!(strike_plan: "GAVA角") do |e|
              e.memberships.build(user: alice, grade_key: "九段")
              e.memberships.build(user: bob, grade_key: "初段")
            end
            battles << ::Swars::Battle.create!(strike_plan: "GAVA角") do |e|
              e.memberships.build(user: alice, grade_key: "九段")
              e.memberships.build(user: carol, grade_key: "初段")
            end
            battles
          end
        end

        def aggregate_now
          # # 間違った方法
          # counts = Hash.new(0)
          # progress_start(main_scope.count.ceildiv(batch_size))
          # main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
          #   progress_next
          #   if batch_index >= batch_limit
          #     break
          #   end
          #   scope = condition_add(scope)
          #   res = scope.select(::Swars::Membership.arel_table[:user_id]).distinct.count # ユニークにする段階が早すぎて不整合が埋まれる
          #   counts.update(res) { |_, a, b| a + b }
          # end
          # return counts.transform_keys { |e| e.join(SEPARATOR) }

          if one_shot
            scope = condition_add(main_scope)
            scope = scope.group(::Swars::Grade.arel_table[:key])
            counts = scope.select(::Swars::Membership.arel_table[:user_id]).distinct.count # distinct.count = count.keys.size
          else
            counts = Hash.new { |h, k| h[k] = Set.new }
            progress_start(main_scope.count.ceildiv(batch_size))
            main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
              progress_next
              if batch_index >= batch_limit
                break
              end
              scope = condition_add(scope)
              if false
                # 場合によっては集計するので遅い (個数も必要な場合はこちらだけど個数はいらない)
                scope = scope.group(::Swars::Grade.arel_table[:key])
                scope = scope.group(::Swars::Membership.arel_table[:user_id])
                res = scope.count.keys
              else
                # ユニークなペアがほしいだけならこちらの方がシンプルで速い
                res = scope.distinct.pluck(::Swars::Grade.arel_table[:key], ::Swars::Membership.arel_table[:user_id])
              end
              res.each do |grade_key, user_id|
                counts[grade_key] << user_id
              end
            end
            counts = counts.transform_values(&:size)
          end
        end

        def condition_add(scope)
          scope = scope.joins(:grade)
        end
      end
    end
  end
end
