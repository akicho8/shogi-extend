require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name => user_name,
        :FIXED_ORDER => "a,b",
        :title => "(title)",
      })
  end

  it "部屋を立てていないときはURLから取得する" do
    visit_app(title: "(title)", black: "(a)")
    sidebar_open
    switch_to_window_by { find(".kifu_show_url.kif_utf8").click }
    assert_text "棋戦：(title)"
    assert_text "先手：(a)"
  end

  it "部屋を立てた後はメンバーリストから取得する" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_c { case1(:c) }
    window_a do
      sidebar_open
      switch_to_window_by { find(".kifu_show_url.kif_utf8").click }
      assert_text "棋戦：(title)"
      assert_text "先手：a"
      assert_text "後手：b"
      assert_text "観戦：c"
    end
  end

  it "操作履歴にも含んでいる" do
    visit_app(black: :a)
    piece_move_o("77", "76", "☗7六歩")
    history_items_at(0).click
    Capybara.within(".TimeMachineModal") do
      assert_text(%("black": "a")) # モーダル内のでデバッグプリントを見ている
    end
  end

  it "部屋に abcdef がいる順番が bdac のとき順番通り先手 ba 後手 dc の順の表記になり観戦は部屋にいる順になる" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b,c,d,e,f",
        :FIXED_ORDER => "b,d,a,c",
        :title => "(title)",
      })
    sidebar_open
    switch_to_window_by { find(".kifu_show_url.kif_utf8").click }
    assert_text "棋戦：(title)"
    assert_text "先手：b, a"
    assert_text "後手：d, c"
    assert_text "観戦：e, f"
  end
end
