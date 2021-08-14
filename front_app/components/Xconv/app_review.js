import { ReviewValidationInfo } from "./models/review_validation_info.js"
import _ from "lodash"

export const app_review = {
  data() {
    return {
      done_record: null,
    }
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      // this.body = ""

      // this.response_hash   = null
      // this.xconv_info    = null
      this.xconv_record = null
      this.done_record = null
      // this.xconv_record   = null
    },

    send_file_handle(record, disposition) {
      this.sound_play("click")
      window.location.href = this.xconv_record_rails_side_url(record, {disposition})
    },

    json_show_handle(record) {
      this.sound_play("click")
      const url = this.$config.MY_SITE_URL + `/animation-files/${record.id}.json`
      window.location.href = url
    },

    other_window_direct_open_handle(record) {
      this.sound_play("click")
      const { width, height } = record.convert_params.board_file_generator_params
      this.window_popup(record.browser_url, { width, height })
    },

    other_window_open_handle(record) {
      this.sound_play("click")
      const { width, height } = record.convert_params.board_file_generator_params
      this.window_popup(this.xconv_record_rails_side_url(record), { width, height })
    },

    direct_link_handle(record) {
      this.sound_play("click")
      // window.location.href = this.done_record.browser_url
      // this.other_window_open(this.done_record.browser_url)
      this.url_open(record.browser_url, this.target_default)
    },

    // 拡張子をつけないと JSON を返してしまう
    xconv_record_rails_side_url(record, params = {}) {
      const key = record.convert_params.board_file_generator_params.xout_format_key
      const info = this.XoutFormatInfo.fetch(key)
      const url_base = this.$config.MY_SITE_URL + `/animation-files/${record.id}.${info.real_ext}`
      const url = new URL(url_base)
      _.each(params, (v, k) => url.searchParams.set(k, v))
      return url.toString()
    },
  },
  computed: {
    // ↓まぎらわしい。このコンポーネント内の done_record に対する情報
    done_xout_format_key() { return this.done_record.convert_params.board_file_generator_params.xout_format_key },
    done_xout_format_info() { return this.XoutFormatInfo.fetch(this.done_xout_format_key) },

    done_record_stream() {
      const streams = this.done_record?.ffprobe_info?.direct_format?.streams || []
      return streams[0] || {}
    },

    review_error_messages() {
      const list = []
      if (this.done_record && this.done_record.successed_at) {
        ReviewValidationInfo.values.forEach(e => {
          const errors = e.validate(this)
          console.log(errors)
          if (this.present_p(errors)) {
            list.push(errors)
          }
        })
      }
      return this.presence(list.flat())
    }
  },
}
