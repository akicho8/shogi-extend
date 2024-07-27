module QuickScript
  class MarkdownInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :default,      title: "ドキュメント表示",    description: "ドキュメントを表示する",                            },
      { key: :share_board,  title: "共有将棋盤の使い方",  description: "共有将棋盤の使い方を表示する",                      },
      { key: :swars_search, title: "よくある質問",        description: "将棋ウォーズ棋譜検索のよくある質問(FAQ)を表示する", },
      { key: :video_new,    title: "動画作成の使い方",    description: "動画作成の使い方を表示する",                        },
    ]

    def markdown_text
      Pathname(__dir__).join("markdown_files/#{key}.md").read
    end
  end
end
