import { Question} from "../models/question.js"

export const the_history_clip = {
  data() {
    return {
      clip_records: null,
    }
  },

  methods: {
    clip_index_handle() {
      this.mode_select("clip_index")

      if (this.clip_records && false) {
      } else {
        this.remote_get(this.app.info.put_path, { remote_action: "clip_records_fetch" }, e => {
          if (e.clip_records) {
            this.clip_records = e.clip_records.map(e => Object.assign({}, e, {question: new Question(e.question)}))
          }
        })
      }
    },
  },
}
