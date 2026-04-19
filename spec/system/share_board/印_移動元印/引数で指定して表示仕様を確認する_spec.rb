require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(params = {})
    visit_app(params)
  end

  it "1つの場合は名前は出ない" do
    case1(origin_mark_collection_str: "5_9,a,0")
    assert_selector(".place_5_9 .OriginMarkLayer .general_mark_effect_container")
    assert_no_selector(".place_5_9 .OriginMarkLayer .general_mark_user_name", text: "a", exact_text: true)
  end

  it "2つ以上の場合は名前が出る" do
    case1(origin_mark_collection_str: "5_9,a,0,5_1,b,1")
    assert_selector(".place_5_9 .OriginMarkLayer .general_mark_effect_container")
    assert_selector(".place_5_9 .OriginMarkLayer .general_mark_user_name", text: "a", exact_text: true)
    assert_selector(".place_5_1 .OriginMarkLayer .general_mark_effect_container")
    assert_selector(".place_5_1 .OriginMarkLayer .general_mark_user_name", text: "b", exact_text: true)
  end

  it "名前が空なら印だけでる" do
    case1(origin_mark_collection_str: "5_9,,0,5_1,,1")
    assert_selector(".place_5_9 .OriginMarkLayer .general_mark_effect_container")
    assert_no_selector(".place_5_9 .OriginMarkLayer .general_mark_user_name", text: "a", exact_text: true)
    assert_selector(".place_5_1 .OriginMarkLayer .general_mark_effect_container")
    assert_no_selector(".place_5_1 .OriginMarkLayer .general_mark_user_name", text: "b", exact_text: true)
  end
end
