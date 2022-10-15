require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "bodyパラメータ" do
    visit_app(body: DotSfen.escape("position startpos"))
    assert_honpu_link_exist
  end

  it "xbodyパラメータ" do
    visit_app(xbody: DotSfen.urlsafe_escape("position startpos"))
    assert_honpu_link_exist
  end

  it "合言葉がある場合は登録しない" do
    visit_app(body: "position startpos", room_code: "test_room")
    assert_no_selector("a", text: "本譜", exact_text: true)
  end
end
