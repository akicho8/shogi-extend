import { ArticleEditTabInfo } from '../models/article_edit_tab_info.js'

export const mod_tabs = {
  data() {
    return {
      tab_index: null,
    }
  },

  methods: {
    tab_set(tab_key) {
      this.tab_index = this.ArticleEditTabInfo.fetch(tab_key).code
    },

    edit_tab_change_handle(v) {
      this.sfx_click()
      if (false) {
        this.talk(this.current_tab_info.name)
      }
      this[`${this.current_tab_info.key}_tab_handle`]()
    },

    //////////////////////////////////////////////////////////////////////////////// 各タブ切り替えた直後の初期化処理

    placement_tab_handle() {
      this.tab_set("placement")
    },

    answer_tab_handle() {
      this.answer_base_sfen = this.article.init_sfen
      this.tab_set("answer")
    },

    form_tab_handle() {
      this.tab_set("form")
    },

    validation_tab_handle() {
      this.tab_set("validation")
      this.exam_run_count = 0
      if (this.talk) {
        this.talk(this.article.direction_message)
      }
    },
  },
  computed: {
    ArticleEditTabInfo() { return ArticleEditTabInfo                       },
    current_tab_info()   { return ArticleEditTabInfo.fetch(this.tab_index) },
  },
}
