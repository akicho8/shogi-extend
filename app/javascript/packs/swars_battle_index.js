import battle_index_mod from "battle_index_mod.js"
import usage_mod from "usage_mod.js"

window.SwarsBattleIndex = Vue.extend({
  mixins: [
    battle_index_mod,
    usage_mod,
  ],

  data() {
    return {
      submited: false,
      detailed: false,
    }
  },

  mounted() {
    if (this.index_table_show_p) {
      this.async_records_load()
    }
  },

  computed: {
    // 最初に一覧を表示するか？
    index_table_show_p() {
      // required_query_for_search の指定がなければ常に表示する
      if (!this.$options.required_query_for_search) {
        return true
      }
      // テーブルを表示する条件は検索文字列があること。または modal_record があること。
      // フォームに割り当てられている this.query だと変動するので使ってはいけない
      return this.$options.query || this.$options.modal_record
    },

    search_form_complete_list() {
      return this.$options.remember_swars_user_keys.filter((option) => {
        return option.toString().toLowerCase().indexOf(this.query.toLowerCase()) >= 0
      })
    }
  },

  methods: {
    // // テーブルを表示する条件は検索文字列があること
    // // フォームに割り当てられている this.query だと変動するので使ってはいけない
    // table_display_p() {
    //   return this.$options.query
    // },

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
