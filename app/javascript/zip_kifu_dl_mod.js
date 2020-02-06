import MemoryRecord from 'js-memory-record'

class ZipKifuInfo extends MemoryRecord {
}

export default {
  data() {
    return {
      zip_dl_modal_p: false,
      zip_kifu_key: "kif",
    }
  },

  beforeCreate() {
    ZipKifuInfo.memory_record_reset(this.$options.zip_kifu_info)
  },

  methods: {
    zip_dl_modal_open_handle() {
      this.zip_dl_modal_p = true
    },

    zip_dl_run() {
      this.zip_dl_modal_p = false

      const params = {
        query:        this.query,
        zip_kifu_key: this.zip_kifu_key,
      }

      const url = `${this.$options.xhr_index_path}.zip?${this.url_build(params)}`
      this.self_window_open(url)
    },
  },

  computed: {
    ZipKifuInfo() { return ZipKifuInfo },
  },
}
