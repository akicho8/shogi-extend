export default {
  data() {
    return {
      history_records: null,
    }
  },
  methods: {
    history_index_handle() {
      this.mode_select("history_index")

      if (this.history_records && false) {
      } else {
        this.http_get_command(this.app.info.put_path, { history_records_fetch: true }, e => {
          if (e.history_records) {
            this.history_records = e.history_records
          }
        })
      }
    },
  },
}
