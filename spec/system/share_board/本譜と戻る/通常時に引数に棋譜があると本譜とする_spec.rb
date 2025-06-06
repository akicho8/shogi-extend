require "#{__dir__}/helper"

RSpec.describe type: :system, share_board_spec: true do
  it "body" do
    visit_app(body: "position startpos")
    assert_honpu_open_on
  end

  it "ただし合言葉がある場合は登録しない" do
    visit_app(body: "position startpos", room_key: "test_room")
    assert_no_selector("a", text: "本譜", exact_text: true)
  end

  it "xbody" do
    visit_app(xbody: SafeSfen.encode("position startpos"))
    assert_honpu_open_on
  end
end
