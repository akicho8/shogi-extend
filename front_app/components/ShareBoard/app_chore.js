import AbstractViewpointKeySelectModal from "./AbstractViewpointKeySelectModal.vue"
import TweetModal from "./TweetModal.vue"

export const app_chore = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// Windowアクティブチェック
    window_focus_user_after_hook() {
      this.tl_add("WINDOW", `[${this.window_active_count}] focus`)
      this.aclog("WINDOW", `[${this.window_active_count}] focus`)
    },
    window_blur_user_after_hook() {
      this.tl_add("WINDOW", `[${this.window_active_count}] blur`)
      this.aclog("WINDOW", `[${this.window_active_count}] blur`)
    },

    // 視点設定変更
    abstract_viewpoint_setting_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.modal.open({
        component: AbstractViewpointKeySelectModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: {
          abstract_viewpoint: this.abstract_viewpoint,
          permalink_for: this.permalink_for,
        },
        onCancel: () => this.sound_play("click"),
        events: {
          "update:abstract_viewpoint": v => {
            this.abstract_viewpoint = v
          }
        },
      })
    },

    // ツイート
    tweet_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.modal.open({
        component: TweetModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        props: { base: this.base },
        onCancel: () => this.sound_play("click"),
      })
    },

    // タイトル編集
    title_edit() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        title: "タイトル",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: this.current_title, required: false },
        onCancel: () => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          this.current_title_set(value)
        },
      })
    },

    // ツイートする
    // tweet_handle() {
    //   this.tweet_window_popup({url: this.current_url, text: this.tweet_hash_tag})
    // },

    tweet_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.tweet_window_popup({text: this.tweet_body})
    },

    exit_handle() {
      this.sound_play("click")
      if (this.ac_room || this.chess_clock) {

        this.talk("本当に退室してもよろしいですか？")

        this.$buefy.dialog.confirm({
          message: "本当に退室してもよろしいですか？<p class='has-text-grey is-size-7 mt-2'>初期配置に戻すために退室する必要はありません<br>左矢印で初期配置に戻ります</p>",
          cancelText: "キャンセル",
          confirmText: "退室する",
          focusOn: "cancel",
          onCancel: () => {
            this.talk_stop()
            this.sound_play("click")
            this.aclog("退室", "キャンセル")
          },
          onConfirm: () => {
            this.talk_stop()
            this.sound_play("click")
            this.aclog("退室", "実行")
            this.$router.push({name: "index"})
          },
        })
      } else {
        this.$router.push({name: "index"})
      }
    },
  },
}
