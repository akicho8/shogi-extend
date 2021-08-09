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
      const { width, height } = this.done_record.convert_params.board_binary_generator_params
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
      let v = null
      if (this.done_record && this.done_record.successed_at) {
        {
          const v = this.done_record_stream.pix_fmt
          if (v) {
            if (v !== "yuv420p") {
              list.push(`ピクセルフォーマットが yuv420p ではない : ${v}`)
            }
          }
        }

        {
          const max = 140
          let v = this.done_record_stream.duration
          if (v) {
            v = Number(v)
            if (v > max) {
              list.push(`長さが${max}秒を超えている : ${v}秒`)
            }
          }
        }

        {
          const max_kb = 512
          const one_kb = 1024 * 1024
          const v = this.done_record.file_size
          if (v >= max_kb * one_kb) {
            list.push(`ファイルサイズが512MBを超えている : ${v / one_kb}MB`)
          }
        }

        {
          const v = this.math_wh_normalize_aspect_ratio(this.i_width, this.i_height)
          if (v) {
            const max = Math.max(...v)
            if (max > this.TWITTER_ASPECT_RATIO_MAX) {
              list.push(`縦横比が大きすぎる : ${v.join(":")}`)
            }
          }
        }
      }
      return this.presence(list)
    }
  },
}
