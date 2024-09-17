class QuickScript::Swars::CrossSearchScript
  class BookmarkUrlInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :off, name: "しない", el_message: "通常通り実行する",                          },
      { key: :on,  name: "する",   el_message: "以上の設定で実行ボタンを押すURLを生成する", },
    ]
  end
end
