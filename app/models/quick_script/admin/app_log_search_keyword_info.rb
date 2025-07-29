module QuickScript
  module Admin
    class AppLogSearchKeywordInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: "共有将棋盤",              },
        { key: "チャット",                },
        { key: "返答記録",                },
        { key: "オーダー配布",            },
        { key: "cc_behavior_start",       },
        { key: "cc_behavior_silent_stop", },
        { key: "短縮URL",                 },
        { key: "棋譜取得予約",            },
        { key: "KENTO API",               },
        { key: "ぴよ将棋",                },
        { key: "短縮URL作成",             },
        { key: "短縮URLリダイレクト",     },
        { key: "ウォーズID不明",          },
        { key: "囚人",                    },
        { key: "棋譜コピー",              },
        { key: "ぴよ将棋起動",            },
        { key: "KENTO起動",               },
        { key: "SNS経由登録",             },
        { key: "ユーザー新規登録",        },
      ]
    end
  end
end
