require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  # 検討中での反則確認
  def case1(body_key)
    visit_app({:body => SfenInfo.fetch(body_key).sfen})
  end

  it "二歩" do
    case1("反則確認用")
    stand_piece(:black, :P).click
    place_click("12")
    assert_var(:latest_illegal_name, "二歩")
  end

  it "打ち歩詰め" do
    case1("反則確認用")
    stand_piece(:black, :P).click
    place_click("22")
    assert_var(:latest_illegal_name, "打ち歩詰め")
  end

  it "駒ワープ" do
    case1("反則確認用")
    piece_move("19", "11")
    assert_var(:latest_illegal_name, "駒ワープ")
  end

  it "死に駒" do
    case1("反則確認用")
    stand_piece(:black, :N).click
    place_click("11")
    assert_var(:latest_illegal_name, "死に駒")
  end

  it "王手放置" do
    case1("最初から王手")
    piece_move("42", "31")
    assert_var(:latest_illegal_name, "王手放置")
  end

  it "王手解除せず" do
    case1("最初から王手")
    piece_move("14", "23")
    assert_var(:latest_illegal_name, "王手解除せず")
  end

  it "自殺手" do
    case1("反則確認用")
    piece_move("14", "24")
    assert_var(:latest_illegal_name, "自殺手")
  end

  it "ピン外し自殺手" do
    case1("反則確認用")
    piece_move("23", "22")
    assert_var(:latest_illegal_name, "ピン外し自殺手")
  end

  # これだけ例外的に指し終わってからでないと出せない
  it "連続王手の千日手" do
    case1("連続王手の千日手確認用")
    perpetual_check_trigger
    assert_action_text("連続王手の千日手") # 履歴には一応名前が出ている
    assert_var(:illegal_params, "")        # 通常の反則と扱いが異なるため入っていない
    lose_modal_none                        # 検討中なので負けモーダルは出ていない
  end
end
