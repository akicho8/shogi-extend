
import { Question } from "./models/question.js"
import ActbQuestionShow from "./ActbQuestionShow.vue"

export const application_question_show = {
  methods: {
    ov_question_url(id) {
      const params = new URLSearchParams()
      params.set("question_id", id)
      return `${this.$config.MY_SITE_URL}/training?${params}`
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
      this.$ov_question_modal = this.modal_card_open({
        component: ActbQuestionShow,
        fullScreen: true,
        props: {
          ov_question_info: ov_question_info,
          base: this.base,
        },
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
