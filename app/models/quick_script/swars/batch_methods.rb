# frozen-string-literal: true

module QuickScript
  module Swars
    concern :BatchMethods do
      include CacheMod

      class_methods do
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
        end
      end

      def default_options
        options = defined?(super) ? super : {}
        options.merge({
            :verbose     => Rails.env.development? || Rails.env.staging? || Rails.env.production?,
            :batch_size  => Rails.env.local? ? 5000 : 1000,
            :batch_limit => nil,
          })
      end

      def call
        aggregate
      end

      def progress_start(total_step)
        if verbose?
          @progress_cop = Bioshogi::Formatter::Animation::ProgressCop.new(total_step) { |e| puts e }
        end
      end

      def progress_next(message = "")
        if @progress_cop
          @progress_cop.next_step("#{self.class.name.demodulize} #{message}".squish)
        end
      end

      def verbose?
        @options[:verbose]
      end

      def main_scope
        @options[:scope] || ::Swars::Membership.all
      end

      def batch_size
        @options[:batch_size]
      end

      def batch_limit
        @options[:batch_limit]
      end
    end
  end
end
