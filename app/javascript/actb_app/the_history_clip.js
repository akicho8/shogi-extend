export const the_history_clip = {
  data() {
    return {
      clip_records: null,
    }
  },

  methods: {
    clip_index_handle() {
      this.mode_select("clip_index")

      if (this.clip_records && false) {
      } else {
        this.http_get_command(this.app.info.put_path, { clip_records_fetch: true }, e => {
          if (e.clip_records) {
            this.clip_records = e.clip_records
          }
        })
      }
    },
  },
}
