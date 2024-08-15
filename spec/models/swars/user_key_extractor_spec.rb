require "rails_helper"

RSpec.describe Swars::UserKeyExtractor do
  it "空文字列の場合" do
    assert { QueryInfo.swars_user_key("") == nil }
  end
  it "一つの単語の場合" do
    assert { QueryInfo.swars_user_key("alice") == Swars::UserKey["alice"] }
  end
  it "二つの単語の場合" do
    assert { QueryInfo.swars_user_key("alice bob") == Swars::UserKey["alice"] }
  end
  it "対局URLの場合" do
    assert { QueryInfo.swars_user_key("https://shogiwars.heroz.jp/games/alice-bob-20200204_211329") == Swars::UserKey["alice"] }
  end
  it "ユーザーURLの場合" do
    assert { QueryInfo.swars_user_key("https://shogiwars.heroz.jp/users/alice") == Swars::UserKey["alice"] }
  end
  it "対局履歴URLの場合" do
    assert { QueryInfo.swars_user_key("https://shogiwars.heroz.jp/users/history/alice?gtype=&locale=ja") == Swars::UserKey["alice"] }
  end
  it "実際に想定される汚いURLの場合" do
    assert { QueryInfo.swars_user_key("将棋ウォーズ棋譜(alice:5級 vs bob:2級) #shogiwars #棋神解析 https://shogiwars.heroz.jp/games/alice-bob-20200927_180900?tw=1") == Swars::UserKey["alice"] }
  end
end
