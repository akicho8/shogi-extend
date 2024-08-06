class QuickScript::Swars::BattleDownloadScript
  class EncodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "UTF-8",     el_message: "一般的な文字コード",                            },
      { key: "Shift_JIS", el_message: "Windows 用の古いアプリ向け (激指・ShogiGUI等)", },
    ]
  end
end
