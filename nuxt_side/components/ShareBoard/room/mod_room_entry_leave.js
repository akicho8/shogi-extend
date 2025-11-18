import { GX } from "@/components/models/gx.js"

export const mod_room_entry_leave = {
  methods: {
    // 入室時の通知
    async room_entry_call(params) {
      this.tl_add("入室直前の人数", `${this.member_infos.length}人`, params)
      this.al_add({...params, label: "入室"})
      await this.sfx_play("se_room_entry")
      await this.toast_ok(`${this.user_call_name(params.from_user_name)}が入室しました`)

      if (this.room_url_copy_modal_p) {
        await GX.sleep(this.room_url_copy_modal_delay)
        if (this.received_from_self(params)) {
          if (!this.url_room_key_exist_p) {      // 「入退室」から入室 (部屋のリンクから来ていない場合)
            if (this.member_infos.length <= 1) { // 自分だけなら
              this.room_url_copy_modal_handle()
            }
          }
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_leave_share() {
      // this.room_leave_call(this.ac_room_perform_default_params())  // (実行後に切断するので)自分には届かないため自分側だけで実行しておく
      this.ac_room_perform("room_leave_share", {}) // --> app/channels/share_board/room_channel.rb
    },
    room_leave_share_broadcasted(params) {
      if (this.received_from_self(params)) {
        // 自分から自分へ
        // room_leave_share を呼んだ直後に接続を切っているのでここには来ないのだが切断が遅すぎると呼ばれる可能性もあるため
        return
      }
      this.al_add({...params, label: "退室"})
      this.toast_ok(`${this.user_call_name(params.from_user_name)}が退室しました`)
      this.member_reject(params)
    },
  },
}
