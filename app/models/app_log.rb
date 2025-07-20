# -*- coding: utf-8 -*-

# == Schema Information ==
#
# App log (app_logs as AppLog)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | level      | Level    | string(255) | NOT NULL    |      |       |
# | emoji      | Emoji    | string(255) | NOT NULL    |      |       |
# | subject    | 件名     | string(255) | NOT NULL    |      |       |
# | body       | 内容     | text(65535) | NOT NULL    |      |       |
# | process_id | Process  | integer(4)  | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add index] create_app_logs マイグレーションに add_index :app_logs, :process_id を追加してください
# [Warning: Need to add relation] AppLog モデルに belongs_to :process を追加してください
# --------------------------------------------------------------------------------

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
# AppLog.info(body: {foo: 1}, mail_notify: true, table_format: true)
# AppLog.info(Exception.new, emoji: "🧡", data: "追加の情報")
# AppLog.info(body: Exception.new, emoji: "🧡")
# AppLog.call("xxx")

class AppLog < ApplicationRecord
  EXCEPTION_SUPPORT      = true
  EXCEPTION_NOTIFIER_USE = false
  LEVEL_DEFAULT          = :info

  class << self
    # AppLog.call("x")
    # AppLog.call("x", level: "debug")
    # AppLog.call(body: "x", level: "debug")
    def call(body = nil, **params)
      if Rails.env.local?
        if params.keys.first.kind_of? String
          raise ArgumentError, params.inspect
        end
      end

      level_info = LogLevelInfo.fetch(params[:level].presence || LEVEL_DEFAULT)
      if level_info.available_environments.exclude?(Rails.env.to_sym)
        return
      end

      if body && params.has_key?(:body)
        raise ArgumentError, %(#{name}.#{__method__}("...", body: "...") 形式は受け付けません)
      end

      if body.kind_of?(Hash)
        warn <<~EOT
        #{name}.#{__method__}(params)
        は、
        #{name}.#{__method__}(**params)
        または、
        #{name}.#{__method__}(body: params)
        の間違いなので書き直してください
        EOT
      end

      if body
        params = params.merge(body: body)
      end

      if EXCEPTION_NOTIFIER_USE
        v = params[:exception] || params[:body]
        if v.kind_of?(Exception)
          ExceptionNotifier.notify_exception(v, data: params[:data])
        end
      end

      if EXCEPTION_SUPPORT
        if params[:body].kind_of?(Exception)
          exception = params.delete(:body)
          default = ErrorInfo.new(exception, params).to_h
          params = default.merge(params)
        end
      end

      attrs = level_info.to_app_log_attributes.merge(params)
      if attrs[:mail_notify]
        mail_notify(attrs)
      end
      if attrs[:slack_notify]
        slack_notify(attrs)
      end
      if attrs[:database]
        create!(attrs.slice(:level, :emoji, :subject, :body))
      end
    end

    # AppLog.debug("x")
    # AppLog.info("x")
    LogLevelInfo.keys.each do |key|
      define_method(key) do |body = nil, **params|
        call(body, **{ level: key }.merge(params))
      end
    end

    private

    def mail_notify(params)
      SystemMailer.notify({ fixed: true, rails_env_required: true }.merge(params)).deliver_later
    end

    def slack_notify(params)
      SlackSender.call(params)
    end
  end

  scope :level_like,   -> query { where(["level   LIKE ?", "%#{query}%"]) }
  scope :subject_like, -> query { where(["subject LIKE ?", "%#{query}%"]) }
  scope :body_like,    -> query { where(["body    LIKE ?", "%#{query}%"]) }
  scope :search,       -> query { body_like(query).or(subject_like(query)).or(level_like(query)) }

  scope :search2, -> query do
    scope = all
    SimpleQueryParser.parse(query.to_s).each do |plus, queries|
      queries.each do |query|
        sanitized = ActiveRecord::Base.sanitize_sql_like(query.downcase)
        scope = scope.where("#{plus ? '' : 'NOT'} (LOWER(body) LIKE ? OR LOWER(subject) LIKE ? OR LOWER(level) LIKE ?)", "%#{sanitized}%", "%#{sanitized}%", "%#{sanitized}%")
      end
    end
    scope = scope.order(:created_at, :id).reverse_order
  end

  scope :old_only,     -> expires_in { where(arel_table[:created_at].lteq(expires_in.seconds.ago)) } # 古いもの

  normalizes :subject, with: -> e { column_value_db_truncate(:subject, e) }
  normalizes :body,    with: -> e { column_value_db_truncate(:body, e)    }

  before_validation on: :create do
    self.level ||= LEVEL_DEFAULT
    self.emoji = EmojiInfo.lookup(emoji) || emoji || ""
    self.process_id ||= Process.pid

    normalize_blank_to_empty_string :subject, :body
  end
end
