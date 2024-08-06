class QuickScript::Swars::BattleDownloadScript
  class FormatInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "kif",  el_message: "多くのソフトが対応している一般的な形式 (推奨)", },
      { key: "ki2",  el_message: "人間向けで掲示板に貼るのに向いている",          },
      { key: "csa",  el_message: "コンピュータ将棋用",                            },
      { key: "sfen", el_message: "コンピュータ将棋用の1行表記",                   },
    ]

    def name
      return key.upcase
    end
  end
end
