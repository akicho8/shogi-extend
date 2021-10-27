# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Alert log (alert_logs as AlertLog)
#
# |------------+----------+--------------+-------------+------+-------|
# | name       | desc     | type         | opts        | refs | index |
# |------------+----------+--------------+-------------+------+-------|
# | id         | ID       | integer(8)   | NOT NULL PK |      |       |
# | subject    | 件名     | string(255)  | NOT NULL    |      |       |
# | body       | 内容     | string(8192) | NOT NULL    |      |       |
# | created_at | 作成日時 | datetime     | NOT NULL    |      |       |
# |------------+----------+--------------+-------------+------+-------|

class AlertLog < ApplicationRecord
  # rails r 'AlertLog.notify(subject: "(subject)", body: "(body)")'
  # rails r 'AlertLog.notify(subject: "(subject)", body: "(body)", slack_notify: true)'
  # rails r 'AlertLog.notify(subject: "(subject)", body: "(body)", slack_notify: true, mail_notify: true)'
  def self.notify(params)
    create!(params)
  end

  attr_accessor :mail_notify
  attr_accessor :slack_notify
  attr_accessor :attachments
  attr_accessor :to

  before_validation on: :create do
    [:subject, :body].each do |key|
      public_send("#{key}=", public_send(key).to_s.first(self.class.columns_hash[key.to_s].limit))
    end
  end

  after_create_commit do
    if mail_notify
      params = { subject: subject, body: body }
      if attachments
        params[:attachments] = attachments
      end
      if to
        params[:to] = to
      end
      SystemMailer.notify(params).deliver_later
    end
    if slack_notify
      SlackAgent.notify(subject: subject, body: body)
    end
  end
end
