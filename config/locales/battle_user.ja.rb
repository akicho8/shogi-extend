{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        battle_user: {
          create: "変換",
          update: nil,
        },
      },
    },
    activerecord: {
      models: {
        battle_user: "棋譜変換",
      },
      attributes: {
        battle_user: {
          unique_key: "ユニークなハッシュ",
          kifu_file: "棋譜ファイル",
          kifu_url: "棋譜URL",
          kifu_body: "棋譜内容",
          converted_kif: "変換後KIF",
          converted_ki2: "変換後KI2",
          converted_csa: "変換後CSA",
          turn_max: "手数",
          kifu_header: "棋譜ヘッダー",
          remove_kifu_file: "アップロード済みファイルの削除",
        },
      },
    },
  },
}
