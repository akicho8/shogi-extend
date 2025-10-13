import QuizMakerModal from "./QuizMakerModal.vue"
import { Quiz } from "./quiz.js"
import { QuizTemplateInfo } from "./quiz_template_info.js"

export const mod_quiz_host = {
  data() {
    return {
      master_quiz: Quiz.create(),
    }
  },
  methods: {
    quiz_src_clear() {
      this.master_quiz = Quiz.create()
    },
    quiz_src_sample() {
      this.master_quiz = Quiz.sample
    },
    quiz_src_random_handle() {
      this.sfx_click()
      const quiz = QuizTemplateInfo.sample
      if (quiz) {
        this.master_quiz = quiz
        this.talk(this.master_quiz.subject)
      }
    },
    quiz_maker_handle() {
      this.master_quiz = this.master_quiz.dup() // id を更新する
      this.modal_card_open({component: QuizMakerModal})
    },
  },
  computed: {
    Quiz()             { return Quiz                                                }, // SbDebugFes.vue 用
    // quiz_new_p()       { return !this.quiz_persisted_p                              }, // 新しいお題か？
    // quiz_persisted_p() { return this.master_quiz.same_content_p(this.received_quiz) }, // 同じ内容か？(再送信か？)
  },
}
