# -*- coding: utf-8 -*-
# == Schema Information ==
#
# App log (app_logs as AppLog)
#
# |------------+----------+--------------+-------------+------+-------|
# | name       | desc     | type         | opts        | refs | index |
# |------------+----------+--------------+-------------+------+-------|
# | id         | ID       | integer(8)   | NOT NULL PK |      |       |
# | subject    | 件名     | string(255)  | NOT NULL    |      |       |
# | body       | 内容     | string(8192) | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime     | NOT NULL    |      |       |
# |------------+----------+--------------+-------------+------+-------|
#
# ▼管理画面
# AppLogScript
#
# ▼ログレベル
# LogLevelInfo
#
# ▼実行例
# AppLog.info(subject: "xxx", body: "xxx")
# AppLog.info(subject: "xxx", body: "xxx", slack_notify: true)
# AppLog.info(subject: "xxx", body: "xxx", slack_notify: true, mail_notify: true)
# AppLog.info("xxx", mail_notify: true)
# AppLog.info(Exception.new, emoji: "🧡")
# AppLog.info(body: Exception.new, emoji: "🧡")
#
class AppLog < ApplicationRecord
  EXCEPTION_SUPPORT = true

  class << self
    def self.cleanup(...)
      Cleanup.new(...).call
    end

    LogLevelInfo.each do |e|
      define_method(e.key) do |body = nil, **params|
        if e.available_environments.include?(Rails.env.to_sym)
          call_with_log_level(e, body, params)
        end
      end
    end

    private

    def call_with_log_level(log_level_info, body, params)
      if true
        params = params.symbolize_keys # dup

        if body && params.has_key?(:body)
          raise ArgumentError, %(#{name}.#{__method__}("...", body: "...") 形式は受け付けません)
        end

        if body
          params = params.merge(body: body)
        end

        if EXCEPTION_SUPPORT
          if params[:body].kind_of?(Exception)
            exception = params.delete(:body)
            default = ErrorInfo.new(exception, params).to_h
            params = default.merge(params)
          end
        end
      end

      attrs = log_level_info.to_app_log_attributes.merge(params)
      create!(attrs.slice(:level, :emoji, :subject, :body)).tap do
        if attrs[:mail_notify]
          mail_notify(attrs)
        end
        if attrs[:slack_notify]
          slack_notify(attrs)
        end
      end
    end

    def mail_notify(params)
      SystemMailer.notify({fixed: true}.merge(params)).deliver_later
    end

    def slack_notify(params)
      SlackSender.call(params)
    end
  end

  scope :level_like,   -> query { where(["level   LIKE ?", "%#{query}%"]) }
  scope :subject_like, -> query { where(["subject LIKE ?", "%#{query}%"]) }
  scope :body_like,    -> query { where(["body    LIKE ?", "%#{query}%"]) }
  scope :search,       -> query { body_like(query).or(subject_like(query)).or(level_like(query)) }

  scope :old_only,     -> expires_in { where(arel_table[:created_at].lteq(expires_in.seconds.ago)) } # 古いもの

  before_validation on: :create do
    self.level ||= :debug
    self.emoji = EmojiInfo.lookup(emoji) || emoji || ""
    self.process_id ||= Process.pid

    [:subject, :body].each do |key|
      str = public_send(key).to_s
      max = self.class.columns_hash[key.to_s].limit
      str = str.first(max)
      public_send("#{key}=", str)
    end
  end
end
