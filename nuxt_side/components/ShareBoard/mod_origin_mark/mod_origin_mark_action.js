import { GX } from "@/components/models/gx.js"

export const mod_origin_mark_action = {
  methods: {
    ev_action_origin_mark_push(origin_mark_pos_key, event) {
      if (this.i_can_origin_mark_send_p(event)) {
        this.origin_mark_general_action("push", origin_mark_pos_key)
      }
      // const attributes = this.create_attributes(origin_mark_pos_key)
      // this.$refs.sp_object.mut_origin_mark_list.push(attributes)
    },

    ev_action_origin_mark_remove(origin_mark_pos_key, event) {
      if (this.i_can_origin_mark_send_p(event)) {
        this.origin_mark_general_action("remove", origin_mark_pos_key)
      }
      // const attributes = this.create_attributes(origin_mark_pos_key)
      // this.$refs.sp_object.mut_origin_mark_list.remove(attributes)
    },

    // create_attributes(origin_mark_pos_key) {
    //   return {
    //     origin_mark_pos_key:   origin_mark_pos_key,
    //     origin_mark_user_name: this.current_user_name,
    //     origin_mark_color_index: this.user_index,
    //   }
    // },

    ////////////////////////////////////////////////////////////////////////////////

    // CustomShogiPlayer からマークできる場所がタップされたときに呼ばれる
    // ここでは直接操作せずにコマンドを作り (自分であっても) サーバーを介してから反映する
    // ev_origin_mark_click(ev_params, event) {
    //   if (this.i_can_origin_mark_send_p(event)) { // このチェックをしなかったら駒を持つと同時に印を書ける
    //     this.origin_mark_general_action(ev_params)
    //   }
    // },

    //////////////////////////////////////////////////////////////////////////////// 共有

    origin_mark_general_action(origin_mark_pos_key) {
      const params = {
        __standalone_mode__: true,
        origin_mark_command: {
          method: "push",
          params: this.origin_mark_attributes_create(origin_mark_pos_key),
        },
      }
      this.ac_room_perform("origin_mark_general_action", params) // --> app/channels/share_board/room_channel.rb
    },
    origin_mark_general_action_broadcasted(params) {
      if (!this.i_can_origin_mark_receive_p(params)) {
        return
      }
      this.sp_call(e => {
        if (e.mut_origin_mark_list.toggle_command_apply(params.origin_mark_command)) {
          this.origin_mark_se_call(params.origin_mark_command)
        }
      })
    },

    // origin_mark_general_action(origin_mark_pos_key) {
    //   const params = {
    //     __standalone_mode__: true,
    //     origin_mark_attributes: this.origin_mark_attributes_create(origin_mark_pos_key),
    //   }
    //   this.ac_room_perform("origin_mark_general_action", params) // --> app/channels/share_board/room_channel.rb
    // },
    // origin_mark_general_action_broadcasted(params) {
    //   if (!this.i_can_origin_mark_receive_p(params)) {
    //     return
    //   }
    //   this.sp_call(e => {
    //     if (e.mut_origin_mark_list.remove(params.origin_mark_attributes)) {
    //       this.sfx_play("se_piece_lift_cancel")
    //     }
    //   })
    // },

    // コマンド発行のための引数を作る
    origin_mark_attributes_create(origin_mark_pos_key) {
      return {
        origin_mark_pos_key: origin_mark_pos_key,              // 位置 (必須)
        origin_mark_user_name: this.user_name,                 // 名前
        origin_mark_color_index: this.origin_mark_color_index, // 色 (名前から自動的に決めている)
      }
    },

    // コマンド発行
    // __origin_mark_command_from(origin_mark_pos_key) {
    //   return this.origin_mark_attributes_create(origin_mark_pos_key)
    //   return this.sp_call(e => e.mut_origin_mark_list.toggle_command_create(origin_mark_attrs))
    // },

    // 効果音
    origin_mark_se_call(origin_mark_command) {
      const push_trigger = (origin_mark_command.method === "push")
      let se_key = null
      if (push_trigger) {
        se_key = "se_piece_lift"
      } else {
        se_key = "se_piece_lift_cancel"
      }
      this.sfx_play(se_key)
    },
  },
  computed: {
  },
}
