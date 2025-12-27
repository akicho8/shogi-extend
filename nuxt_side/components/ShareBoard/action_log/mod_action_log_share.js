import { GX } from "@/components/models/gx.js"

export const mod_action_log_share = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// 共有版

    al_share_puts(label) {
      this.al_share({
        label: label,
        message: `${label}しました`,
        sfen: this.current_sfen, // 発動する側の棋譜を持っている
        turn: this.current_turn,
      })
    },

    al_share(params) {
      if (params.single_mode_support) {
        if (this.ac_room == null) {
          this.al_share_broadcasted({
            ...this.ac_room_perform_default_params(),
            ...params,
          })
          return
        }
      }
      this.ac_room_perform("al_share", params) // --> app/channels/share_board/room_channel.rb
    },
    async al_share_broadcasted(params) {
      this.al_add(params)
      this.ac_log({subject: "履歴追加", body: `「${params.label}」を受信`})
      {
        const toast_options = {
          type: params.label_type ?? "is-primary",
        }
        if (params.message) {
          await this.toast_primary(`${this.user_call_name(params.from_user_name)}が${params.message}`, toast_options)
        }
        if (params.full_message) {
          for (const e of GX.ary_wrap(params.full_message)) {
            await this.toast_primary(e, toast_options)
          }
        }
      }
    },
  },
}
