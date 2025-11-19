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
# | created_at | 作成日時 | datetime    | NOT NULL    |      | A     |
# |------------+----------+-------------+-------------+------+-------|
#
# - Remarks ----------------------------------------------------------------------
# [Warning: Need to add index] create_app_logs マイグレーションに add_index :app_logs, :process_id を追加しよう
# [Warning: Need to add relation] AppLog モデルに belongs_to :process を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe AppLog, type: :model do
  before { AppLog.destroy_all }

  describe "DB保存" do
    describe "ログレベル" do
      it "デフォルトはinfoになっている" do
        assert { AppLog.call.level == "info" }
      end

      it "自分で渡す場合は基本的callを呼ぶ" do
        assert { AppLog.call(level: "debug").level == "debug" }
      end

      it "ログレベル指定のメソッドを呼んでいてもオプションの方が勝る" do
        assert { AppLog.alert(level: "debug").level == "debug" }
      end
    end

    it "ハッシュをそのまま渡すと警告がでる" do
      silence_stream(STDERR) do
        assert { AppLog.info({ subject: "a" }).subject == "" }
      end
    end

    it "DBに入れないオプションがある" do
      assert { AppLog.none? }
      assert { AppLog.debug(database: false) == nil }
      assert { AppLog.none? }
    end

    it "空でも作成できる" do
      assert { AppLog.debug }
    end

    it "記録できることを優先するので題名や本文が長すぎたらtruncateする" do
      assert { AppLog.debug(subject: "🍄" * 300).subject.size == 255 }
      assert { AppLog.debug(body: "🍄" * 70000).body.size == 16383 }
    end

    it "本文は第一引数に書ける" do
      assert { AppLog.debug(body: "a", subject: "b").body == "a" }
      assert { AppLog.debug("a", subject: "b").body       == "a" }
    end

    it "擬似絵文字は実際の絵文字に変換してDBに入る" do
      assert { AppLog.debug(emoji: ":SOS:").emoji == "🆘" }
    end

    it "プロセスIDを記録する" do
      assert { AppLog.debug.process_id }
    end
  end

  describe "メール送信" do
    it "ログレベルが高いとメール送信する" do
      AppLog.alert
      assert { ActionMailer::Base.deliveries.present? }
    end

    it "ログレベルが引くくてもmail_notifyオプションをつけるとメール送信する" do
      AppLog.debug
      assert { ActionMailer::Base.deliveries.blank? }
      AppLog.debug(mail_notify: true)
      assert { ActionMailer::Base.deliveries.present? }
    end

    it "ログレベルが高くてもオプションで禁止できる" do
      AppLog.alert(mail_notify: false)
      assert { ActionMailer::Base.deliveries.blank? }
    end

    it "送信先を変更したり添付ファイルを付与できる" do
      AppLog.alert(to: "xxx@xxx", attachments: { "a" => "b" })
      mail = ActionMailer::Base.deliveries.last
      assert { mail.to == ["xxx@xxx"] }
      assert { mail.attachments["a"] }
    end
  end

  describe "Slack送信" do
    before do
      SlackSender.deliveries.clear
    end

    after do
      SlackSender.deliveries.clear
    end

    it "ログレベルが高くてもオプションで禁止できる" do
      AppLog.alert(slack_notify: false)
      assert { SlackSender.deliveries.blank? }
    end

    it "ログレベルが引くくてもslack_notifyオプションをつけるとSlack送信する" do
      AppLog.debug
      assert { SlackSender.deliveries.blank? }
      AppLog.debug(slack_notify: true)
      assert { SlackSender.deliveries.present? }
    end
  end

  describe "例外オブジェクトを渡せる" do
    it "それだけを渡すとsubjectやbodyに展開する" do
      app_log = AppLog.debug(Exception.new("foo"))
      assert { app_log.emoji == "🆘"                }
      assert { app_log.subject == "Exception" }
      assert { app_log.body == "[MESSAGE]\nfoo" }
    end

    it "展開しても明示的に指定したオプションの方を優先する" do
      app_log = AppLog.debug(Exception.new("foo"), subject: "(subject)")
      assert { app_log.subject == "(subject)" }
    end

    it "dataオプションを渡せる" do
      app_log = AppLog.debug(Exception.new("foo"), data: "bar")
      assert { app_log.body.include?("bar") }
    end
  end
end
