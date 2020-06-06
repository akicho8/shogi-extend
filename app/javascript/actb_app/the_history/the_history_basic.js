import { Question} from "../models/question.js"

export const the_history_basic = {
  data() {
    return {
      history_records: null,
    }
  },
  methods: {
    history_index_handle() {
      this.mode_select("history_index")

      if (this.history_records && false) {
      } else {
        this.remote_get(this.app.info.put_path, { history_records_fetch: true }, e => {
          if (e.history_records) {
            this.history_records = e.history_records.map(e => Object.assign({}, e, {question: new Question(e.question)}))
          }
        })
      }
    },
  },
}
