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

    main_download_handle(record) {
      this.sound_play("click")
      window.location.href = record.rails_side_download_url
    },

    main_show_handle(record) {
      this.sound_play("click")
      this.window_popup(record.rails_side_inline_url, record.to_wh)
    },

    json_show_handle(record) {
      this.sound_play("click")
      this.other_window_open(record.rails_side_json_url)
    },

    other_window_direct_open_handle(record) {
      this.sound_play("click")
      this.window_popup(record.browser_url, record.to_wh)
    },

    secret_show_handle(record) {
      this.sound_play("click")
      this.url_open(record.browser_url, this.target_default)
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
