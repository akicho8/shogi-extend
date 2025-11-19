require "rails_helper"

RSpec.describe Swars::UserKeySuggestion, type: :model, swars_spec: true do
  it "戦法名の場合" do
    assert { Swars::UserKeySuggestion.message_for("嬉野流") == "嬉野流に該当する戦法は見つかりません" }
  end

  it "手合割の場合" do
    assert { Swars::UserKeySuggestion.message_for("二枚落ち") == "二枚落ちに該当する手合割は見つかりません" }
  end

  it "めちゃくちゃな入力" do
    assert { Swars::UserKeySuggestion.message_for("あ" * 50) == "めちゃくちゃな入力はやめよう" }
  end

  it "メールアドレスの入力" do
    assert { Swars::UserKeySuggestion.message_for("alice.bob@gmail.com") == "それはウォーズIDではなくメールアドレスです" }
  end

  it "ひらがな、カタカナ、漢字の場合" do
    assert { Swars::UserKeySuggestion.message_for("ありす") == "ウォーズIDはアルファベットや数字です" }
    assert { Swars::UserKeySuggestion.message_for("アリス") == "ウォーズIDはアルファベットや数字です" }
    assert { Swars::UserKeySuggestion.message_for("漢漢漢") == "ウォーズIDはアルファベットや数字です" }
  end

  it "全角で入力した場合" do
    assert { Swars::UserKeySuggestion.message_for("ａｌｉｃｅ") == "ウォーズIDは半角で入力しよう" }
  end

  it "アルファベットと数字だけ半角だけど記号が全角" do
    assert { Swars::UserKeySuggestion.message_for("alice＿bob") == "＿ の部分も半角で入力しよう" }
  end

  describe "アルファベットを含む半角で入力しているが長さが範囲外" do
    it "短かすぎる" do
      assert { Swars::UserKeySuggestion.message_for("ab") == "ウォーズIDは3文字以上です" }
    end
    it "長すぎる" do
      assert { Swars::UserKeySuggestion.message_for("1234567890abcdef") == "真面目に入力しよう" }
    end
  end

  describe "アルファベットを含む半角を3文字以上入力したのでサジェクションが発動する" do
    it "大文字小文字を無視すると一致する場合" do
      Swars::User.create!(user_key: "alice")
      assert { Swars::UserKeySuggestion.message_for("ALICE") == "もしかして alice ですか？ 大文字と小文字を区別して入力しよう" }
    end

    it "複数人マッチした場合" do
      Swars::User.create!(user_key: "alice1", search_logs_count: 1)
      Swars::User.create!(user_key: "alice2", search_logs_count: 2)
      assert { Swars::UserKeySuggestion.message_for("alice") == "alice に似た人は2人います。もしかして alice2 ですか？" }
    end

    it "マッチしない" do
      assert { Swars::UserKeySuggestion.message_for("alice") == "alice に似た人はいません。正確に入力しよう" }
    end

    it "部分一致とする" do
      Swars::User.create!(user_key: "alice")
      assert { Swars::UserKeySuggestion.message_for("lic") == "lic に似た人は1人います。もしかして alice ですか？" }
    end

    it "数字だけ" do
      assert { Swars::UserKeySuggestion.message_for("123") == "123 に似た人はいません。正確に入力しよう" }
    end

    it "マッチする人数が多い" do
      10.times { |i| Swars::User.create!(user_key: "alice#{i}", search_logs_count: i) }
      assert { Swars::UserKeySuggestion.message_for("alice") == "alice に似た人は10人もいます。もしかして alice9 ですか？" }
    end
  end

  describe "記号を入力した場合" do
    it do
      assert { Swars::UserKeySuggestion.message_for(".") == "真面目に入力しよう" }
    end
  end
end
