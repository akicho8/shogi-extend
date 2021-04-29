import { MyLocalStorage  } from "@/components/models/my_local_storage.js"
import _ from "lodash"

export const app_chore = {
  methods: {
    kifu_copy_handle(row) {
      this.sound_play('click')
      this.kif_clipboard_copy({kc_path: row.show_path})
    },

    bookmark_desc() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.dialog.alert({
        title: "ホーム画面に追加",
        message: `検索初期値の設定の他には<b>検索直後</b>のURLを<b>ホーム画面に追加</b>かブックマークしてもウォーズIDの入力の手間を省けます`,
        canCancel: ["outside", "escape"],
        confirmText: "わかった",
        type: 'is-info',
        onConfirm: () => this.sound_play("click"),
        onCancel:  () => this.sound_play("click"),
      })
    },

    external_app_handle(info) {
      if (this.config.current_swars_user_key) {
        this.sound_play("click")
        MyLocalStorage.set("external_app_setup", true)
        this.$router.push({
          name: 'swars-users-key-direct-open-external_app_key',
          params: {
            key: this.config.current_swars_user_key,
            external_app_key: info.key,
          },
        })
      }
    },

    // 棋譜ダウンロード
    zip_dl_handle(e) {
      this.sidebar_p = false
      this.sound_play("click")

      this.toast_ok(`${e.body_encode} の ${e.format_key_upcase} をダウンロードしています`)

      const params = {
        query:          this.query,
        zip_dl_format_key: e.format_key,
        body_encode:    e.body_encode,
        // zip_dl_scope_key:  "latest",
        sort_column: this.$route.query.sort_column || this.config.sort_column,
        sort_order:  this.$route.query.sort_order || this.config.sort_order,
      }

      const usp = new URLSearchParams()
      _.each(params, (v, k) => usp.set(k, v))
      const url = this.$config.MY_SITE_URL + `/w.zip?${usp}`
      location.href = url

      this.delay_block(3, () => {
        this.toast_ok(`たぶんダウンロード完了しました`, {
          onend: () => {
            this.toast_ok(`もっとたくさんダウンロードしたいときは「古い棋譜を補完」のほうを使ってください`)
          },
        })
      })
    },

    vs_input_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        title: "対戦相手で絞る",
        confirmText: "実行",
        cancelText: "キャンセル",
        inputAttrs: { type: "text", value: "", required: false, placeholder: "対戦相手のウォーズIDを入力" },
        onCancel: () => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          value = _.trim(value)
          const new_query = [this.config.current_swars_user_key, `vs:${value}`].join(" ")
          this.$router.push({name: "swars-search", query: {query: new_query}})
        },
      })
    },
  },
}
