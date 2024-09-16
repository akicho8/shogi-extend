class QuickScript::Swars::CrossSearchScript
  class BookmarkUrlInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :off, name: "OFF", el_message: "",                                                      },
      { key: :on,  name: "ON",  el_message: "以上の設定で実行ボタンを押したと仮定するURLを生成する", },
    ]
  end
end
