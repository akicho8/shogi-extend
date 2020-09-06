import dayjs from "dayjs"

export default {
  data() {
    return {
      browser_setting: null,    // この変数に入ってるものはまとめてブラウザに保存する
    }
  },

  created() {
    this.browser_setting_load()
  },

  watch: {
    browser_setting: { handler() { this.browser_setting_save() }, deep: true, },

    "browser_setting.sound_silent_p"(v, old) {
      this.sound_silent_p = v
      if (old != null) {
        if (v) {
          this.notice("もうしゃべりません")
        } else {
          this.notice("しゃべります")
        }
      }
    },
  },

  methods: {
    browser_setting_load() {
      let base64 = null
      if (typeof localStorage !== 'undefined') {
        base64 = localStorage.getItem(this.browser_setting_storage_key)
      }
      let hash = {}
      if (base64) {
        hash = this.base64_to_value(base64)
      }
      this.browser_setting = {}
      this.$set(this.browser_setting, "sound_silent_p", (hash["sound_silent_p"] != null) ? hash["sound_silent_p"] : false)
    },

    browser_setting_save() {
      console.log(`browser_setting_save: ${JSON.stringify(this.browser_setting)}`)
      localStorage.setItem(this.browser_setting_storage_key, this.value_to_base64(this.browser_setting))
    },

    browser_setting_reset() {
      localStorage.removeItem(this.browser_setting_storage_key)
      this.browser_setting = null
      this.browser_setting_load()
    },
  },

  computed: {
    browser_setting_storage_key() {
      return [this.ls_key, "browser_setting"].join("_")
    },
  },
}
