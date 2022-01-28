export const app_room_leave = {
  methods: {
    room_entry_call(params) {
      this.al_add({...params, label: "入室"})
      this.sound_play("room_entry")
      this.delay_block(0.75, () => this.toast_ok(`${this.user_call_name(params.from_user_name)}が入室しました`))
    },

    room_leave_call(params) {
      this.al_add({...params, label: "退室"})
      this.sound_play("room_leave")
      this.delay_block(0.25, () => this.toast_ok(`${this.user_call_name(params.from_user_name)}が退室しました`))
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_leave() {
      this.room_leave_call(this.ac_room_perform_default_params())  // (実行後に切断するので)自分には届かないため自分側だけで実行しておく
      this.ac_room_perform("room_leave", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    room_leave_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
        // room_leave を呼んだ直後に接続を切っているのでここには来ない
      } else {
        this.room_leave_call(params)
      }
      this.member_reject(params)
    },
  },
}
