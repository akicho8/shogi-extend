// import _ from "lodash"
// import dayjs from "dayjs"
import ForceSyncModal from "./ForceSyncModal.vue"

export const app_force_sync = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    board_init_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.dialog_confirm({
        title: "初期配置に戻す",
        message: `
          <p>次の処理を連続で実行します</p>
          <div class="content">
            <ol>
              <li>スライダーで0手目に移動</li>
              <li>局面の転送</li>
            </ol>
          </div>
          <p class="is-size-7 has-text-grey">途中で局面編集した場合は基点(0手目)の局面が変わるため「平手の初期配置」にはなりません。平手の初期配置に変更する意図であれば手合割から平手を選択してください</p>
        `,
        confirmText: "本当に実行",
        type: "is-danger",
        focusOn: "cancel",
        onConfirm: () => {
          this.sound_play_click()
          this.force_sync_turn_zero()
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_turn_previous_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()

      this.dialog_confirm({
        title: "1手戻す",
        message: `
          <p>次の処理を連続で実行します</p>
          <div class="content">
            <ol>
              <li>スライダーで1手前に移動</li>
              <li>局面の転送</li>
            </ol>
          </div>
        `,
        confirmText: "本当に実行",
        type: "is-danger",
        focusOn: "cancel",
        onConfirm: () => {
          this.sound_play_click()
          this.force_sync_turn_previous()
        },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: ForceSyncModal,
        props: { base: this.base },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_direct() {
      this.ac_log("局面操作", `直接${this.turn_offset}手目`)
      this.force_sync(`${this.user_call_name(this.user_name)}が${this.turn_offset}手目の局面を転送しました`)
    },

    force_sync_turn_zero() {
      this.ac_log("局面操作", "初期配置に戻す")
      this.turn_offset = 0
      this.force_sync(`${this.user_call_name(this.user_name)}が初期配置に戻しました`)
    },

    force_sync_turn_previous() {
      this.ac_log("局面操作", "1手戻す")
      if (this.turn_offset >= 1) {
        this.turn_offset -= 1
      }
      this.force_sync(`${this.user_call_name(this.user_name)}が1手戻しました`)
    },

    force_sync_handicap() {
      this.turn_offset = 0
      this.current_sfen = this.handicap_preset_info.sfen
      this.ac_log("駒落適用", this.handicap_preset_info.name)
      this.force_sync(`${this.user_call_name(this.user_name)}が${this.handicap_preset_info.name}に変更しました`)
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync(message) {
      const params = {
        message,
        sfen: this.current_sfen,
        turn_offset: this.turn_offset,
      }
      this.ac_room_perform("force_sync", params) // --> app/channels/share_board/room_channel.rb
    },

    force_sync_broadcasted(params) {
      this.setup_by_params(params) // これで current_location が更新される
      if (this.clock_box) {
        this.clock_box.location_to(this.current_location)
      }
      if (params.message) {
        this.toast_ok(params.message)
      }
      this.al_add({...params, label: `局面転送 #${params.turn_offset}`})
    },
  },
}
