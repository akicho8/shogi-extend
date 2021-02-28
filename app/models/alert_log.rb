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
  # ==== Examples
  #   AlertLog.track("メッセージ")
  #   AlertLog.track("メッセージ", :body => "詳しい内容")
  #
  def self.track(subject, options = {})
    create!(options.merge(subject: subject))
  end

  before_validation on: :create do
    [:subject, :body].each do |key|
      public_send("#{key}=", public_send(key).to_s.first(self.class.columns_hash[key.to_s].limit))
    end
  end

  attr_accessor :mail_notify, :to, :attachments, :slack_notify

  # before_validation on: :create do
  #   if subject
  #     self.subject = subject.to_s.first(self.class.columns_hash["subject"].limit)
  #   end
  #   true
  # end

  # after_create do
  #   if mail_notify
  #     params = {:subject => subject, :body => body, :to => to} # to が空なら最後に値が入る
  #     if attachments
  #       params[:attachments] = attachments
  #     end
  #     MailCop.developer_notice(params).deliver_later
  #   end
  #   if slack_notify
  #     Slacker.send_message([subject, body].join("\n").strip)
  #   end
  # end
end
