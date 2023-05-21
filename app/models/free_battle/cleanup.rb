# 古い FreeBattle レコードを削除する
# rails r FreeBattle::Cleanup.new.call

class FreeBattle
  class Cleanup
    def initialize(options = {})
      @options = {
        :execute    => false,
        :expires_in => Rails.env.production? ? 30.days : 0.days,
      }.merge(options)
    end

    def call
      @errors = []
      @scope = FreeBattle.deleteable_only.old_only(@options[:expires_in])
      @count = @scope.count
      @target_records_t = @scope.collect(&:info).to_t

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

      AppLog.important(subject: subject, body: body)
    end

    private

    def subject
      [
        "FreeBattle 削除",
        "#{@count}個",
        @free_changes.join("→"),
      ].join(" ")
    end

    def body
      [
        "▼オプション",
        @options.to_t,
        "",
        "▼削除したレコード",
        @target_records_t,
        "",
        "▼エラー",
        @errors.to_t,
      ].compact.collect(&:strip).join("\n")
    end
  end
end
