# frozen-string-literal: true

# 一次集計
# rails r QuickScript::Swars::UserDistScript.new.cache_write
# rails r 'QuickScript::Swars::UserDistScript.new({}, batch_size: Float::INFINITY).cache_write'
# rails r 'QuickScript::Swars::UserDistScript.new({}, batch_limit: 1).cache_write'

module QuickScript
  module Swars
    class UserDistScript < Base
      include SwarsSearchHelperMethods
      include BatchMethods

      self.title = "【集計専用】将棋ウォーズ対局ルール別の利用者数分布"
      self.description = "将棋ウォーズの対局ルール別の利用者数を調べる"
      self.json_link = true

      SEPARATOR = "/"

      def header_link_items
        super + [
          { name: "詳細グラフ", _v_bind: { href: "/lab/swars/user-dist.html", target: "_self", }, },
        ]
      end

      def call
        # values = [
        #   { _component: "CustomChart", _v_bind: { params: custom_chart_params, }, style: { "max-width" => "800px", margin: "auto" }, :class => "is-unselectable is-centered", },
        #   simple_table(human_rows, always_table: true),
        # ]
        # v_stack(values, style: { "gap" => "1rem" })
        as_general_json
      end

      # http://localhost:3000/api/lab/swars/user-dist.json?json_type=general
      def as_general_json
        ::Swars::ImodeInfo.flat_map do |imode_info|
          ::Swars::XmodeInfo.flat_map do |xmode_info|
            ::Swars::RuleInfo.flat_map do |rule_info|
              ::Swars::GradeInfo.active_only.flat_map do |grade_info|
                {
                  "配置"   => imode_info.name,
                  "モード" => xmode_info.name,
                  "ルール" => rule_info.name,
                  "棋力"   => grade_info.name,
                  "人数"   => freq_count_by(imode_info.key, xmode_info.key, rule_info.key, grade_info.key),
                }
              end
            end
          end
        end
      end

      # def human_rows
      #   rows.collect do |row|
      #     row = row.merge({
      #         "棋力"   => item_name_search_link(row["棋力"]),
      #         "偏差値" => row["偏差値"].try { "%.0f" % self },
      #         "上位"   => row["上位"].try { "%.3f %%" % (self * 100.0) },
      #         "割合"   => row["割合"].try { "%.3f %%" % (self * 100.0) },
      #       })
      #     if Rails.env.local?
      #       row["基準値"] = row["基準値"].try { "%.3f" % self }
      #     end
      #     row
      #   end
      # end

      # def rows
      #   sd_merged_grade_infos.collect do |e|
      #     {}.tap do |row|
      #       row["棋力"]   = e[:grade_info].name
      #       if Rails.env.local?
      #         row["階級値"] = e["階級値"]
      #         row["基準値"] = e["基準値"]
      #       end
      #       row["偏差値"] = e["偏差値"]
      #       row["上位"]   = e["累計相対度数"]
      #       row["割合"]   = e["相対度数"]
      #       row["人数"]   = freq_count(e[:grade_info])
      #     end
      #   end
      # end

      # def sd_merged_grade_infos
      #   @sd_merged_grade_infos ||= yield_self do
      #     av = grade_infos.collect do |grade_info|
      #       { :grade_info => grade_info, "度数" => freq_count(grade_info) }
      #     end
      #     StandardDeviation.call(av)
      #   end
      # end

      # def grade_infos
      #   @grade_infos ||= ::Swars::GradeInfo.find_all(&:user_dist)
      # end

      ################################################################################

      # def user_total_count
      #   grade_infos.sum { |e| freq_count(e) }
      # end

      ################################################################################

      # def title
      #   "#{super} (#{user_total_count}人)"
      # end

      ################################################################################

      # concerning :ChartMethods do
      #   def chart_source
      #     @chart_source ||= grade_infos.reverse.collect do |grade_info|
      #       { :name => grade_info.name, :count => freq_count(grade_info) }
      #     end
      #   end
      #
      #   def custom_chart_params
      #     {
      #       data: {
      #         labels: chart_source.collect { |e| e[:name].remove(/[段級]/) },
      #         datasets: [
      #           { data: chart_source.collect { |e| e[:count] } },
      #         ],
      #       },
      #       scales_y_axes_ticks: nil,
      #       scales_y_axes_display: false,
      #     }
      #   end
      # end

      ################################################################################

      concerning :AggregateAccessorMethods do
        # # これルールをまたいで足してはいけない！ (重要)
        # # 1人が10分と3分で遊ぶこともあるので、足すと2人いることになってしまう
        # # 一次集計を細分化してしまったがために複雑になっている
        # def freq_count(grade_info)
        #   @freq_count ||= {}
        #   @freq_count[grade_info.key] ||= yield_self do
        #     total = 0
        #     ::Swars::ImodeInfo.each do |imode_info|
        #       ::Swars::XmodeInfo.each do |xmode_info|
        #         ::Swars::RuleInfo.each do |rule_info|
        #           total += freq_count_by(imode_info.key, xmode_info.key, rule_info.key, grade_info.key)
        #         end
        #       end
        #     end
        #     total
        #   end
        # end

        def freq_count_by(imode_key, xmode_key, rule_key, grade_key)
          key = [imode_key, xmode_key, rule_key, grade_key].join(SEPARATOR).to_sym
          aggregate[key] || 0
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
            counts = scope.select(::Swars::Membership.arel_table[:user_id]).distinct.count # distinct.count = count.keys.size
            counts.transform_keys { |e| e.join(SEPARATOR) }
          else
            counts = Hash.new { |h, k| h[k] = Set.new }
            progress_start(main_scope.count.ceildiv(batch_size))
            main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
              progress_next
              if batch_index >= batch_limit
                break
              end
              scope = condition_add(scope)
              res = scope.group(::Swars::Membership.arel_table[:user_id]).count
              res.keys.each do |imode_key, xmode_key, rule_key, grade_key, user_id|
                counts[[imode_key, xmode_key, rule_key, grade_key]] << user_id
              end
            end
            counts = counts.transform_keys { |e| e.join(SEPARATOR) }
            counts = counts.transform_values(&:size)
          end
        end

        def condition_add(s)
          s = s.joins(:battle => [:imode, :xmode, :rule])
          s = s.joins(:grade)
          if false
            s = s.where(::Swars::Imode.arel_table[:key].eq("normal"))
            s = s.where(::Swars::Xmode.arel_table[:key].eq("指導"))
            s = s.where(::Swars::Rule.arel_table[:key].eq("ten_min"))
            s = s.where(::Swars::Grade.arel_table[:key].eq("十段"))
          end
          s = s.group(::Swars::Imode.arel_table[:key])
          s = s.group(::Swars::Xmode.arel_table[:key])
          s = s.group(::Swars::Rule.arel_table[:key])
          s = s.group(::Swars::Grade.arel_table[:key])
        end
      end
    end
  end
end
