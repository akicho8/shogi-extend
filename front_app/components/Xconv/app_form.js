import { LoopInfo          } from "./models/loop_info.js"
import { ViewpointInfo     } from "./models/viewpoint_info.js"
import { ThemeInfo         } from "./models/theme_info.js"
import { AnimationSizeInfo } from "./models/animation_size_info.js"
import { ParamInfo         } from "./models/param_info.js"
import { RecipeInfo    } from "./models/recipe_info.js"

const TWITTER_ASPECT_RATIO_MAX = 2.39  // Twitterでアップロードできるのは比率がこれ以下のとき

export const app_form = {
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// POST前
      body:               "",   // 棋譜
      loop_key:           null, // ループ
      animation_size_key: null, // 画像サイズ
      i_width:            null, // w
      i_height:           null, // h
      viewpoint_key:      null, // 視点
      theme_key:          null, // テーマ
      one_frame_duration:      null, // 着手秒数
      // video_fps:     null, // fps
      end_frames:         null, // 終了図だけ指定枚数ぶん停止
      sleep:              null, // 遅延(デバッグ用)
      raise_message:      null, // 例外メッセージ
      recipe_key:    null, // 変換先

      //////////////////////////////////////////////////////////////////////////////// POST後
      xconv_record: null, // POSTして変換待ちになっているレコード
      bs_error: null,     // エラー情報

      //////////////////////////////////////////////////////////////////////////////// レイアウト
      form2_show_p: false,
      form_tab_index: 0,
    }
  },

  created() {
    this.parmas_set_from_query()
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
      // // 開発時のホットリロードでは null.$refs になる
      // this.desktop_focus_to(this.$refs.XconvForm?.$refs.body.$refs?.textarea)
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
            this.xconv_record = new this.XconvRecord(this, xconv_record)
            this.toast_ok(`${this.xconv_record.id}番で予約しました`)
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
      console.log(this.animation_size_info)
      if (this.animation_size_info.key === "is_custom") {
      } else {
        this.i_width = this.animation_size_info.width
        this.i_height = this.animation_size_info.height
      }
    },

    parmas_set_from_query() {
      this.ParamInfo.values.forEach(e => {
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

    form2_show_toggle() {
      this.sound_play("click")
      this.form2_show_p = !this.form2_show_p
    },
  },
  computed: {
    TWITTER_ASPECT_RATIO_MAX() { return TWITTER_ASPECT_RATIO_MAX                             },
    LoopInfo()                 { return LoopInfo                                             },
    AnimationSizeInfo()        { return AnimationSizeInfo                                    },
    animation_size_info()      { return AnimationSizeInfo.fetch(this.animation_size_key)     },
    ParamInfo()                { return ParamInfo                                            },
    ViewpointInfo()            { return ViewpointInfo                                        },
    viewpoint_info()           { return ViewpointInfo.fetch(this.viewpoint_key)              },
    ThemeInfo()                { return ThemeInfo                                            },
    theme_info()               { return ThemeInfo.fetch(this.theme_key)                      },
    RecipeInfo()           { return RecipeInfo                                       },
    recipe_info()         { return this.base.RecipeInfo.fetch(this.recipe_key) },

    end_seconds() { return this.number_floor(this.one_frame_duration * this.end_frames, 2) },

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
          board_file_generator_params: {
            recipe_key: this.recipe_key,
            // for AnimationFormatter
            // animation_formatter_params: {
            loop_key: this.loop_key,
            one_frame_duration: this.one_frame_duration,
            // video_fps: this.video_fps,
            end_frames: this.end_frames,
            viewpoint: this.viewpoint_key,
            theme: this.theme_key,
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

    i_size_aspect_ratio_human() {
      let r = this.math_wh_gcd_aspect_ratio(this.i_width, this.i_height)
      if (r == null) {
        return "? : ?"
      }
      return r.map(e => this.number_floor(e, 2)).join(" : ")
    },

    i_size_danger_p() {
      return false

      let r = this.math_wh_normalize_aspect_ratio(this.i_width, this.i_height)
      if (r == null) {
        return true
      }
      return Math.max(...r) > TWITTER_ASPECT_RATIO_MAX
    },

    ////////////////////////////////////////////////////////////////////////////////

  },
}
