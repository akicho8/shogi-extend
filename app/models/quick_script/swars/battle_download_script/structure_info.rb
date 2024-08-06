class QuickScript::Swars::BattleDownloadScript
  class StructureInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :flat,  name: "フラット", el_message: "「ID/ファイル」形式で格納する",            zip_path_format: nil,        },
      { key: :day,   name: "日毎",     el_message: "「ID/2020-01-01/ファイル」形式で格納する", zip_path_format: "%Y-%m-%d", },
      { key: :month, name: "月毎",     el_message: "「ID/2020-01/ファイル」形式で格納する",    zip_path_format: "%Y-%m",    },
    ]
  end
end
