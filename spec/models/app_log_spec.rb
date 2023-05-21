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
  before do
    SlackSender.deliveries.clear
  end

  after do
    SlackSender.deliveries.clear
  end

  it "空でも作成できる" do
    assert2 { AppLog.debug }
  end

  it "記録できることを優先するので題名や本文が長すぎたらtruncateする" do
    assert2 { AppLog.debug(subject: "x" * 256).subject.size == 255 }
  end

  it "本文は第一引数にそのまま書いてもよい" do
    assert2 { AppLog.debug(body: "a", subject: "b").body == "a" }
    assert2 { AppLog.debug("a", subject: "b").body       == "a" }
    assert2 { AppLog.debug("a").body                     == "a" }
  end

  it "擬似絵文字は検索しやすくするために実際の絵文字に変換してDBに入る" do
    assert2 { AppLog.debug(emoji: ":SOS:").emoji == "🆘" }
  end

  describe "例外オブジェクトを渡せる" do
    it "それだけを渡すとsubjectやbodyに展開する" do
      app_log = AppLog.debug(Exception.new("foo"))
      assert2 { app_log.emoji == "🆘"                }
      assert2 { app_log.subject == "foo (Exception)" }
      assert2 { app_log.body == "foo"                }
    end

    it "展開しても明示的に指定したオプションの方を優先する" do
      app_log = AppLog.debug(Exception.new("foo"), subject: "(subject)")
      assert2 { app_log.subject == "(subject)" }
    end
  end

  it "プロセスIDを記録する" do
    assert2 { AppLog.debug.process_id }
  end

  describe "メール送信" do
    it "ログレベルが高いとメール送信する" do
      AppLog.alert
      assert2 { ActionMailer::Base.deliveries.count == 1 }
    end

    it "ログレベルが引くくてもmail_notifyオプションをつけるとメール送信する" do
      AppLog.debug
      assert2 { ActionMailer::Base.deliveries.count == 0 }
      AppLog.debug(mail_notify: true)
      assert2 { ActionMailer::Base.deliveries.count == 1 }
    end

    it "送信先を変更したり添付ファイルを付与できる" do
      AppLog.alert(to: "xxx@xxx", attachments: {"a" => "b"})
      mail = ActionMailer::Base.deliveries.last
      assert2 { mail.to == ["xxx@xxx"] }
      assert2 { mail.attachments["a"] }
    end
  end

  describe "Slack送信" do
    it "ログレベルが高いとSlack送信する" do
      AppLog.alert
      assert2 { SlackSender.deliveries.count == 1 }
    end

    it "ログレベルが引くくてもslack_notifyオプションをつけるとSlack送信する" do
      AppLog.debug
      assert2 { SlackSender.deliveries.count == 0 }
      AppLog.debug(slack_notify: true)
      assert2 { SlackSender.deliveries.count == 1 }
    end
  end
end
