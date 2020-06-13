import { Question} from "../models/question.js"

import MemoryRecord from 'js-memory-record'

class TabInfo2 extends MemoryRecord {
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

export const the_history_basic = {
  data() {
    return {
      tab_index2: null,
      history_records: [],
      clip_records: [],
    }
  },
  methods: {
    history_index_handle() {
      this.mode_select2("history_index")

      if (this.history_records && false) {
      } else {
        this.remote_get(this.app.info.put_path, { remote_action: "history_records_fetch" }, e => {
          if (e.history_records) {
            this.history_records = e.history_records.map(e => Object.assign({}, e, {question: new Question(e.question)}))
          }
        })
      }
    },

    clip_index_handle() {
      this.mode_select2("clip_index")

      if (this.clip_records && false) {
      } else {
        this.remote_get(this.app.info.put_path, { remote_action: "clip_records_fetch" }, e => {
          if (e.clip_records) {
            this.clip_records = e.clip_records.map(e => Object.assign({}, e, {question: new Question(e.question)}))
          }
        })
      }
    },

    mode_select2(tab_key) {
      this.tab_index2 = TabInfo2.fetch(tab_key).code
    },

    tab_change_handle2() {
      this.sound_play("click")
      this.app[this.current_tab_info2.handle_method_name]()
    },
  },

  computed: {
    TabInfo2() { return TabInfo2 },

    current_tab_info2() {
      return TabInfo2.fetch(this.tab_index2)
    },
  },
}
