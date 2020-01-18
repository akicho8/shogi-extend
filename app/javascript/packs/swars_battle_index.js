import battle_index_shared from "battle_index_shared.js"

window.SwarsBattleIndex = Vue.extend({
  mixins: [battle_index_shared],

  data() {
    return {
      submited: false,
      detailed: false,
    }
  },

  mounted() {
    if (this.$options.required_query_for_search) { // js側から一覧のレコードを出すときは必ず query が入っていないといけない場合
      if (this.query) {
        this.async_records_load()
      }
    } else {
      this.async_records_load()
    }
  },

  methods: {
    // テーブルを表示する条件は検索文字列があること
    // フォームに割り当てられている this.query だと変動するので使ってはいけない
    table_display_p() {
      return this.$options.query
    },

    player_info_click_hadle(e) {
      if (this.$options.player_info_path) {
        this.$buefy.dialog.confirm({
          message: "20秒ぐらいかかる場合がありますがよろしいですか？",
          confirmText: "取得する",
          cancelText: "やめとく",
          onCancel: () => this.talk("やめときました"),
          onConfirm: () => {
            this.process_now()
            location.href = this.$options.player_info_path
          },
        })
      }
    },

    many_import_handle(e) {
      this.$buefy.dialog.confirm({
        message: "1分ぐらいかかる場合がありますがよろしいですか？",
        confirmText: "取り込む",
        cancelText: "やめとく",
        onCancel: () => this.talk("やめときました"),
        onConfirm: () => {
          this.process_now()
          this.$refs.many_import_link.click()
        },
      })
    },

    form_submited(e) {
      this.process_now()

      this.submited = true
    },
  },
})
