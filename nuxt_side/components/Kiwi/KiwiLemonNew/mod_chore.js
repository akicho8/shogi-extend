import { SafeSfen } from "@/components/models/safe_sfen.js"

export const mod_chore = {
  methods: {
    any_source_edit_handle() {
      this.sfx_click()
      this.$buefy.dialog.confirm({
        title: "共有将棋盤で編集しますか？",
        message: "あっちのメニューの「動画変換」で戻ってこれます",
        cancelText: "キャンセル",
        confirmText: "編集する",
        // focusOn: "confirm", // confirm or cancel
        animation: "",
        onCancel: () => this.sfx_click(),
        onConfirm: () => {
          this.sfx_click()
          const params = { any_source: this.body || "平手" , to_format: "sfen" }
          this.$axios.$post("/api/general/any_source_to.json", params).then(e => {
            this.bs_error_message_dialog(e)
            if (e.body) {
              const params = {
                xbody: SafeSfen.encode(e.body),
                viewpoint: this.viewpoint,
              }
              this.$router.push({name: "share-board", query: params})
            }
          })
        },
      })
    },
  },
}
