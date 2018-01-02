{
  ja: {
    attributes: {
      mountain_url: "将棋山脈URL",
    },
    helpers: {
      submit: {
        free_battle_record: {
          create: "変換",
          update: nil,
        },
      },
    },
    activerecord: {
      models: {
        free_battle_record: "棋譜変換",
      },
      attributes: {
        free_battle_record: {
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
