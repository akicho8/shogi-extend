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

      const url = this.legacy_url_build(this.$options.xhr_index_path, params)
      this.url_open(url)
    },
  },

  computed: {
    ZipKifuInfo() { return ZipKifuInfo },
  },
}
