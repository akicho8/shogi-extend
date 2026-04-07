import { GX } from "@/components/models/gx.js"

export const mod_origin_mark_group_reject_action = {
  methods: {
    origin_mark_group_reject_action() {
      if (!this.sp_call(e => e.mut_origin_mark_list.group_exist_p(this.user_name))) {
        this.debug_alert("移動元印は一つもありません")
        return
      }
      const params = {
        __standalone_mode__: true,
        origin_mark_user_name: this.user_name,
      }
      this.ac_room_perform("origin_mark_group_reject_action", params) // --> app/channels/share_board/room_channel.rb
    },
    origin_mark_group_reject_action_broadcasted(params) {
      if (this.i_can_origin_mark_receive_p(params)) {
        this.sp_call(e => {
          if (e.mut_origin_mark_list.group_exist_p(params.origin_mark_user_name)) {
            e.mut_origin_mark_list.group_reject$(params.origin_mark_user_name)
            this.sfx_play("se_origin_mark_at_cell_off")
          }
        })
      }
    },
  },
}
