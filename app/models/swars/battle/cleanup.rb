# 参照されていないレコードを消していく
# rails r 'Swars::Battle.cleanup'
module Swars
  class Battle
    class Cleanup
      def initialize(options = {})
        @options = {
          :scope      => Battle.none,
          :execute    => false,
          :time_limit => nil,
          :verbose    => false,
        }.merge(options)
      end

      def call
        @start_time = Time.current
        @count = scope.count
        memo["前"] = scope.count

        @free_changes = FreeSpace.new.call do
          scope.find_in_batches(batch_size: 1000) do |records|
            one_group(records)
            rows << @group
          end
        end

        memo["後"]   = scope.count
        memo["差"]   = memo["後"] - memo["前"]
        memo["開始"] = @start_time.to_fs(:ymdhms)
        memo["終了"] = Time.current.to_fs(:ymdhms)
        memo["空き"] = @free_changes.join(" → ")

        AppLog.important(subject: subject, body: body)

        if @options[:verbose]
          puts subject
          puts body
        end
      end

      private

      def scope
        @options[:scope]
      end

      def one_group(records)
        @group = {}
        @group["日時"] = Time.current.to_fs(:ymdhms)
        @group["個数"] = records.size
        @group["成功"] = 0
        @group["失敗"] = 0
        if @options[:time_limit] && @options[:time_limit] <= (Time.current - @start_time)
          return
        end
        records.each { |e| one_record(e) }
        @group
      end

      def one_record(record)
        begin
          Retryable.retryable(on: ActiveRecord::Deadlocked) do
            if @options[:execute]
              record.destroy!
            end
          end
          @group["成功"] += 1
        rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Deadlocked => error
          @group["失敗"] += 1
          errors["#{error.message} (#{error.class.name})"] += 1
        end
      end

      def subject
        [
          "バトル削除",
          "#{@count}個",
          @free_changes.join("→"),
        ].join(" ")
      end

      def body
        [
          @options.except(:scope).to_t,
          memo.to_t,
          rows.to_t,
          errors.to_t,
        ].reject(&:blank?).join
      end

      def memo
        @memo ||= {}
      end

      def rows
        @rows ||= []
      end

      def errors
        @errors ||= Hash.new(0)
      end
    end
  end
end
