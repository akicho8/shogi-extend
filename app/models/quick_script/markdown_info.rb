module QuickScript
  class MarkdownInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :default,         title: "指定のドキュメント表示", description: "指定のドキュメントを表示する",                      },
      { key: :share_board,     title: "共有将棋盤の使い方",     description: "共有将棋盤の使い方を表示する",                      },
      { key: :swars_search,    title: "よくある質問",           description: "将棋ウォーズ棋譜検索のよくある質問(FAQ)を表示する", },
      { key: :video_new,       title: "動画作成の使い方",       description: "動画作成の使い方を表示する",                        },
      { key: "棋譜取得の予約", title: "棋譜取得の予約",         description: "「古い棋譜の補完」ページの上に表示する内容",        },
      { key: "棋譜ダウンロード", title: "棋譜ダウンロード",     description: "「棋譜ダウンロード」ページの上に表示する内容",      },
      { key: :credit,          title: "クレジット",             description: "クレジットを表示する",                              },
      { key: :privacy_policy,  title: "プライバシーポリシー",   description: "プライバシーポリシーを表示する",                    },
      { key: :terms,           title: "利用規約",               description: "利用規約を表示する",                                },
      { key: "横断棋譜検索",   title: "横断棋譜検索",           description: "「横断棋譜検索」ページの上に表示する内容",          },
    ]

    def markdown_text
      Pathname(__dir__).join("markdown_files/#{key}.md").read
    end

    def to_box_content
      { _component: "MarkdownContent", _v_bind: { body: markdown_text }, :class => "content box is-shadowless has-background-white-ter" }
    end
  end
end
