class QuickScript::Swars::BattleDownloadScript
  class EncodeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :"UTF-8",     el_message: "一般的な世界標準文字コード (ShogiHome 等)",      transform_method: :itself, },
      { key: :"Shift_JIS", el_message: "Windows 用の古いアプリ向け (激指・ShogiGUI 等)", transform_method: :tosjis, },
    ]
  end
end
