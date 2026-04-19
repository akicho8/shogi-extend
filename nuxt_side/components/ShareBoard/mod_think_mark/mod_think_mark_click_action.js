import { GX } from "@/components/models/gx.js"

export const mod_think_mark_click_action = {
  methods: {
    // CustomShogiPlayer からマークできる場所がタップされたときに呼ばれる
    // ここでは直接操作せずにコマンドを作り (自分であっても) サーバーを介してから反映する
    ev_think_mark_click(think_mark_pos_key, event) {
      if (this.i_can_think_mark_send_p(event)) { // このチェックをしなかったら駒を持つと同時に印を書ける
        this.think_mark_click_action(think_mark_pos_key)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 共有

    think_mark_click_action(think_mark_pos_key) {
      const params = {
        __standalone_mode__: true,
        think_mark_command: this.__think_mark_command_from(think_mark_pos_key),
      }
      this.ac_room_perform("think_mark_click_action", params) // --> app/channels/share_board/room_channel.rb
    },
    think_mark_click_action_broadcasted(params) {
      if (this.i_can_think_mark_receive_p(params)) {
        this.sp_call(e => {
          e.mut_think_mark_collection.command_execute$(params.think_mark_command)
          this.think_mark_se_call(params.think_mark_command)
        })
      }
    },

    // コマンド発行
    __think_mark_command_from(think_mark_pos_key) {
      const attrs = this.general_mark_attributes_create(think_mark_pos_key)
      return this.sp_call(e => e.mut_think_mark_collection.command_for_toggle(attrs))
    },

    // 効果音
    think_mark_se_call(think_mark_command) {
      const push_trigger = (think_mark_command.method === "push")
      let se_key = null
      if (push_trigger) {
        se_key = "se_think_mark_on"
      } else {
        se_key = "se_think_mark_off"
      }
      this.sfx_play(se_key)
    },
  },
  computed: {
  },
}
