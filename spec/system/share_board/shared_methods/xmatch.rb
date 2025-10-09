module SharedMethods
  # なんでもいいから1vs1のルールを選択する
  def xmatch_select_1vs1
    global_menu_open
    menu_item_click("自動マッチング")           # モーダルを開く
    find(".rule_1vs1_05_00_00_5_pRvsB").click   # 飛vs角を選択
  end

  def xmatch_modal_close
    find(".XmatchModal .close_handle").click
  end
end
