require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name            => user_name,
        :FIXED_MEMBER   => "a,b,c",
        :ng_word_check_p => false,
      })
  end

  it "works" do
    window_a { case1("a") }
    window_b { case1("b") }
    window_c { case1("c") }
    window_a do
      os_modal_open                                           # 「順番設定」モーダルを開く
      os_switch_toggle                                        # 有効スイッチをクリック
      find(:button, text: "お題ﾒｰｶｰ", exact_text: true).click # お題メーカー起動
      within(".quiz_subject") { find(:fillable_field).set("(quiz_subject)") } # 題名を記入
      within(".quiz_left")    { find(:fillable_field).set("(quiz_left)")   } # 選択肢1
      within(".quiz_right")   { find(:fillable_field).set("(quiz_right)")   } # 選択肢2
      find(:button, text: "出題する", exact_text: true).click
    end
    window_a do
      find(:button, text: "このチームに参加する", exact_text: true).click # 選択せずに決定した
      assert_text("選択してから投票しよう")
    end
    window_a do
      find(".item", text: "(quiz_right)").click
      find(:button, text: "このチームに参加する", exact_text: true).click
    end
    window_b do
      find(".item", text: "(quiz_right)").click
      find(:button, text: "このチームに参加する", exact_text: true).click
    end
    window_c do
      find(:button, text: "やめとく", exact_text: true).click
    end
    window_a do
      sidebar_open
      os_modal_open_handle
      find(:button, text: "結果を反映する(2/3)", exact_text: true).click # a b は投票したが c はまだなので 2/3 となっている
      assert_order_team_one "", "ab", sort: true # 順番に反映した。a も b も右側である "(quiz_right)" を選択したため偏っている
      assert_order_dnd_watcher "c"               # c は投票しなかったので観戦者になっている
    end
  end
end
