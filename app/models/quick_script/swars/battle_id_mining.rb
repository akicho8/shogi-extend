# frozen-string-literal: true

module QuickScript
  module Swars
    class BattleIdMining < Base
      include SwarsSearchHelperMethods

      self.title        = "対局IDsの収集と確認"
      self.json_link = true

      def as_general_json
        aggregate
      end

      def call
        simple_table(human_rows, always_table: true)
      end

      def human_rows
        aggregate
      end

      def need_size
        @options[:need_size] || (Rails.env.local? ? 2 : need_size_default)
      end
    end
  end
end
