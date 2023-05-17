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

# 管理画面
# app/models/backend_script/app_log_script.rb
#
#

# rails r 'AppLog.info(subject: "(subject)", body: "(body)")'
# rails r 'AppLog.info(subject: "(subject)", body: "(body)", slack_notify: true)'
# rails r 'AppLog.info(subject: "(subject)", body: "(body)", slack_notify: true, mail_notify: true)'

class AppLog < ApplicationRecord
  # AppLog.cleanup
  def self.cleanup(...)
    Cleanup.new(...).call
  end

  def self.notify(params)
    debug(params)
  end

  class << self
    LogLevelInfo.each do |e|
      define_method(e.key) do |body = nil, **params|
        if e.available_environments.include?(Rails.env.to_sym)
          if true
            params = params.symbolize_keys # dup
            if body
              if params.has_key?(:body)
                raise ArgumentError, %(#{name}.#{__method__}("...", body: "...") 形式は受け付けません)
              end
              params = params.merge(body: body)
            end
            if params[:body].kind_of?(Exception)
              params.update(ErrorInfo.new(params[:body]).to_h)
            end
          end
          attributes = e.to_app_log_attributes.merge(params)
          record = create!(attributes.slice(:level, :emoji, :subject, :body))
          if attributes[:mail_notify]
            mail_notify(attributes)
          end
          if attributes[:slack_notify]
            slack_notify(attributes)
          end
          record
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

    [:subject, :body].each do |key|
      str = public_send(key).to_s
      max = self.class.columns_hash[key.to_s].limit
      str = str.first(max)
      public_send("#{key}=", str)
    end
  end
end
