require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :room_key            => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a,b,c",
        :handle_name_validate => "false",
      })
  end

  it "works" do
    a_block { case1("a") }
    b_block { case1("b") }
    c_block { case1("c") }
    a_block do
      os_modal_open                                           # 「順番設定」モーダルを開く
      os_switch_toggle                                        # 有効スイッチをクリック
      find(:button, text: "お題ﾒｰｶｰ", exact_text: true).click # お題メーカー起動
      within(".odai_subject") { find(:fillable_field).set("(odai_subject)") } # 題名を記入
      within(".odai_left")    { find(:fillable_field).set("(team_black)")   } # 選択肢1
      within(".odai_right")   { find(:fillable_field).set("(team_white)")   } # 選択肢2
      find(:button, text: "出題する", exact_text: true).click
    end
    a_block do
      find(:button, text: "このチームに参加する", exact_text: true).click # 選択せずに決定した
      assert_text("選択してから投票してください")
    end
    a_block do
      find(".item", text: "(team_white)").click
      find(:button, text: "このチームに参加する", exact_text: true).click
    end
    b_block do
      find(".item", text: "(team_white)").click
      find(:button, text: "このチームに参加する", exact_text: true).click
    end
    c_block do
      find(:button, text: "やめとく", exact_text: true).click
    end
    a_block do
      global_menu_open
      os_modal_open_handle
      find(:button, text: "結果を反映する(2/3)", exact_text: true).click # a b は投票したが c はまだなので 2/3 となっている
      assert_order_team_one "", "ab", sort: true # 順番に反映した。a も b も右側である "(team_white)" を選択したため偏っている
      assert_order_dnd_watcher "c"               # c は投票しなかったので観戦者になっている
    end
  end
end
