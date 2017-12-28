{
  ja: {
    attributes: {
      mountain_url: "将棋山脈URL",
    },
    helpers: {
      submit: {
        free_swars_battle_record: {
          create: "変換",
          update: nil,
        },
        converted_info: {
        },
      },
    },
    activerecord: {
      models: {
        free_swars_battle_record: "棋譜変換",
        converted_info: "各種棋譜ファイル内容",
      },
      attributes: {
        free_swars_battle_record: {
          unique_key: "ユニークなハッシュ",
          kifu_file: "棋譜ファイル",
          kifu_url: "棋譜URL",
          kifu_body: "棋譜内容",
          turn_max: "手数",
          meta_info: "棋譜ヘッダー",
        },
        converted_info: {
          text_body: "本体",
          text_format: "種類(kif/ki2/csa)",
        },
      },
    },
  },
}
