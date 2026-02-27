import { GX } from "@/components/models/gx.js"

export const mod_think_mark_group_reject_action = {
  methods: {
    think_mark_group_reject_action() {
      if (!this.sp_call(e => e.mut_think_mark_list.group_exist_p(this.user_name))) {
        this.debug_alert("思考印は一つもありません")
        return
      }
      const params = {
        __standalone_mode__: true,
        mark_user_name: this.user_name,
      }
      this.ac_room_perform("think_mark_group_reject_action", params) // --> app/channels/share_board/room_channel.rb
    },
    think_mark_group_reject_action_broadcasted(params) {
      if (this.i_can_mark_receive_p(params)) {
        this.sp_call(e => {
          if (e.mut_think_mark_list.group_exist_p(params.mark_user_name)) {
            e.mut_think_mark_list.group_reject$(params.mark_user_name)
            this.sfx_play("se_think_mark_at_cell_off")
          }
        })
      }
    },
  },
}
