require "rails_helper"

RSpec.describe Swars::UserKeyExtractor do
  it "空文字列の場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("") == nil }
  end
  it "一つの単語の場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("alice") == "alice" }
  end
  it "二つの単語の場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("alice bob") == "alice" }
  end
  it "対局URLの場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("https://shogiwars.heroz.jp/games/alice-bob-20200204_211329") == "alice" }
  end
  it "ユーザーURLの場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("https://shogiwars.heroz.jp/users/alice") == "alice" }
  end
  it "対局履歴URLの場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("https://shogiwars.heroz.jp/users/history/alice?gtype=&locale=ja") == "alice" }
  end
  it "実際に想定される汚いURLの場合" do
    is_asserted_by { QueryInfo.swars_user_key_extract("将棋ウォーズ棋譜(alice:5級 vs bob:2級) #shogiwars #棋神解析 https://shogiwars.heroz.jp/games/alice-bob-20200927_180900?tw=1") == "alice" }
  end
end
