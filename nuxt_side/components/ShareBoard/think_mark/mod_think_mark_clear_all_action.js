import { GX } from "@/components/models/gx.js"

export const mod_think_mark_clear_all_action = {
  methods: {
    think_mark_clear_all_action(params = {}) {
      params = {
        __standalone_mode__: true,
        sfx: true,
        ...params,
      }
      this.ac_room_perform("think_mark_clear_all_action", params) // --> app/channels/share_board/room_channel.rb
    },
    think_mark_clear_all_action_broadcasted(params) {
      if (this.i_can_mark_receive_p(params)) {
        this.sp_call(e => {
          if (e.mut_think_mark_list.size > 0) {
            e.mut_think_mark_list.clear()
            if (params.sfx) {
              this.sfx_play("se_think_mark_at_cell_off")
            }
          }
        })
      }
    },
  },
}
