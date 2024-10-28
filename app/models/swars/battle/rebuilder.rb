module Swars
  class Battle
    class Rebuilder
      def initialize(record, options = {})
        @record = record
        @options = options
      end

      def call
        begin
          Retryable.retryable(retryable_options) do
            without_retry
          end
        rescue => error
          $stdout.puts
          $stdout.puts error
          $stdout.flush
        end
      end

      def retryable_options
        {
          :on           => StandardError,
          :tries        => @options[:tries] || 5,
          :sleep        => 1,
          # :ensure       => proc { |retries| puts "E#{retries}" if retries.positive? },
          # :exception_cb => proc { |exception| puts; puts "#{exception}"             },
          :log_method   => proc { |retries, exception| puts; puts "E#{retries}: #{exception}" },
        }
      end

      def without_retry
        tag_names = -> { @record.memberships.collect { |e| e.taggings.collect { |e| e.tag.name } } }
        before = tag_names.call
        build_fast
        after = tag_names.call
        updated = before != after
        mark = updated ? "U" : "."
        $stdout.print mark
        $stdout.flush
        updated
      end

      def build_fast
        @record.parser_exec
        @record.transaction do
          @record.memberships.each(&:save!)
          @record.updated_at = Time.current
          @record.save!
        end
      end
    end
  end
end
