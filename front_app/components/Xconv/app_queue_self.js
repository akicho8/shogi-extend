export const app_queue_self = {
  data() {
    return {
      my_records: [],
    }
  },

  methods: {
    my_records_broadcasted(data) {
      this.my_records = data.my_records.map(e => new this.XconvRecord(this, e))
    },

    done_record_broadcasted(data) {
      this.done_record = new this.XconvRecord(this, data.done_record)
      if (data.noisy) {
        if (false) {
          this.sound_stop_all()
        }
        this.sound_play("click")
        if (this.done_record.successed_at) {
          this.toast_ok(`${this.done_record.id}番が完了しました`)
        }
        if (this.done_record.errored_at) {
          this.toast_ok(`${this.done_record.id}番が失敗しました`)
        }
      }
    }
  },
}
