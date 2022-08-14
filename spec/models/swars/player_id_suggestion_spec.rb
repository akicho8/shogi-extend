require "rails_helper"

module Swars
  RSpec.describe PlayerIdSuggestion, type: :model, swars_spec: true do
    describe "全角で入力した場合" do
      it do
        assert { PlayerIdSuggestion.new("ありす").message == "ウォーズIDは半角で入力してください" }
      end
    end

    describe "アルファベットを含む半角で入力しているが長さが範囲外" do
      it "短かすぎる" do
        assert { PlayerIdSuggestion.new("ab").message == "ウォーズIDは3文字以上です" }
      end
      it "長すぎる" do
        assert { PlayerIdSuggestion.new("1234567890abcdef").message == "真面目に入力してください" }
      end
    end

    describe "アルファベットを含む半角を3文字以上入力したのでサジェクションが発動する" do
      it "大文字小文字を無視すると一致する場合" do
        User.create!(user_key: "alice")
        assert { PlayerIdSuggestion.new("ALICE").message == "もしかして alice ですか？ 大文字と小文字を区別して入力してください" }
      end

      it "複数人マッチした場合" do
        User.create!(user_key: "alice1", search_logs_count: 1)
        User.create!(user_key: "alice2", search_logs_count: 2)
        assert { PlayerIdSuggestion.new("alice").message == "alice に似た人は2人います。もしかして alice2 ですか？" }
      end

      it "マッチしない" do
        assert { PlayerIdSuggestion.new("alice").message == "alice に似た人はいません。正確に入力してください" }
      end

      it "部分一致とする" do
        User.create!(user_key: "alice")
        assert { PlayerIdSuggestion.new("lic").message == "lic に似た人は1人います。もしかして alice ですか？" }
      end

      it "数字だけ" do
        assert { PlayerIdSuggestion.new("123").message == "123 に似た人はいません。正確に入力してください" }
      end
    end

    describe "記号を入力した場合" do
      it do
        assert { PlayerIdSuggestion.new(".").message == "真面目に入力してください" }
      end
    end
  end
end
