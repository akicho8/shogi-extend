require "rails_helper"

RSpec.describe type: :system, swars_spec: true do
  include SwarsSystemSupport

  it do
    visit_to "/swars/search/custom", user_key: "DevUser1" # カスタム検索で DevUser1 が localStorage に入る
    visit_to "/swars/users/DevUser2"                      # プレイヤー情報は DevUser2 を見ている
    find(".SwarsUserShowDropdownMenu").click            # 右上「…」クリック
    find("span", text: "絞り込み").click
    # プレイヤー情報でカスタム検索を起動する
    # このとき何もしていないと DevUser1 が表示されてしまう
    # それを回避するため DevUser2 で DevUser1 を上書きする
    # なので DevUser2 が表示されているのが正しい
    find(".SwarsCustomSearchModal .user_key").assert_selector(:fillable_field, with: "DevUser2", disabled: true)
  end
end
