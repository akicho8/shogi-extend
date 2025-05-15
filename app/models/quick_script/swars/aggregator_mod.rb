# frozen-string-literal: true

module QuickScript
  module Swars
    concern :AggregatorMod do
      class_methods do
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
        end
      end

      def initialize(options = {})
        @options = default_options.merge(options)
      end

      def default_options
        {
          :verbose => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
        }
      end

      def call
        aggregate
      end

      private

      def aggregate_now
        raise NotImplementedError, "#{__method__} is not implemented"
      end

      def progress_log(batch_total, batch_index, message = "")
        if verbose?
          puts "[#{Time.current.to_fs(:ymdhms)}][#{self.class.name}][##{batch_index.next}/#{batch_total}] #{message}".squish
        end
      end

      def verbose?
        @options[:verbose]
      end

      def main_scope
        @options[:scope] || ::Swars::Membership.all
      end

      def batch_size
        @options[:batch_size] || (Rails.env.local? ? 10000 : 1000)
      end
    end
  end
end
