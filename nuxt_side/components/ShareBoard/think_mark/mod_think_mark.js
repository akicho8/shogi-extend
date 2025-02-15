import { Gs } from "@/components/models/gs.js"
import dayjs from "dayjs"
import { ThinkMarkReceiveScopeInfo } from "./think_mark_receive_scope_info.js"

const SS_MARK_COLOR_COUNT = 12   // shogi-player 側で12色用意している
const PEPPER_DATE_FORMAT  = "-"  // 色が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意

export const mod_think_mark = {
  methods: {
    // CustomShogiPlayer からマークできる場所がタップされたときに呼ばれる
    ev_action_markable_pointerdown(params, event) {
      if (this.i_can_mark_send_p(event)) {
        const think_mark_command = this.think_mark_command_from(params.mark_pos_key)
        this.think_mark_share(think_mark_command)
      }
    },

    think_mark_command_from(mark_pos_key) {
      const think_mark_attrs = this.think_mark_attrs_from(mark_pos_key)
      return this.sp_call(e => e.mut_think_mark_list.toggle_command_create(think_mark_attrs))
    },

    think_mark_attrs_from(mark_pos_key) {
      return {
        mark_pos_key: mark_pos_key,              // 位置
        mark_user_name: this.user_name,          // 名前
        mark_color_index: this.mark_color_index, // 色
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 共有

    think_mark_share(think_mark_command) {
      const params = {
        think_mark_command: think_mark_command,
      }

      if (this.ac_room == null) {
        this.think_mark_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...params,
        })
        return
      }

      this.ac_room_perform("think_mark_share", params) // --> app/channels/share_board/room_channel.rb
    },
    think_mark_share_broadcasted(params) {
      if (this.i_can_mark_receive_p(params)) {
        this.sp_call(e => {
          e.mut_think_mark_list.toggle_command_apply(params.think_mark_command)
          this.$sound.play_toggle(params.think_mark_command.method === "push")
        })
      }
    },

    //////////////////////////////////////////////////////////////////////////////// i_can_mark_send_p と i_can_mark_receive_p が重要

    // 自分はマークを送れる？
    // マーク自体は役割に関係なく think_mark_mode_p を有効にすれば送ることができる、とする
    i_can_mark_send_p(event) {
      // マークモードONならマークできる
      if (this.think_mark_mode_p) {
        return true
      }

      // 誰でもメタキーを押しながらでもマークできる
      if (this.keyboard_meta_p(event)) {
        return true
      }

      return false
    },

    // 自分は受信できる？
    i_can_mark_receive_p(params) {
      // 自分から自分へは受信できる
      if (this.received_from_self(params)) {
        return true
      }

      if (this.think_mark_receive_scope_info._if(this, params)) {
        return true
      }

      return false
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 全部消す
    // 指し終わったときに呼ばれる
    think_mark_all_clear() {
      this.sp_call(e => e.mut_think_mark_list.clear())
    },

    ////////////////////////////////////////////////////////////////////////////////

    think_mark_toggle_button_click_handle() {
      if (!this.think_mark_mode_global_p) {
        return
      }
      this.$sound.play_click()
      if (this.think_mark_mode_p) {
        this.think_mark_mode_p = false
      } else {
        this.think_mark_mode_p = true
      }
      return true
    },

    // 順番設定反映後、自分の立場に応じてマークモードの初期値を自動で設定する
    think_mark_auto_set() {
      if (!this.think_mark_mode_global_p) {
        return
      }
      this.debug_alert("自動印設定")
      // 対局者ならOFF
      if (this.i_am_member_p) {
        this.think_mark_mode_p = false
      }
      // 観戦者ならON
      if (this.i_am_watcher_p) {
        this.think_mark_mode_p = true
      }
    },
  },
  computed: {
    ThinkMarkReceiveScopeInfo()    { return ThinkMarkReceiveScopeInfo },
    think_mark_receive_scope_info() { return this.ThinkMarkReceiveScopeInfo.fetch(this.think_mark_receive_scope_key) },

    // 現在の利用者の名前に対応する色番号を得る
    mark_color_index() {
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = Gs.str_to_hash_number([pepper, this.user_name].join("-"))
      return Gs.imodulo(hash_number, SS_MARK_COLOR_COUNT)
    },

    // 切り替えボタンを表示するか？
    think_mark_button_show_p() {
      if (!this.think_mark_mode_global_p) {
        return false
      }

      return true
    },

    // 当初は単に pencil と pencil-circle-outline を切り替えるのようにしていたが円付きになると
    // 中のペンの大きさが変わって非常に違和感があったため、pencil は表示したままで自力で円を重ねる方法に変更した
    think_mark_button_icon() {
      if (this.think_mark_mode_p) {
        return "pencil"
      } else {
        return "pencil"
      }
    },
  },
}
