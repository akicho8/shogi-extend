import AbstractViewpointKeySelectModal from "./AbstractViewpointKeySelectModal.vue"
import _ from "lodash"

export const app_chore = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// Windowアクティブチェック
    window_active_change_user_hook(focus_p) {
      this.tl_add("画面焦点", focus_p ? "ON" : "OFF")
      this.ac_log("画面焦点", focus_p ? "ON" : "OFF")
      this.member_info_bc_restart()

      if (!focus_p) {
        this.xmatch_window_blur()
      }
    },

    // 視点設定変更
    abstract_viewpoint_key_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.modal_card_open({
        component: AbstractViewpointKeySelectModal,
        props: {
          abstract_viewpoint: this.abstract_viewpoint,
          permalink_for: this.permalink_for,
        },
        events: {
          "update:abstract_viewpoint": v => {
            this.abstract_viewpoint = v
          }
        },
      })
    },

    // タイトル編集
    title_edit_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        title: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        animation: "",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onCancel: () => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          this.current_title_set(value)
        },
      })
    },

    exit_handle() {
      this.sound_play("click")
      if (this.ac_room || this.clock_box) {

        this.talk("本当に退室してもよろしいですか？")

        this.$buefy.dialog.confirm({
          message: "本当に退室してもよろしいですか？<p class='has-text-grey is-size-7 mt-2'>初期配置に戻すために退室する必要はありません<br>左矢印で初期配置に戻ります</p>",
          cancelText: "キャンセル",
          confirmText: "退室する",
          focusOn: "cancel",
          animation: "",
          onCancel: () => {
            this.sound_stop_all()
            this.sound_play("click")
            this.ac_log("退室", "キャンセル")
          },
          onConfirm: () => {
            this.sound_stop_all()
            this.sound_play("click")
            this.ac_log("退室", "実行")
            this.$router.push({name: "index"})
          },
        })
      } else {
        this.$router.push({name: "index"})
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    modal_card_open(params = {}) {
      // this.sidebar_p = false
      // this.sound_play("click")
      this.__assert__(this.present_p(params.component.name), "this.present_p(params.component.name)")
      return this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: `BasicModal ${params.component.name}`,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: ["outside", "escape"],
        onCancel: () => this.sound_play("click"),
        ...params,
      })
    },
  },
}
