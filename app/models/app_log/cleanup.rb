# 古い AppLog レコードを削除する
# rails r AppLog::Cleanup.new.call

class AppLog
  class Cleanup
    def initialize(options = {})
      @options = {
        :execute    => false,
        :expires_in => Rails.env.production? ? 2.weeks : 0.days,
      }.merge(options)
    end

    def call
      @errors = []
      @scope = AppLog.old_only(@options[:expires_in])
      @count = @scope.count
      @total = AppLog.count
      @free_changes = FreeSpace.new.call do
        @scope.find_each do |record|
          begin
            if @options[:execute]
              record.destroy!
            end
          rescue ActiveRecord::Deadlocked => error
            @errors << error
          end
        end
      end
      SystemMailer.notify(fixed: true, subject: subject, body: body).deliver_later
    end

    private

    def subject
      [
        "AppLog 削除",
        "#{@count}/#{@total}個",
        @free_changes.join("→"),
      ].join(" ")
    end

    def body
      [
        "▼オプション",
        @options.to_t,
        "",
        "▼エラー",
        @errors.to_t,
      ].compact.collect(&:strip).join("\n")
    end
  end
end
