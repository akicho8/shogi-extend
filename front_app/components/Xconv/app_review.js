import { ReviewValidationInfo } from "./models/review_validation_info.js"

export const app_review = {
  data() {
    return {
      done_record:  null,
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
    other_window_open_handle() {
      this.sound_play("click")
      // TODO: JS に Hash#slice はないんか？
      const { width, height } = this.done_record.convert_params.board_file_generator_params
      this.window_popup(this.done_record.browser_url, { width, height })
    },
    direct_link_handle() {
      this.sound_play("click")
      // window.location.href = this.done_record.browser_url
      // this.other_window_open(this.done_record.browser_url)
      this.url_open(this.done_record.browser_url, this.target_default)
    },
    download_handle() {
      this.sound_play("click")
      const url = this.$config.MY_SITE_URL + `/animation-files/${this.done_record.id}`
      window.location.href = url
    },
    json_show_handle() {
      this.sound_play("click")
      const url = this.$config.MY_SITE_URL + `/animation-files/${this.done_record.id}.json`
      window.location.href = url
    },
  },
  computed: {
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
