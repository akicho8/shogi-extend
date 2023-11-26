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
        :debug     => true,
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
      @old_count = scope.count
    end

    def scope
      @scope ||= User.search(@options[:query])
    end

    def one_process(user)
      if true
        r = Agent::Mypage.new(@options.merge(user_key: user.key)).fetch
        user.ban_set(r.ban?)
        if r.ban?
          rows << user.to_h.merge("マイページ" => r.oneline)
        end
      end
      if @options[:debug]
        all_users << user.to_h
      end
    end

    def subject
      [
        @end_at ? "[終了]" : "[開始]",
        "BANクローラー",
        "#{@old_count}件中#{rows.count}件発見",
      ].join(" ")
    end

    def body
      [
        @options.to_t,
        other.to_t,
        rows.to_t,
        all_users.to_t,
      ].reject(&:blank?).join
    end

    def other
      {
        "開始" => @begin_at&.to_fs(:ymdhms),
        "終了" => @end_at&.to_fs(:ymdhms),
        "対象" => @old_count,
        "発見" => rows.count,
      }
    end

    def rows
      @rows ||= []
    end

    def all_users
      @all_users ||= []
    end
  end
end
