import { Question} from "./models/question.js"

import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

class HistoryTabInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "history_index", tab_name: "履歴",       top_nav_name: "問題履歴"    },
      { key: "clip_index",    tab_name: "保存リスト", top_nav_name: "保存リスト", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}

export const application_history = {
  data() {
    return {
      history_tab_index: null,

      history_records: [],      // 履歴の一覧
      clip_records: [],         // 保存の一覧
    }
  },
  methods: {
    history_index_handle() {
      this.history_mode_select("history_index")

      if (this.history_records && false) {
      } else {
        this.api_get("history_records_fetch", {}, e => {
          if (e.history_records) {
            this.history_records = e.history_records.map(e => Object.assign({}, e, {question: new Question(e.question)}))
          }
        })
      }
    },

    clip_index_handle() {
      this.history_mode_select("clip_index")

      if (this.clip_records && false) {
      } else {
        this.api_get("clip_records_fetch", {}, e => {
          if (e.clip_records) {
            this.clip_records = e.clip_records.map(e => Object.assign({}, e, {question: new Question(e.question)}))
          }
        })
      }
    },

    history_mode_select(tab_key) {
      this.history_tab_index = HistoryTabInfo.fetch(tab_key).code
    },

    history_tab_change_handle() {
      this.sound_play("click")
      this.base[this.history_current_tab_info.handle_method_name]()
    },
  },

  computed: {
    HistoryTabInfo() { return HistoryTabInfo },

    history_current_tab_info() {
      return HistoryTabInfo.fetch(this.history_tab_index)
    },
  },
}
