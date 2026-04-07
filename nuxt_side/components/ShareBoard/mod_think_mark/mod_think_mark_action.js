import { GX } from "@/components/models/gx.js"

export const mod_think_mark_action = {
  methods: {
    // CustomShogiPlayer からマークできる場所がタップされたときに呼ばれる
    // ここでは直接操作せずにコマンドを作り (自分であっても) サーバーを介してから反映する
    ev_think_mark_click(ev_params, event) {
      if (this.i_can_think_mark_send_p(event)) { // このチェックをしなかったら駒を持つと同時に印を書ける
        this.think_mark_general_action(ev_params)
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 共有

    think_mark_general_action(ev_params) {
      const params = {
        __standalone_mode__: true,
        think_mark_command: this.__think_mark_command_from(ev_params.think_mark_pos_key),
      }
      this.ac_room_perform("think_mark_general_action", params) // --> app/channels/share_board/room_channel.rb
    },
    think_mark_general_action_broadcasted(params) {
      if (this.i_can_think_mark_receive_p(params)) {
        this.sp_call(e => {
          e.mut_think_mark_list.toggle_command_apply(params.think_mark_command)
          this.think_mark_se_call(params.think_mark_command)
        })
      }
    },

    // コマンド発行のための引数を作る
    __think_mark_attrs_from(think_mark_pos_key) {
      return {
        think_mark_pos_key: think_mark_pos_key,              // 位置 (必須)
        think_mark_user_name: this.user_name,          // 名前
        think_mark_color_index: this.think_mark_color_index, // 色 (名前から自動的に決めている)
      }
    },

    // コマンド発行
    __think_mark_command_from(think_mark_pos_key) {
      const think_mark_attrs = this.__think_mark_attrs_from(think_mark_pos_key)
      return this.sp_call(e => e.mut_think_mark_list.toggle_command_create(think_mark_attrs))
    },

    // 効果音
    think_mark_se_call(think_mark_command) {
      const push_trigger = (think_mark_command.method === "push")
      let se_key = null
      if (push_trigger) {
        se_key = "se_think_mark_at_cell_on"
      } else {
        se_key = "se_think_mark_at_cell_off"
      }
      this.sfx_play(se_key)
    },
  },
  computed: {
  },
}
