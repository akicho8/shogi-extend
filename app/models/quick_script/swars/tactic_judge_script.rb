# frozen-string-literal: true

#
# 戦法勝敗数
#
# 一次集計: rails r QuickScript::Swars::TacticJudgeScript.new.cache_write
#
module QuickScript
  module Swars
    class TacticJudgeScript < Base
      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
        end
      end

      self.title        = "戦法勝敗数"
      self.description  = "戦法の勝敗数を調べる"
      self.debug_mode   = Rails.env.development?
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

        "この方法は集計に恐しく時間がかかる"

        # aggregate
      end

      private

      concerning :AggregateMethods do
        include CacheMod

        def aggregate_now
          Bioshogi::Analysis::TacticInfo.all_elements.each.with_index.inject({}) do |a, (item, i)|
            a.merge(item.key => finder(item, i))
          end
        end

        def finder(item, i)
          p [Time.current.to_fs(:ymdhms), i, Bioshogi::Analysis::TacticInfo.all_elements.size, item]

          total_count = { win: 0, lose: 0 }
          if tag = ActsAsTaggableOn::Tag.find_by(name: item.key)
            taggings = tag.taggings
            taggings = taggings.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags")

            all_block_count = taggings.count.ceildiv(batch_size)

            taggings.in_batches(of: batch_size).each_with_index do |taggings, batch|
              p [Time.current.to_fs(:ymdhms), item, condition_method, batch, all_block_count, batch.fdiv(all_block_count).round(2)] if false

              # taggings = taggings.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags")

              taggable_ids = taggings.pluck(:taggable_id)
              taggable_ids.size <= batch_size or raise "must not happen"

              ########################################

              scope = ::Swars::Membership.where(id: taggable_ids)
              scope = scope.joins(battle: :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
              # scope = scope.joins(:judge).where(Judge.arel_table[:key].eq(:win))
              counts = scope.joins(:judge).group("judges.key").count
              total_count[:win] += counts["win"] || 0
              total_count[:lose] += counts["lose"] || 0
            end
          end
          total_count
        end

        def batch_size
          1000
        end
      end
    end
  end
end
