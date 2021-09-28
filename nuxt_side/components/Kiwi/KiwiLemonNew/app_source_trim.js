import SfenTrimModal from "@/components/SfenTrimModal.vue"

export const app_source_trim = {
  methods: {
    // 入力済みの棋譜を sfen に変換して trim する
    any_source_trim_handle() {
      this.sound_play("click")
      const params = {
        any_source: this.body,
        to_format: "sfen",
      }
      this.$axios.$post("/api/general/any_source_to.json", params).then(e => {
        this.bs_error_message_dialog(e)
        if (e.body) {
          if (this.sfen_parse(e.body).moves.length === 0 && false) {
            // moves なしなら確定
            this.toast_ok("反映しました")
            this.body_update_by(e.body)
          } else {
            // moves があるので範囲を確定してもらう
            this.sfen_trim_modal_handle({
              default_sp_body: e.body,                  // KIFやURLから変換後の綺麗なSFEN
              default_sp_viewpoint: this.viewpoint_key, // 視点
              next_jump_to: "last",                     // 終了地点の選択は最後から開始
            })
          }
        }
      })
    },

    sfen_trim_modal_handle(props) {
      const modal_instance = this.modal_card_open({
        props: props,
        component: SfenTrimModal,
        events: {
          "update:submit": e => {
            this.sound_play("click")
            this.viewpoint_key = e.viewpoint
            this.body_update_by(e.full_sfen)
            modal_instance.close()
          },
        },
      })
    },

    body_update_by(sfen) {
      this.body = sfen
    },
  },
}
