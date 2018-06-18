{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        battle: {
          # create: "変換",
          # update: nil,
        },
      },
    },
    activerecord: {
      models: {
        "swars/battle": "将棋ウォーズ対戦情報",
        "swars/user": "将棋ウォーズユーザー",
        "swars/membership": "対局と対局者の対応",
      },
      attributes: {
        "swars/battle": {
          key: "ユニークなハッシュ",
          kifu_file: "棋譜ファイル",
          kifu_url: "棋譜URL",
          kifu_body: "棋譜内容",
          converted_kif: "変換後KIF",
          converted_ki2: "変換後KI2",
          converted_csa: "変換後CSA",
          turn_max: "手数",
          meta_info: "棋譜ヘッダー",
          remove_kifu_file: "アップロード済みファイルの削除",
        },
      },
    },
  },
}
