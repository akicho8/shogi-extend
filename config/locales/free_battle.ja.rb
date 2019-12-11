{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        free_battle: {
          create: "保存",
          update: nil,
        },
      },
    },
    activerecord: {
      models: {
        free_battle: "棋譜投稿",
      },
      attributes: {
        free_battle: {
          colosseum_user: "所有者",
          # | battled_at        | Battled at         | datetime     | NOT NULL    |                                   | C     |
          # | saturn_key        | Saturn key         | string(255)  | NOT NULL    |                                   | F     |
          # | sfen_body         | Sfen body          | string(8192) |             |                                   |       |
        },
      },
    },
  },
}
