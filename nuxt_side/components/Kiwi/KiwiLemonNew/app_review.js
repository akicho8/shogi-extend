import { ValidationInfo } from "../models/validation_info.js"
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
      // this.kiwi_info    = null
      this.lemon = null
      this.done_record = null
      // this.lemon   = null
    },

    __main_download_handle2(record) {
      this.sound_play("click")
      this.$router.push({name: "video-books-edit", query: { lemon_id: record.id }})
    },

    __main_download_handle(record) {
      this.sound_play("click")
      window.location.href = record.rails_side_download_url
    },

    __main_show_handle(record) {
      this.sound_play("click")
      this.window_popup(record.rails_side_inline_url, record.to_wh)
    },

    __json_show_handle(record) {
      this.sound_play("click")
      this.other_window_open(record.rails_side_json_url)
    },

    __load_handle(record) {
      this.sound_play("click")
      this.done_record = record
    },

    // 未使用
    __other_window_direct_open_handle(record) {
      this.sound_play("click")
      this.window_popup(record.browser_path, record.to_wh)
    },

    __secret_show_handle(record) {
      this.sound_play("click")
      this.url_open(record.browser_path, this.target_default)
    },
  },
  computed: {
    review_error_messages() {
      const list = []
      if (this.done_record) {
        if (this.done_record.successed_at) {
          if (this.done_record.recipe_info.media_p) {
            ValidationInfo.values.forEach(e => {
              if (e.environment == null || e.environment.includes(this.$config.STAGE)) {
                const valid_p = e.validate(this, this.done_record)
                if (valid_p != null) {
                  const item = {
                    valid_p: valid_p,
                    should_be: e.should_be(this),
                    human_value: e.human_value(this, this.done_record),
                  }
                  if (valid_p) {
                    item.icon_args = { icon: "check", type: "is-success" }
                  } else {
                    item.icon_args = e.icon_args
                  }
                  list.push(item)
                }
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
