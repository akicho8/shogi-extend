import { GX } from "@/components/models/gx.js"

export const mod_origin_mark_clear_all_action = {
  methods: {
    origin_mark_clear_all_action(params = {}) {
      params = {
        __standalone_mode__: true,
        sfx: true,
        ...params,
      }
      this.ac_room_perform("origin_mark_clear_all_action", params) // --> app/channels/share_board/room_channel.rb
    },
    origin_mark_clear_all_action_broadcasted(params) {
      if (this.i_can_origin_mark_receive_p(params)) {
        this.sp_call(e => {
          if (e.mut_origin_mark_list.size > 0) {
            e.mut_origin_mark_list.clear()
            if (params.sfx) {
              this.sfx_play("se_origin_mark_at_cell_off")
            }
          }
        })
      }
    },
  },
}
