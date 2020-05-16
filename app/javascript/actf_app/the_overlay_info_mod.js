export default {
  data() {
    return {
      overlay_info: null,
    }
  },

  methods: {
    overlay_info_set(question_id) {
      this.sound_play("click")
      this.http_get_command(this.app.info.put_path, { question_single_fetch: true, question_id: question_id }, e => {
        if (e.overlay_info) {
          this.overlay_info = e.overlay_info
        }
      })
    },

    board_close() {
      this.sound_play("click")
      this.overlay_info = null
    },
  },
}
