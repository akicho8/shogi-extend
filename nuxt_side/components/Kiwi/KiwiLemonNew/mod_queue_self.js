export const mod_queue_self = {
  data() {
    return {
      my_records: [],
      progress_info: null,
    }
  },

  methods: {
    kiwi_my_lemons_singlecasted(data) {
      this.my_records = data.my_records.map(e => new this.Lemon(this, e))
    },

    kiwi_done_lemon_singlecasted(data) {
      this.done_record = new this.Lemon(this, data.done_record)
      this.progress_info = null
      if (data.noisy) {
        if (false) {
          this.$sound.stop_all()
        }
        if (this.done_record.successed_at) {
          if (false) {
            this.$sound.play("se_niwatori")
            this.$gs.delay_block(1.5, () => this.toast_ok(`${this.done_record.id}番が完了しました`))
          } else {
            this.$sound.play("o")
            this.toast_ok(`${this.done_record.id}番が完了しました`)
          }
        }
        if (this.done_record.errored_at) {
          this.$sound.play("x")
          this.toast_ok(`${this.done_record.id}番が失敗しました`)
        }
      }
    },

    kiwi_progress_singlecasted(data) {
      console.log(data.log)
      this.progress_info = data
    },
  },
}
