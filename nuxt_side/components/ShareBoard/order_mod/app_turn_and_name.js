// turn と user_name の相互変換
//
// |------------------------------------------+----------------------------+-----------------------------------|
// | Method                                   | Description                |                                   |
// |------------------------------------------+----------------------------+-----------------------------------|
// | turn_to_user_object(turn)                | 手数 → ユーザー情報       |                                   |
// | turn_to_user_name(turn)                  | 手数 → ユーザー名         |                                   |
// | user_name_to_initial_turn(user_name)     | 名前 → 手数               | 平手・駒落ちに関係なく最初の人は0 |
// | user_name_to_initial_location(user_name) | 名前 → Location           | 駒落ちで最初の人は白              |
// | user_name_to_display_turns(user_name)    | 名前 → 表示用の番号文字列 | "(1, 3)"                          |
// |------------------------------------------+----------------------------+-----------------------------------|
//
// FIXME: ユーザー名を引数に取りメソッドが多いということはユーザー名の Value Object にするべきか？
//
export const app_turn_and_name = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 手数からユーザー情報を取得する
    turn_to_user_object(turn) {
      if (this.order_enable_p) {
        return this.order_unit.turn_to_user_object(turn, this.tegoto, this.start_color)
      }
    },

    // 手数からユーザー名を取得する
    turn_to_user_name(turn) {
      const e = this.turn_to_user_object(turn)
      if (e) {
        return e.user_name
      }
    },

    // 指定の名前の人の最初の順序
    // 優先度をつける順番であって location ではないので注意
    user_name_to_initial_turn(user_name) {
      if (this.order_enable_p) {
        const turns = this.name_to_turns_hash[user_name]
        if (turns) {
          return turns[0]
        }
      }
    },

    // 名前から最初の色を求める
    user_name_to_initial_location(user_name) {
      if (this.order_enable_p) {
        const turn = this.user_name_to_initial_turn(user_name)
        return this.turn_to_location(turn)
      }
    },

    // 名前から表示用の手番の番号を求める
    user_name_to_display_turns(user_name) {
      const turns = this.name_to_turns_hash[user_name]
      if (turns) {
        return "(" + turns.map(e => e + 1).join(",") + ")"
      }
    },
  },
}
