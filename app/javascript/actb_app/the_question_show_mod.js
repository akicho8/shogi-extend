import the_question_show from "./the_question_show.vue"
import { Question } from "./models/question.js"

export const the_question_show_mod = {
  methods: {
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
      const modal_instance = this.$buefy.modal.open({
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
  },
}
