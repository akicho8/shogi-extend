{
  ja: {
    attributes: {},
    helpers: {
      submit: {
        battle: {
          # create: "変換",
          # update: nil,
        },
      },
    },
    activemodel: {
      models: {
        "swars/crawler/main_active_user_crawler" => "活動的なプレイヤー",
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
          key:               "対局ユニークキー",
          battled_at:        "対局日時",
          rule_key:          "ルール",
          csa_seq:           "棋譜",
          final_key:         "結末",
          win_user_id:       "勝者",
          turn_max:          "手数",
          meta_info:         "メタ情報",
          accessed_at:        "最終アクセス日時",
          preset_key:        "手合割",
        },
        "swars/membership": {
          battle_id:    "対局共通情報",
          user_id:      "ユーザー",
          grade_id:     "棋力",
          judge_key:    "結果",
          location_key: "先手or後手",
        },
      },
    },
  },
}
