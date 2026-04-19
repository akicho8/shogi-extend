import { GX } from "@/components/models/gx.js"

export const mod_think_mark_clear_action = {
  methods: {
    think_mark_clear_action(params = {}) {
      params = {
        __standalone_mode__: true,
        sfx: true,
        ...params,
      }
      this.ac_room_perform("think_mark_clear_action", params) // --> app/channels/share_board/room_channel.rb
    },
    think_mark_clear_action_broadcasted(params) {
      if (this.i_can_think_mark_receive_p(params)) {
        this.sp_call(e => {
          if (e.mut_think_mark_collection.size > 0) {
            e.mut_think_mark_collection.clear$()
            if (params.sfx) {
              this.sfx_play("se_think_mark_off")
            }
          }
        })
      }
    },
  },
}
