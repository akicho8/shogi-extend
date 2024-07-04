# 垢BAN情報を更新する
#
# rails r 'Swars::User.find_each(&:ban_reset)'
# rails r 'Swars::BanCrawler.new(limit: 1, ban_reset: true).call'
# rails r 'Swars::BanCrawler.new(grade_keys: "九段", limit: 1).call'
# rails r 'Swars::BanCrawler.new(grade_keys: "九段", execute: false).call'
# rails r 'Swars::BanCrawler.new.call'
# rails r 'Swars::BanCrawler.new(grade_keys: %w(九段 八段 七段 六段 五段 四段 三段 二段 初段 1級), limit: 2000, execute: true).call'

module Swars
  class BanCrawler
    def initialize(options = {})
      @options = {
        :query     => {},                         # スコープ
        :sleep     => Rails.env.local? ? 0 : 1.0, # 本家への負荷軽減用 (local以外)
        :ban_reset => Rails.env.local?,           # 事前にBAN情報をリセットするか？ (localのみ)
        :log_limit => 50,
      }.merge(options)

      AppLog.info(body: options)
      AppLog.info(body: @options)
    end

    def call
      prepare
      AppLog.important(subject: subject, body: body, mail_notify: true)
      scope.find_each(&method(:one_process))
      @end_at = Time.current
      AppLog.important(subject: subject, body: body, mail_notify: true)
    end

    private

    def prepare
      if @options[:ban_reset]
        Rails.env.local? or raise
        User.find_each(&:ban_reset)
      end

      @begin_at = Time.current
      @scope_count = scope.count
      @found_count = 0
      @rows = []
      @all_users = []
    end

    def scope
      @scope ||= User.search(@options[:query])
    end

    def one_process(user)
      if true
        mypage = Agent::Mypage.new(@options.merge(user_key: user.key))
        user.ban_set(mypage.ban?)
        if mypage.ban?
          @found_count += 1
          @rows = (@rows + [user.to_h.merge("マイページ" => mypage.mypage_grade.oneline)]).take(@options[:log_limit])
          AppLog.important(subject: "[BAN] #{user.key}", body: user.to_h.to_t)
        end
      end
      @all_users = (@all_users + [user.to_h]).take(@options[:log_limit])
    end

    def subject
      if !@end_at
        "[開始] BANクローラー 走査件数:#{@scope_count}件"
      else
        "[終了] BANクローラー #{@scope_count}件中#{@found_count}件確定"
      end
    end

    def body
      [
        @options.to_t,
        other.to_t,
        @rows.to_t,
        @all_users.to_t,
      ].reject(&:blank?).join
    end

    def other
      {
        "開始" => @begin_at&.to_fs(:ymdhms),
        "終了" => @end_at&.to_fs(:ymdhms),
        "対象" => @scope_count,
        "発見" => @found_count,
      }
    end
  end
end
