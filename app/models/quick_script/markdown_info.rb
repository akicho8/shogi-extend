module QuickScript
  class MarkdownInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :default,      title: "ドキュメント表示",                         },
      { key: :share_board,  title: "共有将棋盤の使い方",                       },
      { key: :swars_search, title: "将棋ウォーズ棋譜検索のよくある質問 (FAQ)", },
      { key: :video_new,    title: "動作作成の使い方",                         },
    ]

    def markdown_text
      Pathname(__dir__).join("markdown_files/#{key}.md").read
    end
  end
end
