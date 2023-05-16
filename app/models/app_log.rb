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
            params = params.deep_symbolize_keys # dup
            if body
              if params.has_key?(:body)
                raise ArgumentError, %(#{name}.#{__method__}("...", body: "...") 形式は受け付けません)
              end
              params = params.merge(body: body)
            end
            if params[:body].kind_of?(Exception)
              params.update(ErrorTextBuilder.new(params[:body]).to_h)
            end
          end
          attributes = e.to_app_log_attributes.merge(params)
          create!(attributes)
          if e.mail_notify
            mail_notify(attributes)
          end
          if e.slack_notify
            slack_notify(attributes)
          end
        end
      end
    end

    def mail_notify(params)
      SystemMailer.notify(params).deliver_later
    end

    def slack_notify(params)
      SlackAgent.notify(params)
    end
  end

  scope :level_like,   -> query { where(["level   LIKE ?", "%#{query}%"]) }
  scope :subject_like, -> query { where(["subject LIKE ?", "%#{query}%"]) }
  scope :body_like,    -> query { where(["body    LIKE ?", "%#{query}%"]) }
  scope :search,       -> query { body_like(query).or(subject_like(query)).or(level_like(query)) }

  scope :old_only,     -> expires_in { where(arel_table[:created_at].lteq(expires_in.seconds.ago)) } # 古いもの

  attr_accessor :mail_notify
  attr_accessor :slack_notify
  attr_accessor :attachments
  attr_accessor :to

  before_validation on: :create do
    self.level ||= :debug
    self.emoji ||= ""

    [:subject, :body].each do |key|
      str = public_send(key).to_s
      max = self.class.columns_hash[key.to_s].limit
      str = str.first(max)
      public_send("#{key}=", str)
    end
  end

  # after_create_commit do
  #   # if mail_notify
  #   #   params = { emoji: emoji, subject: subject, body: body }
  #   #   if attachments
  #   #     params[:attachments] = attachments
  #   #   end
  #   #   if to
  #   #     params[:to] = to
  #   #   end
  #   #   SystemMailer.notify(params).deliver_later
  #   # end
  #   # if slack_notify
  #   #   SlackAgent.notify(emoji: emoji, subject: subject, body: body)
  #   # end
  # end

  def real_emoji
    EmojiInfo.lookup(emoji) || emoji
  end
end
