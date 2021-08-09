import { LoopInfo } from "../models/loop_info.js"
import { ViewpointInfo } from "../models/viewpoint_info.js"
import { AnimationSizeInfo } from "./models/animation_size_info.js"
import { FormQueryInfo } from "./models/form_query_info.js"
import { XoutFormatInfo } from "../models/xout_format_info.js"

const TWITTER_RATIO_MAX = 2.39  // Twitterでアップロードできるのは比率がこれ以下のとき

export const app_form = {
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// POST前
      body:               null, // 棋譜
      loop_key:           null, // ループ
      animation_size_key: null, // 画像サイズ
      i_width:            null, // w
      i_height:           null, // h
      viewpoint_key:      null, // 視点
      delay_per_one:      null, // 表示秒数/1枚
      end_frames:         null, // 終了図だけ指定枚数ぶん停止
      sleep:              null, // 遅延(デバッグ用)
      raise_message:      null, // 例外メッセージ
      xout_format_key:    null, // 変換先

      //////////////////////////////////////////////////////////////////////////////// POST後
      xconv_record: null, // POSTして変換待ちになっているレコード
      bs_error: null,     // エラー情報
    }
  },

  created() {
    this.form_params_set_form_query()
    this.i_width  = this.i_width ?? this.animation_size_info.width
    this.i_height = this.i_height ?? this.animation_size_info.height
  },

  watch: {
    body() {
      if (this.sns_login_required()) {
        return
      }
      this.bs_error = null
      this.xconv_record = null
      this.done_record = null
    },
    // i_width() {
    //   this.animation_size_key = "is_custom"
    // },
  },
  mounted() {
  },
  methods: {
    body_focus() {
      // 開発時のホットリロードでは null.$refs になる
      this.desktop_focus_to(this.$refs.XconvForm?.$refs.body.$refs?.textarea)
    },
    reset_handle() {
      this.sound_play("click")
      this.body = ""

      this.response_hash   = null
      // this.xconv_info    = null
      this.done_record = null
      this.xconv_record   = null

      // this.body_focus()
    },
    //- app_open(url) {
    //-   this.url_open(url, this.target_default)
    //- },

    submit_handle() {
      this.done_record = null

      //- this.record_fetch(() => {
      //-   this.toast_ok(`${this.record.turn_max}手の棋譜として読み取りました`)
      //- })
      this.sound_play("click")

      if (this.sns_login_required()) {
        return
      }

      if (this.bs_error) {
        this.error_show()
        return
      }

      if (this.blank_p(this.body) && false) {
        this.toast_warn("棋譜を入力してください")
        return
      }

      this.ga_click("アニメーション変換●")

      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/xconv/record_create.json", this.post_params).then(e => {
        // ../../../app/controllers/api/xconvs_controller.rb
        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.error_show()
        }
        if (e.error_message) {
          this.toast_ng(e.error_message)
        }
        if (e.response_hash) {
          this.response_hash = e.response_hash
          const xconv_record = e.response_hash.xconv_record
          if (xconv_record) {
            this.xconv_record = xconv_record
            this.toast_ok("予約しました")
          }
        }
      }).finally(() => {
        loading.close()
      })
    },

    error_show() {
      this.bs_error_message_dialog(this.bs_error)
    },

    animation_size_key_input_handle(animation_size_key) {
      this.sound_play("click")
      this.width_height_udpate()
    },

    width_height_udpate() {
      this.i_width = this.animation_size_info.width
      this.i_height = this.animation_size_info.height
    },

    form_params_set_form_query() {
      this.FormQueryInfo.values.forEach(e => {
        let v = this.$route.query[e.key]
        if (this.present_p(v)) {
          if (e.type === "integer") {
            v = Math.trunc(Number(v))
          } else if (e.type === "float") {
            v = Number(v)
          }
          this.$data[e.key] = v
        } else {
          this.$data[e.key] = e.default
        }
      })
    },

    share_board_handle() {
      this.sound_play("click")
      const e = this.$router.resolve({
        name: "share-board",
        query: {
          body: this.body,
          abstract_viewpoint: this.viewpoint_key,
        },
      })
      this.other_window_open(e.href)
    },

    adapter_handle() {
      this.sound_play("click")
      const e = this.$router.resolve({
        name: "adapter",
        query: {
          body: this.body,
        },
      })
      this.other_window_open(e.href)
    },
  },
  computed: {
    LoopInfo()            { return LoopInfo            },
    AnimationSizeInfo()   { return AnimationSizeInfo   },
    animation_size_info() { return AnimationSizeInfo.fetch(this.animation_size_key)   },
    FormQueryInfo()   { return FormQueryInfo   },
    form_query_info() { return FormQueryInfo.fetch(this.form_query_key)   },
    ViewpointInfo()   { return ViewpointInfo   },
    viewpoint_info() { return ViewpointInfo.fetch(this.viewpoint_key)   },
    XoutFormatInfo() { return XoutFormatInfo },

    body_field_type() {
      if (this.bs_error) {
        return "is-danger"
      }
      if (this.xconv_record) {
        return "is-success"
      }
    },
    form_show_p() {
      return true
      // return this.blank_p(this.xconv_record)
    },
    processing_p() {
      return this.xconv_record && !this.done_record
    },
    post_params() {
      return {
        // for XconvRecord
        body: this.body,

        // for XconvRecord#convert_params
        xconv_record_params: {
          sleep: this.sleep,
          raise_message: this.raise_message,

          // パラメータの差異はなるべくここだけで吸収する
          board_binary_generator_params: {
            xout_format_key: this.xout_format_key,
            // for AnimationFormatter
            // animation_formatter_params: {
            loop_key: this.loop_key,
            delay_per_one: this.delay_per_one,
            end_frames: this.end_frames,
            viewpoint: this.viewpoint_key,
            // width: this.animation_size_info.width,
            // height: this.animation_size_info.height,
            width: this.i_width,
            height: this.i_height,
            // },
          },
        },
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    i_size_ratio_human() {
      let r = this.math_wh_gcd_ratio(this.i_width, this.i_height)
      if (r == null) {
        return "? : ?"
      }
      return r.map(e => this.number_floor(e, 2)).join(" : ")
    },

    i_size_danger_p() {
      let r = this.math_wh_normalize_ratio(this.i_width, this.i_height)
      if (r == null) {
        return true
      }
      return Math.max(...r) > TWITTER_RATIO_MAX
    },

    ////////////////////////////////////////////////////////////////////////////////

  },
}
