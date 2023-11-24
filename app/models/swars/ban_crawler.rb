# 垢BAN情報を更新する
#
# rails r 'Swars::BanCrawler.new(limit: 1, ban_reset: true).call'
# rails r 'Swars::BanCrawler.new(grade: "九段", limit: 1, execute: false).call'
#
module Swars
  class BanCrawler
    def initialize(options = {})
      @options = {
        :execute   => false,                    # 最終的にDBを更新するか？
        # 条件
        :request_only => false,                 #
        :grade        => nil,                   # 段級位制限
        :limit        => nil,                   # 件数制限
        # その他
        :ban_reset => false,                    # 事前にBAN情報をリセットするか？ (localのみ)
        :sleep     => Rails.env.local? ? 0 : 2, # 本家への負荷軽減用
      }.merge(options)
    end

    def call
      prepare
      AppLog.important(subject: subject, body: body, mail_notify: true)
      scope.find_each { |e| one_process(e) }
      @end_at = Time.current
      AppLog.important(subject: subject, body: body, mail_notify: true)
    end

    private

    def prepare
      if @options[:ban_reset]
        Rails.env.local? or raise
        User.find_each(&:ban_clear)
      end

      @begin_at = Time.current
      @old_count = scope.count
    end

    def one_process(user)
      r = Agent::Mypage.new(@options.merge(user_key: user.key)).fetch
      user.ban_set(r.ban_user?)
      @options[:execute] and user.save!
      if r.ban_user?
        rows << row_build(user, r)
      end
    end

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
      ].reject(&:blank?).join
    end

    def other
      {
        "開始" => @begin_at&.to_fs(:ymdhms),
        "終了" => @end_at&.to_fs(:ymdhms),
      }
    end

    def rows
      @rows ||= []
    end

    def scope
      @scope ||= User.ban_crawl_scope(@options)
    end
  end
end
