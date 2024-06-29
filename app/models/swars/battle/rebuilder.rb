module Swars
  module Battle
    class Rebuilder
      def initialize(record)
        @record = record
      end
    end

    def call
      retryable_options = {
        :on           => StandardError,
        :tries        => 5,
        :sleep        => 1,
        :ensure       => proc { |retries| puts "#{retries}回リトライして終了した" if retries.positive? },
        :exception_cb => proc { |exception| puts "exception_cb: #{exception}"                          },
        :log_method   => proc { |retries, exception| puts "#{retries}回目の例外: #{exception}"         },
      }
      begin
        Retryable.retryable(retryable_options) do
          without_retry
        end
      rescue => error
        puts error
      end
    end

    def without_retry
      tag_names = -> { @record.memberships.collect { |e| e.taggings.collect { |e| e.tag.name } } }
      before = tag_names.call
      build_fast
      after = tag_names.call
      updated = before != after
      print updated ? "U" : "."
      updated
    end

    def build_fast
      parser_exec
      transaction do
        @record.memberships.each(&:save!)
        self.updated_at = Time.current
        save!
      end
    end
  end
end
