import { GX } from "@/components/models/gx.js"

export const mod_origin_mark_action = {
  methods: {
    ev_action_origin_mark_jump_invoke(general_mark_pos_key, ev) {
      this.origin_mark_general_action("push", general_mark_pos_key)
    },

    ev_action_origin_mark_jump_cancel(general_mark_pos_key, ev) {
      this.origin_mark_general_action("remove", general_mark_pos_key)
    },

    //////////////////////////////////////////////////////////////////////////////// 共有

    origin_mark_general_action(method, general_mark_pos_key) {
      if (!this.origin_mark_feature_p) {
        return
      }
      const params = {
        __standalone_mode__: true,
        origin_mark_command: {
          method: method,
          params: this.general_mark_attributes_create(general_mark_pos_key),
        },
      }
      this.ac_room_perform("origin_mark_general_action", params) // --> app/channels/share_board/room_channel.rb
    },
    origin_mark_general_action_broadcasted(params) {
      if (!this.i_can_origin_mark_receive_p(params)) {
        return
      }
      this.sp_call(e => {
        if (e.mut_origin_mark_list.command_execute(params.origin_mark_command)) {
          if (this.received_from_self(params)) {
            // 自分の音はリアルタイムに鳴らしているため
          } else {
            this.origin_mark_se_call(params.origin_mark_command.method)
          }
        }
      })
    },

    // 効果音
    origin_mark_se_call(method) {
      if (this.play_mode_p) {
        let key = null
        if (method === "push") {
          key = "se_piece_jump_invoke"
        } else {
          key = "se_piece_jump_cancel"
        }
        this.debug_alert(key)
        this.sfx_play(key)
      }
    },
  },
}
