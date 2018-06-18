{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        "general/battle": {
          # create: "変換",
          # update: nil,
        },
      },
    },
    activerecord: {
      models: {
        battle: "対局情報",
        user:   "対局者",
        membership:   "対局時の両者",
      },
      attributes: {
        "general/battle": {
          battle_key:               "対局キー",
          battled_at:               "対局日",
          kifu_body:                "棋譜内容",
          battle_state_key: "結果",
          key:               "ユニークなハッシュ",
          turn_max:                 "手数",
          meta_info:                "棋譜ヘッダー",
        },
      },
    },
  },
}
