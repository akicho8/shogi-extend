import { GX } from "@/components/models/gs.js"
import { MyLocalStorage  } from "@/components/models/my_local_storage.js"
import _ from "lodash"
import QueryString from "query-string"

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
        query: GX.hash_compact({user_key: this.xi.current_swars_user_key}),
      }))
    },

    goto_other_page(e, func) {
      if (this.xi && GX.present_p(this.xi.current_swars_user_key)) {
        this.sfx_click()
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

    show_url_all_open_handle() {
      this.sidebar_close()
      this.sfx_click()
      if (this.xi && GX.present_p(this.xi.records)) {
        this.xi.records.forEach(row => {
          this.other_window_open(this.show_url(row))
        })
      }
      return true
    },

    show_url(row) {
      const router_params = {name: 'swars-battles-key', params: {key: row.key}, query: {viewpoint: row.memberships[0].location_key}}
      return this.$router.resolve(router_params).href
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
      this.sfx_click()
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
      this.sfx_click()
      this.$gs.delay_block(1, () => this.toast_ok(`たぶんダウンロードしました`))
    },

    kifu_save_shortcut_handle(e) {
      if (this.xi) {
        const row = this.xi.records[0]
        if (row) {
          this.kifu_save_handle(row)
          location.href = this.kifu_save_url(row, {body_encode: 'UTF-8'})
          return true
        }
      }
    },

    home_bookmark_handle() {
      this.sidebar_p = false
      this.sfx_click()
      this.$buefy.dialog.alert({
        title: "ホーム画面に追加",
        message: `
<b>検索直後</b>のURLを<b>ホーム画面に追加</b>か
<b>ブックマーク</b>してもウォーズIDの入力の手間を省けます。<br>
`,
        canCancel: ["outside", "escape"],
        confirmText: "わかった",
        type: 'is-info',
        onConfirm: () => this.sfx_click(),
        onCancel:  () => this.sfx_click(),
      })
    },

    external_app_handle(info) {
      if (this.xi.current_swars_user_key) {
        this.sfx_click()
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
