export const the_question_show_mod = {
  data() {
    return {
      overlay_record: null,
    }
  },

  methods: {
    overlay_record_set(question_id) {
      this.sound_play("click")
      this.http_get_command(this.app.info.put_path, { question_single_fetch: true, question_id: question_id }, e => {
        if (e.overlay_record) {
          this.overlay_record = e.overlay_record
        }
      })
    },

    board_close() {
      this.sound_play("click")
      this.overlay_record = null
    },
  },
}
