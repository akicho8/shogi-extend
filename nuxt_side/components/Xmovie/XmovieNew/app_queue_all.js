export const app_queue_all = {
  data() {
    return {
      xmovie_info: null,
    }
  },

  methods: {
    // 変換状況を受けとる
    xmovie_record_list_broadcasted(data) {
      this.xmovie_info = data
      this.xmovie_info.xmovie_records = this.xmovie_info.xmovie_records.map(e => new this.XmovieRecord(this, e))
    },
  },
}
