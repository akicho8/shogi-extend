export const app_room_leave = {
  methods: {
    room_entry_call(name) {
      this.sound_play("door_open")
      this.delay_block(0.5, () => this.toast_ok(`${this.user_call_name(name)}が入室しました`))
    },

    room_leave_call(name) {
      this.sound_play("door_close")
      this.delay_block(0.25, () => this.toast_ok(`${this.user_call_name(name)}が退室しました`))
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_leave() {
      this.room_leave_call(this.user_name)
      this.ac_room_perform("room_leave", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    room_leave_broadcasted(params) {
      if (params.from_connection_id === this.connection_id) {
        // 自分から自分へ
        // room_leave を呼んだ直後に接続を切っているのでここには来ない
      } else {
        this.room_leave_call(params.from_user_name)
      }
      this.member_reject(params)
    },
  },
}
