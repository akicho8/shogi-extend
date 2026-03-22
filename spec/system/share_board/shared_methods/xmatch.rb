module SharedMethods
  # なんでもいいから1vs1のルールを選択する
  def xmatch_select_1vs1
    sidebar_open
    find(".xmatch_modal_open_handle").click          # モーダルを開く
    find(".rule_1vs1_05_00_00_5_pRvsB").click   # 飛vs角を選択
  end

  def xmatch_modal_close
    find(".xmatch_modal_close_handle").click
  end
end
