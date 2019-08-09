import dayjs from "dayjs"

export default {
  data() {
    return {
      memento_list: [],
    }
  },

  created() {
    this.memento_list_load()
  },

  methods: {
    memento_create() {
      this.memento_list.push({
        time: dayjs().format("YYYY-MM-DD HH:mm:ss"),
        summary: this.summary,
        enc_base64: this.enc_base64,
      })
      this.memento_list = _.takeRight(this.memento_list, 10)
      this.memento_list_save()
    },

    memento_restore(row) {
      this.data_restore_from_base64(row.enc_base64)
    },

    memento_list_load() {
      if (false) {
        this.memento_list_clear()
      }

      const base64 = localStorage.getItem(this.memento_list_storage_key)
      if (base64) {
        this.memento_list = this.base64_to_value(base64)
      }
    },

    memento_list_save() {
      localStorage.setItem(this.memento_list_storage_key, this.value_to_base64(this.memento_list))
    },

    memento_list_clear() {
      localStorage.removeItem(this.memento_list_storage_key)
      this.memento_list = []
    },
  },

  computed: {
    memento_list_storage_key() {
      return [this.local_storage_key, "log"].join("_")
    },
  },
}
