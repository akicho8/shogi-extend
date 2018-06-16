{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        free_battle: {
          create: "変換",
          update: nil,
        },
      },
    },
    activerecord: {
      models: {
        free_battle: "棋譜変換",
      },
      attributes: {
        free_battle: {
          unique_key: "ユニークなハッシュ",
          kifu_file: "棋譜ファイル",
          kifu_url: "棋譜URL",
          kifu_body: "棋譜内容",
          turn_max: "手数",
          meta_info: "棋譜ヘッダー",
        },
      },
    },
  },
}
