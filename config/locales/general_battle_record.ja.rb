{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        general_battle_record: {
          # create: "変換",
          # update: nil,
        },
      },
    },
    activerecord: {
      models: {
        general_battle_record: "対局情報",
        general_battle_user:   "対局者",
        general_battle_ship:   "対局時の両者",
      },
      attributes: {
        general_battle_record: {
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
