require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "飛vs角を1vs1" do
    window_a do
      visit_app(user_name: :alice, xmatch_auth_key: "handle_name_required")
    end
    window_b do
      visit_app(user_name: :bob, xmatch_auth_key: "handle_name_required")
    end
    window_a do
      sidebar_open
      menu_item_click("自動マッチング")                # モーダルを開く
    end
    window_b do
      sidebar_open
      menu_item_click("自動マッチング")                # モーダルを開く
    end
    window_a do
      find(".rule_1vs1_05_00_00_5_pRvsB").click         # 飛vs角を選択
    end
    window_b do
      find(".rule_1vs1_05_00_00_5_pRvsB").click         # 飛vs角を選択 (ここでマッチング成立)
    end

    # 開発環境では performed_at で並び換えているので必ず alice, bob の順になる
    # app/models/xmatch_rule_info.rb
    window_a do
      xmatch_modal_close
      assert_viewpoint(:black)                         # alice, bob の順で alice は先手なので▲の向きになっている
      assert_member_status(:alice, :is_turn_active)   # 1人目(alice)に丸がついている
      assert_member_status(:bob, :is_turn_standby)    # 2人目(bob)は待機中
    end
    window_b do
      xmatch_modal_close
      assert_viewpoint(:white)                         # alice, bob の順で bob は後手なので△の向きになっている
      assert_member_status(:alice, :is_turn_active)   # 1人目(alice)に丸がついている
      assert_member_status(:bob, :is_turn_standby)    # 2人目(bob)は待機中
    end
  end

  it "自分vs自分 平手" do
    window_a do
      visit_app(user_name: :alice, xmatch_auth_key: "handle_name_required")

      sidebar_open
      menu_item_click("自動マッチング")          # モーダルを開く
      find(".rule_self_05_00_00_5").click         # 自分vs自分
      xmatch_modal_close

      assert_viewpoint(:black)                         # 平手の初手なので▲視点
      assert_member_status(:alice, :is_turn_active) # 1人目(alice)に丸がついている
    end
  end

  it "時間切れ" do
    @xmatch_wait_max = 2
    window_a do
      visit_app(user_name: :alice, xmatch_wait_max: @xmatch_wait_max, xmatch_auth_key: "handle_name_required")

      sidebar_open
      menu_item_click("自動マッチング")          # モーダルを開く
      find(".rule_1vs1_05_00_00_5_pRvsB").click   # 飛vs角を選択

      sleep(@xmatch_wait_max)
      xmatch_modal_close

      assert_text("時間内に集まらなかった")
    end
  end

  it "ログイン必須モード" do
    window_a do
      logout                                                 # ログアウト状態にする
      visit_app(xmatch_auth_key: "login_required")           # 来る
      xmatch_select_1vs1                                     # 1vs1のルールを選択
      assert_selector(".NuxtLoginContainer")                 # 「ログインしてください」が発動
    end
  end

  it "ハンドルネーム必須モード" do
    window_a do
      logout                                                 # ログアウト状態にする
      visit_app(xmatch_auth_key: "handle_name_required")     # 来る
      xmatch_select_1vs1                                     # 1vs1のルールを選択
      assert_selector(".HandleNameModal")                    # ハンドルネームを入力するように言われる
      find(".HandleNameModal input").set(:alice)            # 入力して
      find(".save_handle").click                             # 保存 (success_callback で 1vs1 を選択している)
      assert_selector(".is_entry_active")                    # エントリーできた
    end
  end
end
