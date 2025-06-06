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
          { name: "詳細", icon: "chart-box", _v_bind: { href: "/lab/swars/user-dist.html", target: "_self", }, },
        ]
      end

      def call
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

      ################################################################################

      concerning :AggregateAccessorMethods do
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
            counts = Hash.new { |h, k| h[k] = Set[] }
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

        def condition_add(scope)
          scope = scope.joins(:battle => [:imode, :xmode, :rule], :grade => [])
          scope = scope.group(::Swars::Imode.arel_table[:key])
          scope = scope.group(::Swars::Xmode.arel_table[:key])
          scope = scope.group(::Swars::Rule.arel_table[:key])
          scope = scope.group(::Swars::Grade.arel_table[:key])
        end
      end
    end
  end
end
