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

require "rails_helper"

RSpec.describe AppLog, type: :model do
  let(:instance)       { FactoryBot.create(:app_log)         }
  let(:user)           { FactoryBot.create(:user)            }
  let(:default_attrs)  { FactoryBot.attributes_for(:app_log) }

  it "バリデーションが正しい" do
    instance.valid?
    assert2 { instance.errors.blank? }
  end

  describe "作成系" do
    it "作成できる" do
      app_log = AppLog.create(default_attrs)
      assert2 { instance.errors.blank? }
    end
  end

  describe "更新系" do
    it "更新できる" do
      instance.update(default_attrs)
      assert2 { instance.errors.blank? }
    end
  end

  describe "削除系" do
    before { instance }
    it "削除できる" do
      proc { instance.destroy! }.should change(AppLog, :count).by(-1)
    end
  end

  describe "アプリ依存のインタフェース" do
    it "汎用" do
      record = AppLog.notify(subject: "xxx")
      assert2 { record.subject == "xxx" }
    end
  end

  describe "メール通知対応" do
    it "works" do
      AppLog.notify(mail_notify: true)
      assert2 { ActionMailer::Base.deliveries.count == 1 }
    end
    it "toオプション" do
      AppLog.notify(to: "xxx@xxx", mail_notify: true)
      mail = ActionMailer::Base.deliveries.last
      assert2 { mail.to == ["xxx@xxx"] }
    end
  end

  it "Slack通知" do
    AppLog.notify(slack_notify: true)
  end
end
