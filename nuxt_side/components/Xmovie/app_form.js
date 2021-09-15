import { LoopInfo          } from "./models/loop_info.js"
import { XfontInfo          } from "./models/xfont_info.js"
import { ViewpointInfo     } from "./models/viewpoint_info.js"
import { ColorThemeInfo    } from "./models/color_theme_info.js"
import { AudioThemeInfo    } from "./models/audio_theme_info.js"
import { MediaFactoryInfo  } from "./models/media_factory_info.js"
import { AnimationSizeInfo } from "./models/animation_size_info.js"
import { ParamInfo         } from "./models/param_info.js"
import { RecipeInfo        } from "./models/recipe_info.js"

import Big from "big.js"        // https://github.com/MikeMcl/big.js/

const TWITTER_ASPECT_RATIO_MAX = 2.39  // Twitterでアップロードできるのは比率がこれ以下のとき

export const app_form = {
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// POST前
      body: "",                     // 棋譜
      loop_key:               null, // ループの有無(GIFの場合)
      xfont_key:              null, // 駒を太字にする条件
      animation_size_key:     null, // 画像サイズ
      img_width:              null, // w
      img_height:             null, // h
      viewpoint_key:          null, // 視点
      color_theme_key:        null, // 色テーマ
      audio_theme_key:        null, // 曲テーマ
      media_factory_key:      null, // 生成方法
      cover_text:             null, // 表紙文言
      video_crf:              null, // video品質レベル
      audio_bit_rate:         null, // 音声ビットレート
      one_frame_duration_sec: null, // 1手N秒
      end_duration_sec:       null, // 終了図だけ指定枚数ぶん停止
      sleep:                  null, // 遅延(デバッグ用)
      raise_message:          null, // 例外メッセージ
      recipe_key:             null, // 変換先

      //////////////////////////////////////////////////////////////////////////////// POST後
      xmovie_record: null, // POSTして変換待ちになっているレコード
      bs_error:      null, // エラー情報

      //////////////////////////////////////////////////////////////////////////////// レイアウト
      form2_show_p: false,
      form_tab_index: 0,

      //////////////////////////////////////////////////////////////////////////////// ファイルアップロード
      xaudio_list: [],
      xaudio_list_for_v_model: [], // b-upload の動作確認用
      current_play_instance: null, // 最後に再生した Howl のインスタンス

      //////////////////////////////////////////////////////////////////////////////// 背景画像
      u_audio_file_a: null,
      u_audio_file_b: null,

      //////////////////////////////////////////////////////////////////////////////// 背景画像
      u_bg_file: null,
      u_fg_file: null,
      u_pt_file: null,
    }
  },

  // created() {
  //   // this.data_set_by_query_or_default()
  //   // this.img_width  = this.img_width ?? this.animation_size_info.width
  //   // this.img_height = this.img_height ?? this.animation_size_info.height
  // },

  watch: {
    body() {
      if (this.sns_login_required()) {
        return
      }
      this.bs_error = null
      this.xmovie_record = null
      this.done_record = null
    },
  },
  methods: {
    form_setup() {
      this.img_width  = this.img_width ?? this.animation_size_info.width
      this.img_height = this.img_height ?? this.animation_size_info.height
    },
    body_focus() {
      // // 開発時のホットリロードでは null.$refs になる
      // this.desktop_focus_to(this.$refs.XmovieForm?.$refs.body.$refs?.textarea)
    },
    reset_handle() {
      this.sound_play("click")
      this.body = ""

      this.response_hash   = null
      // this.xmovie_info    = null
      this.done_record = null
      this.xmovie_record   = null

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

      this.ga_click("動画生成●")

      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/xmovie/record_create.json", this.post_params).then(e => {
        // ../../../app/controllers/api/xmovies_controller.rb
        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.error_show()
        }
        if (e.error_message) {
          this.toast_ng(e.error_message)
        }
        if (e.response_hash) {
          this.response_hash = e.response_hash
          const xmovie_record = e.response_hash.xmovie_record
          if (xmovie_record) {
            this.xmovie_record = new this.XmovieRecord(this, xmovie_record)
            this.toast_ok(`${this.xmovie_record.id}番で予約しました`)
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
        this.img_width = this.animation_size_info.width
        this.img_height = this.animation_size_info.height
      }
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

    //////////////////////////////////////////////////////////////////////////////// BGM ファイルアップロード

    xaudio_file_upload_handle(files) {
      if (files == null) {
        this.debug_alert("なぜか1つ上げて2つ目を上げようとしてダイアログキャンセルすると files が null で呼ばれる")
      } else {
        this.sound_play("click")
        files.forEach(file => {
          const reader = new FileReader()
          reader.addEventListener("load", () => {
            this.xaudio_list.push({
              attributes: {
                name: file.name,
                size: file.size,
                type: file.type,
              },
              url: reader.result,
            })
            this.toast_ok(`アップロードしました`)
          }, false)
          reader.readAsDataURL(file)
        })
      }
    },

    xaudio_list_delete_at(index) {
      this.sound_play("click")
      this.base.xaudio_list.splice(index, 1)
      // this.base.xaudio_list_for_v_model.splice(index, 1)
      this.toast_ok("削除しました")
    },

    // ドロップダウンを開閉するタイミング
    active_change_handle(e) {
      // 開いたときだけクリック音
      if (e) {
        this.sound_play('click')
      } else {
        if (this.current_play_instance) {
          this.current_play_instance.stop()
          this.current_play_instance = null
        }
      }
    },

    // //////////////////////////////////////////////////////////////////////////////// 画像 ファイルアップロード
    //
    // ximage_file_upload_handle(files) {
    //   if (files == null) {
    //     this.debug_alert("なぜか1つ上げて2つ目を上げようとしてダイアログキャンセルすると files が null で呼ばれる")
    //   } else {
    //     this.sound_play("click")
    //     files.forEach(file => {
    //       const reader = new FileReader()
    //       reader.addEventListener("load", () => {
    //         this.u_bg_file.push({
    //           attributes: {
    //             name: file.name,
    //             size: file.size,
    //             type: file.type,
    //           },
    //           url: reader.result,
    //         })
    //         this.toast_ok(`アップロードしました`)
    //       }, false)
    //       reader.readAsDataURL(file)
    //     })
    //   }
    // },
    //
    // u_bg_file_delete_at(index) {
    //   this.sound_play("click")
    //   this.base.u_bg_file.splice(index, 1)
    //   // this.base.u_bg_file_for_v_model.splice(index, 1)
    //   this.toast_ok("削除しました")
    // },

    // ximage_one_file_upload_handle(file) {
    //   if (file == null) {
    //   } else {
    //     // if (files == null) {
    //     //   this.debug_alert("なぜか1つ上げて2つ目を上げようとしてダイアログキャンセルすると files が null で呼ばれる")
    //     // } else {
    //     this.sound_play("click")
    //     // files.forEach(file => {
    //     const reader = new FileReader()
    //     reader.addEventListener("load", () => {
    //       this.u_bg_file = {
    //         attributes: {
    //           name: file.name,
    //           size: file.size,
    //           type: file.type,
    //         },
    //         url: reader.result,
    //       }
    //       this.toast_ok(`アップロードしました`)
    //     }, false)
    //     reader.readAsDataURL(file)
    //   }
    // },
    //
    // ximage_one_delete_handle() {
    //   this.sound_play("click")
    //   this.base.u_bg_file = null
    //   this.toast_ok("削除しました")
    // },

    one_frame_duration_sec_set_by_fps(fps) {
      this.sound_play("click")
      this.one_frame_duration_sec = 1.0 / fps
    },
    one_frame_duration_sec_set_by_value(v) {
      this.sound_play("click")
      this.one_frame_duration_sec = v
    },
    one_frame_duration_sec_add(v) {
      this.sound_play("click")
      this.one_frame_duration_sec = (new Big(this.one_frame_duration_sec)).plus(v).toNumber()
    },
    one_frame_duration_sec_mul(v) {
      this.sound_play("click")
      this.one_frame_duration_sec = (new Big(this.one_frame_duration_sec)).times(v).toNumber()
    },
  },
  computed: {
    TWITTER_ASPECT_RATIO_MAX() { return TWITTER_ASPECT_RATIO_MAX                         },
    LoopInfo()                 { return LoopInfo                                         },
    loop_info()                { return LoopInfo.fetch(this.loop_key)                    },
    XfontInfo()                 { return XfontInfo                                         },
    xfont_info()                { return XfontInfo.fetch(this.xfont_key)                    },
    AnimationSizeInfo()        { return AnimationSizeInfo                                },
    animation_size_info()      { return AnimationSizeInfo.fetch(this.animation_size_key) },
    ParamInfo()                { return ParamInfo                                        },
    ViewpointInfo()            { return ViewpointInfo                                    },
    viewpoint_info()           { return ViewpointInfo.fetch(this.viewpoint_key)          },
    ColorThemeInfo()           { return ColorThemeInfo                                   },
    color_theme_info()         { return ColorThemeInfo.fetch(this.color_theme_key)       },
    MediaFactoryInfo()           { return MediaFactoryInfo                                   },
    media_factory_info()         { return MediaFactoryInfo.fetch(this.media_factory_key)       },
    AudioThemeInfo()           { return AudioThemeInfo                                   },
    audio_theme_info()         { return AudioThemeInfo.fetch(this.audio_theme_key)       },
    RecipeInfo()               { return RecipeInfo                                       },
    recipe_info()              { return this.base.RecipeInfo.fetch(this.recipe_key)      },

    // end_seconds() { return this.number_floor(this.one_frame_duration_sec * this.end_duration_sec, 2) },

    body_field_type() {
      if (this.bs_error) {
        return "is-danger"
      }
      if (this.xmovie_record) {
        return "is-success"
      }
    },
    form_show_p() {
      return true
      // return this.blank_p(this.xmovie_record)
    },
    processing_p() {
      return this.xmovie_record && !this.done_record
    },
    post_params() {
      return {
        // for XmovieRecord
        body: this.body,

        // for XmovieRecord#convert_params
        xmovie_record_params: {
          sleep: this.sleep,
          raise_message: this.raise_message,

          // パラメータの差異はなるべくここだけで吸収する
          board_file_generator_params: {
            //////////////////////////////////////// BoardFileGenerator で処理
            recipe_key: this.recipe_key,
            ...this.u_audio_file_if_enabled,
            ...this.image_file_if_enabled,
            //////////////////////////////////////// bioshogi まで伝わる
            loop_key:               this.loop_key,
            one_frame_duration_sec: this.one_frame_duration_sec,
            end_duration_sec:       this.end_duration_sec,
            viewpoint:              this.viewpoint_key,
            color_theme_key:        this.color_theme_key,
            audio_theme_key:        this.audio_theme_key,
            media_factory_key:      this.media_factory_key,
            cover_text:             this.cover_text,
            video_crf:              this.video_crf,
            audio_bit_rate:            this.audio_bit_rate,
            width:                  this.img_width,
            height:                 this.img_height,
            renderer_override_params: { // テーマの上書き
              ...this.xfont_info.to_params,
            },
          },
        },
      }
    },

    u_audio_file_if_enabled() {
      if (this.audio_theme_info.key === "audio_theme_custom") {
        return {
          u_audio_file_a: this.u_audio_file_a,
          u_audio_file_b: this.u_audio_file_b,
        }
      }
    },

    image_file_if_enabled() {
      return {
        u_bg_file: this.u_bg_file,
        u_fg_file: this.u_fg_file,
        u_pt_file: this.u_pt_file,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    i_size_aspect_ratio_human() {
      let r = this.math_wh_gcd_aspect_ratio(this.img_width, this.img_height)
      if (r == null) {
        return "? : ?"
      }
      return r.map(e => this.number_floor(e, 2)).join(" : ")
    },

    i_size_danger_p() {
      return false

      let r = this.math_wh_normalize_aspect_ratio(this.img_width, this.img_height)
      if (r == null) {
        return true
      }
      return Math.max(...r) > TWITTER_ASPECT_RATIO_MAX
    },

    ////////////////////////////////////////////////////////////////////////////////

    fps_value() {
      if (this.one_frame_duration_sec > 0) {
        return this.number_round(1 / this.one_frame_duration_sec, 2)
      }
    },

    one_frame_duration_sec_message() {
      if (this.one_frame_duration_sec > 0) {
        return `${this.fps_value}fps ${this.one_frame_duration_sec_bpm120}BPM`
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    one_frame_duration_sec_step() {
      if (this.one_frame_duration_sec <= 0.1) {
        return 0.1
      } else {
        return 0.1
      }
    },

    one_frame_duration_sec_bpm120() {
      return (new Big(this.one_frame_duration_sec)).times(120).toNumber()
    },

    one_frame_duration_sec_bpm60() {
      return (new Big(this.one_frame_duration_sec)).times(60).toNumber()
    },
  },
}
