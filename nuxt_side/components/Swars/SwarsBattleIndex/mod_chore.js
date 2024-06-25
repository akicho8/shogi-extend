import { Gs } from "@/components/models/gs.js"
import { MyLocalStorage  } from "@/components/models/my_local_storage.js"
import _ from "lodash"
const QueryString = require("query-string")

export const mod_chore = {
  methods: {
    // ################################################################################

    // プレイヤー情報に移動する
    goto_player_info(e) {
      return this.goto_other_page(e, () => ({
        name: "swars-users-key",
        params: { key: this.xi.current_swars_user_key},
      }))
    },

    // カスタム検索に移動する
    goto_custom_search(e) {
      return this.goto_other_page(e, () => ({
        name: "swars-search-custom",
        query: Gs.hash_compact({user_key: this.xi.current_swars_user_key}),
      }))
    },

    goto_other_page(e, func) {
      if (this.xi && Gs.present_p(this.xi.current_swars_user_key)) {
        this.$sound.play_click()
        const url = this.$router.resolve(func()).href
        if (this.keyboard_meta_p(e)) {
          this.other_window_open(url)
        } else {
          this.$router.push(url)
        }
        return true
      }
    },

    // ################################################################################

    kifu_copy_first(e, options = {}) {
      if (this.xi) {
        const row = this.xi.records[0]
        if (row) {
          // const format = this.keyboard_meta_p(e) ? "ki2" : "kif"
          this.kifu_copy_handle(row, options)
          return true
        }
      }
    },
    kifu_copy_handle(row, options = {}) {
      options = {
        format: "kif",
        ...options,
      }
      this.$sound.play_click()
      this.kif_clipboard_copy_from_url(`${row.show_path}.${options.format}`)
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
      this.$gs.delay_block(1, () => this.toast_ok(`たぶんダウンロードしました`))
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
