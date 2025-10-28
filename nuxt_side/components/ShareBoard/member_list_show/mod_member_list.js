export const mod_member_list = {
  methods: {
    order_lookup(e) {
      return this.order_lookup_from_name(e.from_user_name)
    },

    // SbMemberList の1行のクラスに使っている
    member_info_class(e) {
      return {
        is_standby:                this.member_is_standby(e),                // 初期状態(順番設定をしていない)
        is_disconnect:            this.member_is_disconnect(e),            // 霊圧が消えかけ
        is_battle_current_player: this.member_is_battle_current_player(e), // 手番の人
        is_battle_other_player:   this.member_is_battle_other_player(e),   // 手番待ちの人
        is_battle_watcher:        this.member_is_battle_watcher(e),        // 観戦
        is_self:                  this.member_is_self(e),                  // 自分
        is_look_away:             this.member_is_look_away(e),             // よそ見中
      }
    },
    member_is_standby(e)                { return !this.order_enable_p                                                     }, // 初期状態(順番設定をしていない)
    member_is_battle_current_player(e) { return this.order_lookup(e) && this.current_turn_user_name === e.from_user_name }, // 手番の人
    member_is_battle_other_player(e)   { return this.order_lookup(e) && this.current_turn_user_name !== e.from_user_name }, // 手番待ちの人
    member_is_battle_watcher(e)        { return this.order_enable_p && !this.order_lookup(e)                             }, // 観戦
    member_is_self(e)                  { return this.connection_id === e.from_connection_id                              }, // 自分

    // Windowが非アクティブ状態か？
    member_is_look_away(e)  {
      return this.MEMBER_IS_LOOK_AWAY || !e.window_active_p
    },

    member_status_label(e) {
      if (this.member_is_battle_current_player(e)) {
        return "手番"
      }
      if (this.member_is_battle_other_player(e)) {
        return "手番待ち"
      }
      if (this.member_is_battle_watcher(e)) {
        return "観戦中"
      }
      return "不明"
    },
  },
  computed: {
    MEMBER_IS_LOOK_AWAY() { return this.param_to_b("MEMBER_IS_LOOK_AWAY") },
  },
}
