# 参照されていないレコードを消していく
# rails r Swars::Battle.cleanup
module Swars
  class Battle
    class CleanupRunner
      def initialize(all, params = {})
        @all = all
        @params = {
          :time_limit => 4.hours,  # 最大処理時間(朝2時に実行したら6時には必ず終了させる)
          :sleep      => 0,
        }.merge(params)
      end

      def perform
        @start_time = Time.current
        memo["前"] = all.count

        all.find_in_batches(batch_size: 1000) do |records|
          one_group(records)
          rows << @group
        end

        memo["後"]   = all.count
        memo["差"]   = memo["後"] - memo["前"]
        memo["開始"] = @start_time.to_fs(:ymdhms)
        memo["終了"] = Time.current.to_fs(:ymdhms)

        SystemMailer.notify(fixed: true, subject: "バトル削除", body: body).deliver_later
      end

      private

      attr_reader :all
      attr_reader :params

      def one_group(records)
        @group = {}
        @group["日時"] = Time.current.to_fs(:ymdhms)
        @group["個数"] = records.size
        @group["成功"] = 0
        @group["失敗"] = 0
        if params[:time_limit] && params[:time_limit] <= (Time.current - @start_time)
          return
        end
        records.each do |e|
          begin
            if params[:fake_error]
              raise ActiveRecord::Deadlocked, "(fake_error)"
            end
            Retryable.retryable(on: ActiveRecord::Deadlocked) do
              e.destroy!
            end
            @group["成功"] += 1
          rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Deadlocked => invalid
            @group["失敗"] += 1
            errors["#{invalid.message} (#{invalid.class.name})"] += 1
          end
          sleep(params[:sleep])
        end
        @group
      end

      def one_record(record)
        begin
          if params[:fake_error]
            raise ActiveRecord::Deadlocked, "(fake_error)"
          end
          record.destroy!
          @group["成功"] += 1
        rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Deadlocked => invalid
          @group["失敗"] += 1
          errors["#{invalid.message} (#{invalid.class.name})"] += 1
        end
        sleep(params[:sleep])
      end

      def body
        [
          memo.to_t,
          rows.to_t,
          errors.to_t,
        ].reject(&:blank?).join("\n")
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
