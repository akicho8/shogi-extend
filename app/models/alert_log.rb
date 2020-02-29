# == Schema Information ==
#
# アラートログテーブル (alert_logs)
#
# +--------------+--------------+----------------+-------------+-----------------------+-------+
# | カラム名     | 意味         | タイプ         | 属性        | 参照                  | INDEX |
# +--------------+--------------+----------------+-------------+-----------------------+-------+
# | id           | ID           | integer(4)     | NOT NULL PK |                       |       |
# | target_id    | 対象ID       | integer(4)     |             | => (target_type)#id   | A     |
# | target_type  | 対象タイプ   | string(255)    |             | モデル名(polymorphic) | A     |
# | partner_id   | 相棒ID       | integer(4)     |             | => (partner_type)#id  | B     |
# | partner_type | 相棒タイプ   | string(255)    |             | モデル名(polymorphic) | B     |
# | subject      | 題名         | string(255)    |             |                       |       |
# | free_columns | Free columns | text => Hash   |             |                       |       |
# | created_at   | 作成日時     | datetime       | NOT NULL    |                       |       |
# | updated_at   | 更新日時     | datetime       | NOT NULL    |                       |       |
# | body         | 本文         | text(16777215) |             |                       |       |
# +--------------+--------------+----------------+-------------+-----------------------+-------+

class AlertLog < ApplicationRecord
  # ==== Examples
  #   AlertLog.track("メッセージ")
  #   AlertLog.track("メッセージ", :body => "詳しい内容")
  #
  def self.track(subject, **options)
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
  #     MailCop.developper_notice(params).deliver_now
  #   end
  #   if slack_notify
  #     Slacker.send_message([subject, body].join("\n").strip)
  #   end
  # end
end
