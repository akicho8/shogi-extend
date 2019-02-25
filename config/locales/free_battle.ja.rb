{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        free_battle: {
          create: "固定URL化",
          update: nil,
        },
      },
    },
    activerecord: {
      models: {
        free_battle: "棋譜入力",
      },
      attributes: {
        free_battle: {
          key: "ユニークなハッシュ",
          kifu_file: "棋譜ファイル",
          kifu_url: "棋譜URL",
          kifu_body: "棋譜",
          title: "タイトル",
          turn_max: "手数",
          meta_info: "棋譜ヘッダー",
        },
      },
    },
  },
}
