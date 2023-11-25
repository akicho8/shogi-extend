# 垢BAN情報を更新する
#
# rails r 'Swars::User.find_each(&:ban_reset)'
# rails r 'Swars::BanCrawler.new(limit: 1, ban_reset: true).call'
# rails r 'Swars::BanCrawler.new(grade_keys: "九段", limit: 1, execute: false).call'
# rails r 'Swars::BanCrawler.new(grade_keys: "九段", execute: false).call'
# rails r 'Swars::BanCrawler.new.call'
# rails r 'Swars::BanCrawler.new(grade_keys: %w(九段 八段 七段 六段 五段 四段 三段 二段 初段 1級), limit: 2000, execute: true).call'

module Swars
  class BanCrawler
    def initialize(options = {})
      @options = {
        # 条件 (ban_crawl_scope にぜんぶ渡す)
        :grade_keys           => nil, # 段級位制限
        :user_keys            => nil, # ウォーズID制限
        :ban_crawled_count_lteq => nil, # 垢BANチェック指定回数以下
        :ban_crawled_at_lt    => nil, # 垢BANチェックの前回が指定日時より過去
        :limit                => nil, # 件数制限 (2000件=30分)

        # その他
        :execute              => false,                      # 最終的にDBを更新するか？
        :request_only         => false,                      # 未使用
        :sleep                => Rails.env.local? ? 0 : 1.0, # 本家への負荷軽減用 (local以外)
        :ban_reset            => Rails.env.local?,           # 事前にBAN情報をリセットするか？ (localのみ)
        :debug                => true,
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
      @scope ||= User.ban_crawl_scope(@options)
    end

    def one_process(user)
      r = Agent::Mypage.new(@options.merge(user_key: user.key)).fetch
      user.ban_set(r.ban_user?)
      @options[:execute] and user.save!
      if r.ban_user?
        rows << user.to_ban_h.merge("マイページ" => r.oneline)
      end
      if @options[:debug]
        processed_users << user.to_ban_h
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
        processed_users.to_t,
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

    def processed_users
      @processed_users ||= []
    end
  end
end
