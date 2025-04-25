# frozen-string-literal: true

#
# 戦法分布数
#
# 一次集計: rails r QuickScript::Swars::TacticFreqScript.new.cache_write
#
module QuickScript
  module Swars
    class TacticFreqScript < Base
      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
        end
      end

      self.title        = "戦法分布数"
      self.description  = "戦法の出現頻度を調べる"
      self.qs_invisible = true

      def call
        # Bioshogi::Analysis::TacticInfo.all_elements.collect do |item|
        #   {}.tap do |row|
        #     row["名前"] = item.key
        #     row["頻度"] = aggregate[item.key] || 0
        #   end
        # end

        # Bioshogi::Analysis::TacticInfo.all_elements.inject({}) do |a, item|
        #   a.merge(item.key => aggregate[item.key] || 0)
        # end

        aggregate
      end

      private

      concerning :AggregateMethods do
        include CacheMod

        def aggregate_now
          Bioshogi::Analysis::TacticInfo.all_elements.inject({}) do |a, item|
            a.merge(item.key => membership_frequency_count_item(item))
          end
        end

        # 個数を求めるのは速い
        # しかしそこから memberships -> battle と繋げると現実的でない遅さになる
        def membership_frequency_count_item(item)
          p item
          if tag = ActsAsTaggableOn::Tag.find_by(name: item.key)
            tag.taggings.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags").count
          end
        end
      end
    end
  end
end
