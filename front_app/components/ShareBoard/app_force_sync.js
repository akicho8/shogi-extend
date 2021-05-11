// import _ from "lodash"
// import dayjs from "dayjs"
import ForceSyncModal from "./ForceSyncModal.vue"

export const app_force_sync = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    board_init_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.dialog.confirm({
        title: "初期配置に戻す",
        message: `
          <p>これは次のショートカットです</p>
          <div class="content">
            <ol>
              <li>左矢印で局面を0手目に移動</li>
              <li><b>局面を全員に転送</b>の実行</li>
            </ol>
          </div>
        `,
        cancelText: "キャンセル",
        confirmText: "本当に実行",
        type: "is-danger",
        focusOn: "cancel",
        animation: "",
        onCancel: () => {
          this.sound_play("click")
        },
        onConfirm: () => {
          this.sound_play("click")
          this.board_init()
        },
      })
    },

    board_init() {
      this.ac_log("局面操作", "初期配置に戻す")
      this.turn_offset = 0
      this.force_sync(`${this.user_call_name(this.user_name)}が初期配置に戻しました`)
    },

    ////////////////////////////////////////////////////////////////////////////////

    board_revert_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.dialog.confirm({
        title: "1手戻す",
        message: `
          <p>これは次のショートカットです</p>
          <div class="content">
            <ol>
              <li>小さい左矢印で局面を1手戻す</li>
              <li><b>局面を全員に転送</b>の実行</li>
            </ol>
          </div>
        `,
        cancelText: "キャンセル",
        confirmText: "本当に実行",
        type: "is-danger",
        focusOn: "cancel",
        animation: "",
        onCancel: () => {
          this.sound_play("click")
        },
        onConfirm: () => {
          this.sound_play("click")
          this.board_revert()
        },
      })
    },

    board_revert() {
      this.ac_log("局面操作", "1手戻す")
      this.turn_offset -= 1
      this.force_sync(`${this.user_call_name(this.user_name)}が1手戻しました`)
    },

    ////////////////////////////////////////////////////////////////////////////////

    force_sync_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: ForceSyncModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },

    force_sync(message) {
      const params = {
        message,
        sfen: this.current_sfen,
        turn_offset: this.turn_offset,
      }
      this.ac_room_perform("force_sync", params) // --> app/channels/share_board/room_channel.rb
    },

    force_sync_broadcasted(params) {
      // if (params.from_user_code === this.user_code) {
      //   this.debug_alert("自分受信")
      //   this.toast_ok(`${this.user_call_name(params.from_user_name)}の盤の状態をみんなに送ってセットしました`)
      // } else {
      //   this.debug_alert("相手受信")

      // this.tl_add("FORCE_SYNCED", params.sfen)
      // this.tl_add("FORCE_SYNCED", params.turn_offset)

      this.setup_by_params(params) // これで current_location が更新される
      if (this.chess_clock) {
        // this.tl_add("current_location", this.current_location.key)
        // this.tl_add("LOCATION", this.chess_clock.current_location.key)
        this.chess_clock.turn_to(this.current_location)
        // this.tl_add("LOCATION", this.chess_clock.current_location.key)
      }

      if (params.message) {
        this.toast_ok(params.message)
        // this.toast_ok(`${this.user_call_name(params.from_user_name)}から送られてきた盤の状態に合わせました`)
      }
      // }
    },
  },
}
