import { ValidationInfo } from "./models/validation_info.js"
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
    review_error_messages() {
      const list = []
      if (this.done_record) {
        if (this.done_record.successed_at) {
          if (this.done_record.recipe_info.media_p) {
            ValidationInfo.values.forEach(e => {
              const valid_p = e.validate(this, this.done_record)
              if (valid_p == null) {
              } else {
                list.push({
                  valid_p: valid_p,
                  should_be: e.should_be(this),
                  human_value: e.human_value(this, this.done_record),
                })
              }
            })
          }
        }
      }
      // return this.presence(list.flat())
      return list
    },

    review_error_messages_valid_p() {
      return this.review_error_messages.every(e => e.valid_p)
    }
  },
}
