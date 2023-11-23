# rails r 'Swars::User.ban_crawler'
# rails r 'Swars::User.ban_crawler(grade: "九段", limit: 1, execute: false)'
module Swars
  class User
    class BanCrawler
      def initialize(options = {})
        @options = {
          :execute => false,
          :sleep   => (Rails.env.production? || Rails.env.staging?) ? 2 : 0,
          :grade   => nil,
          :limit   => nil,
        }.merge(options)
      end

      def call
        if Rails.env.local?
          User.all.each { |e| e.update!(ban_at: nil) }
        end

        @count_all = scope.count

        scope.find_each(batch_size: 1000) do |user|
          mypage_result = Swars::Agent::Mypage.new(user_key: user.key).fetch
          if mypage_result.ban_user?
            user.ban_at = Time.current
            if @options[:execute]
              user.save!
            end
            rows << row_build(user, mypage_result)
          end
        end

        AppLog.important(subject: subject, body: body, mail_notify: true)

        # @scope = User.ban_crawler_scope(@options)
        #
        # @start_time = Time.current
        # @count = @scope.count
        # memo["前"] = @scope.count
        #
        # @free_changes = FreeSpace.new.call do
        #   @scope.find_in_batches(batch_size: 1000) do |records|
        #     one_group(records)
        #     rows << @group
        #   end
        # end
        #
        # memo["後"]   = @scope.count
        # memo["差"]   = memo["後"] - memo["前"]
        # memo["開始"] = @start_time.to_fs(:ymdhms)
        # memo["終了"] = Time.current.to_fs(:ymdhms)
        # memo["空き"] = @free_changes.join(" → ")
        #
        # AppLog.important(subject: subject, body: body)
      end

      private

      def row_build(user, mypage_result)
        {
          "ID"         => user.id,
          "ウォーズID" => user.key,
          "段級"       => user.grade.name,
          "検索数"     => user.search_logs_count,
          "対局数"     => user.memberships.size,
          "直近検索"   => user.last_reception_at&.to_fs(:ymdhms),
          "登録日時"   => user.created_at.to_fs(:ymdhms),
          "BAN"        => user.ban_at,
          "マイページ" => mypage_result.oneline,
          "確認日時"   => Time.current.to_fs(:ymdhms),
        }
      end

      # def one_group(records)
      #   @group = {}
      #   @group["日時"] = Time.current.to_fs(:ymdhms)
      #   @group["個数"] = records.size
      #   @group["成功"] = 0
      #   @group["失敗"] = 0
      #   if @options[:time_limit] && @options[:time_limit] <= (Time.current - @start_time)
      #     return
      #   end
      #   records.each { |e| one_record(e) }
      #   @group
      # end
      #
      # def one_record(record)
      #   begin
      #     Retryable.retryable(on: ActiveRecord::Deadlocked) do
      #       if @options[:execute]
      #         record.destroy!
      #       end
      #     end
      #     @group["成功"] += 1
      #   rescue ActiveRecord::RecordNotDestroyed, ActiveRecord::Deadlocked => error
      #     @group["失敗"] += 1
      #     errors["#{error.message} (#{error.class.name})"] += 1
      #   end
      # end
      #
      def subject
        [
          "BANクローラー",
          "#{@count_all}件中#{rows.count}件発見",
        ].join(" ")
      end

      def body
        [
          @options.to_t,
          rows.to_t,
          # memo.to_t,
          # rows.to_t,
          # errors.to_t,
        ].reject(&:blank?).join
      end

      # def memo
      #   @memo ||= {}
      # end
      #
      # def rows
      #   @rows ||= []
      # end
      #
      # def errors
      #   @errors ||= Hash.new(0)
      # end

      def rows
        @rows ||= []
      end

      # def target_grade
      #   if v = @options[:grade]
      #     scope = User.where(grade: Swars::Grade[v])
      #   end
      # end

      def scope
        Swars::User.ban_crawler_scope(@options)
      end

      # def grade
      #   Swars::Grade.fetch_if(@options[:grade])
      # end
      #
      # def limit
      #   @options[:limit].presence
      # end
    end
  end
end
