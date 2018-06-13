{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        general_battle: {
          # create: "変換",
          # update: nil,
        },
      },
    },
    activerecord: {
      models: {
        general_battle: "対局情報",
        general_user:   "対局者",
        general_membership:   "対局時の両者",
      },
      attributes: {
        general_battle: {
          battle_key:               "対局キー",
          battled_at:               "対局日",
          kifu_body:                "棋譜内容",
          general_battle_state_key: "結果",
          unique_key:               "ユニークなハッシュ",
          turn_max:                 "手数",
          meta_info:                "棋譜ヘッダー",
        },
      },
    },
  },
}
