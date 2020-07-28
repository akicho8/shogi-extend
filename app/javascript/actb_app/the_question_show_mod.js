import the_question_show from "./the_question_show.vue"
import { Question } from "./models/question.js"

export const the_question_show_mod = {
  methods: {
    ov_question_url(id) {
      const url = new URL(location)
      url.searchParams.set("question_id", id)
      return url.toString()
    },

    ov_question_info_set(question_id) {
      this.sound_play("click")
      this.api_get("question_single_fetch", {question_id: question_id}, e => {
        if (e.ov_question_info) {
          const ov_question_info =  e.ov_question_info
          ov_question_info.question = new Question(ov_question_info.question)

          this.ov_question_show_modal(ov_question_info)
        }
      })
    },

    ov_question_show_modal(ov_question_info) {
      this.$ov_question_modal = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: { ov_question_info },
        animation: "",
        onCancel: () => this.sound_play("click"),
        fullScreen: true,
        canCancel: ["escape", "outside"],
        component: the_question_show,
      })
    },

    ov_question_modal_close() {
      if (this.$ov_question_modal) {
        this.$ov_question_modal.close()
        this.$ov_question_modal = null
      }
    },
  },
}
