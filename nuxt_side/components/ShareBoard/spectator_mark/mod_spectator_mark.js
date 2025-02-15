import { Gs } from "@/components/models/gs.js"
import dayjs from "dayjs"

const SS_MARK_COLOR_COUNT   = 12   // shogi-player 側で12色用意している
const PEPPER_DATE_FORMAT    = "-"  // 色が変化するタイミング。毎日なら"YYYY-MM-DD"。空にすると秒単位の時間になるので注意

export const mod_spectator_mark = {
  methods: {
    // CustomShogiPlayer からマークできる場所がタップされたときに呼ばれる
    ev_action_markable_pointerdown(params, event) {
      if (this.current_user_is_markable_p(event)) {
        const mark_attrs = this.sm_mark_attrs_from(params.mark_pos_key)
        // this.sp_call(e => e.mut_mark_list.toggle(mark_attrs))
        this.single_mark_share(mark_attrs)
      }
    },

    sm_mark_attrs_from(mark_pos_key) {
      return {
        mark_pos_key: mark_pos_key,              // 位置
        mark_user_name: this.user_name,          // 名前
        mark_color_index: this.mark_color_index, // 色
      }
    },

    // マークできる？
    current_user_is_markable_p(event) {
      if (!this.spectator_mark_mode_global_p) {
        return false
      }

      // return true

      // 観戦者ならマークできる
      if (this.self_is_watcher_p) {
        return true
      }

      // 対局者でもマークモードONならマークできる
      if (this.spectator_mark_mode_p) {
        return true
      }

      // 誰でもメタキーを押しながらであればマークできる
      // if (this.debug_mode_p) {
      if (this.keyboard_meta_p(event)) {
        return true
      }

      // }

      // if (this.self_is_member_p) {            // 対局メンバーかつ
      //   if (!this.current_turn_self_p) {      // 自分の手番ではないとき
      //     // if (this.my_team_member_is_one_p) { // 仲間は自分だけである (マークを受けとる仲間がいないのでよしとする)
      //     return true
      //     // }
      //   }
      // }

      // if (this.current_turn_self_p) {       // 現在自分の手番でかつ、
      //   if (this.my_team_member_is_one_p) { // 仲間は自分だけなら、マークを受けとる仲間がいないのでよしとする
      //     if (event && event.shiftKey) {    // ただそれだと駒操作できないので shiftKey を押しているときだけとする
      //       return true                     // TODO: これが true になるときは操作も禁止しないといけない → ややこしいのであと
      //     }
      //   }
      // }
      return false
    },

    //////////////////////////////////////////////////////////////////////////////// 共有

    single_mark_share(mark_attrs) {
      const params = {
        mark_attrs: mark_attrs,
      }
      if (this.ac_room) {
        this.ac_room_perform("single_mark_share", params) // --> app/channels/share_board/room_channel.rb
      } else {
        this.single_mark_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...params,
        })
      }
    },
    single_mark_share_broadcasted(params) {
      if (this.mark_receive_p(params)) {
        this.sp_call(e => e.mut_mark_list.toggle(params.mark_attrs))
      }
    },
    // 受信できる？
    mark_receive_p(params) {
      // 部屋を作っていないので受信できる
      if (!this.ac_room) {
        return true
      }

      // 自分のマークは受信できる
      // 自分のマークであってもチャットのようにサーバーを仲介して受信させる
      if (this.received_from_self(params)) {
        return true
      }

      // 観戦者なら問答無用で受信できる
      if (this.self_is_watcher_p) {
        return true
      }

      // マークを送ってきた相手が自分と同じチームであれば受信しない (リーダーの指示になるため)
      // const from_location = this.user_name_to_initial_location(params.from_user_name)
      // if (from_location && this.my_location) {
      //   if (from_location.key === this.my_location.key) {
      //     return false
      //   }
      // }

      // // 「自分→自分」はすでに自分側で操作し終わっているので無視する
      // if (this.received_from_self(params)) {
      //   return false
      // }
      // if (this.self_is_watcher_p) {           // 観戦者か？
      //   return true
      // }

      return false
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 全部消す
    // 指し終わったときに呼ばれる
    spectator_mark_all_clear() {
      this.sp_call(e => e.mut_mark_list.clear())
    },

    ////////////////////////////////////////////////////////////////////////////////

    spectator_mark_toggle_button_click_handle() {
      if (!this.spectator_mark_mode_global_p) {
        return
      }
      this.$sound.play_click()
      if (this.spectator_mark_mode_p) {
        this.spectator_mark_mode_p = false
      } else {
        this.spectator_mark_mode_p = true
      }
      return true
    },
  },
  computed: {
    // 現在の利用者の名前に対応する色番号を得る
    mark_color_index() {
      const pepper = dayjs().format(PEPPER_DATE_FORMAT)
      const hash_number = Gs.str_to_hash_number([pepper, this.user_name].join("-"))
      return Gs.imodulo(hash_number, SS_MARK_COLOR_COUNT)
    },

    // 切り替えボタンを表示するか？
    spectator_mark_button_show_p() {
      if (!this.spectator_mark_mode_global_p) {
        return false
      }

      // 部屋を作っていないとき
      if (!this.ac_room) {
        return true
      }

      // 順番設定をしていないとき
      if (!this.order_enable_p) {
        return true
      }

      // 対局者のとき
      if (this.self_is_member_p) {
        return true
      }

      return false
    },

    // 当初は単に pencil と pencil-circle-outline を切り替えるのようにしていたが円付きになると
    // 中のペンの大きさが変わって非常に違和感があったため、pencil は表示したままで自力で円を重ねる方法に変更した
    spectator_mark_button_icon() {
      if (this.spectator_mark_mode_p) {
        return "pencil"
      } else {
        return "pencil"
      }
    },
  },
}
