import { MyLocalStorage  } from "@/components/models/my_local_storage.js"
import _ from "lodash"
const QueryString = require("query-string")

export const app_chore = {
  methods: {
    kifu_copy_handle(row) {
      this.$sound.play_click()
      this.kif_clipboard_copy_from_url(`${row.show_path}.kif`)
    },

    kifu_save_url(row, params = {}) {
      return QueryString.stringifyUrl({
        url: this.$config.MY_SITE_URL + row.show_path + "." + "kif",
        query: {
          disposition: "attachment",
          ...params,
        },
      })
    },

    kifu_save_handle(row) {
      this.$sound.play_click()
      this.delay_block(1, () => this.toast_ok(`たぶんダウンロードしました`))
    },

    home_bookmark_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.$buefy.dialog.alert({
        title: "ホーム画面に追加",
        message: `
<b>検索直後</b>のURLを<b>ホーム画面に追加</b>か
<b>ブックマーク</b>してもウォーズIDの入力の手間を省けます。<br>
`,
        canCancel: ["outside", "escape"],
        confirmText: "わかった",
        type: 'is-info',
        onConfirm: () => this.$sound.play_click(),
        onCancel:  () => this.$sound.play_click(),
      })
    },

    external_app_handle(info) {
      if (this.xi.current_swars_user_key) {
        this.$sound.play_click()
        MyLocalStorage.set("external_app_setup", true)
        this.$router.push({
          name: 'swars-users-key-direct-open-external_app_key',
          params: {
            key: this.xi.current_swars_user_key,
            external_app_key: info.key,
          },
        })
      }
    },
  },
}
