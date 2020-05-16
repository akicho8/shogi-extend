export default {
  data() {
    return {
      overlay_question: null,
    }
  },

  methods: {
    current_question_set(question_id) {
      this.sound_play("click")
      this.http_get_command(this.app.info.put_path, { question_single_fetch: true, question_id: question_id }, e => {
        if (e.question) {
          this.overlay_question = e.question
        }
      })
    },

    board_close() {
      this.sound_play("click")
      this.overlay_question = null
    },
  },
}
