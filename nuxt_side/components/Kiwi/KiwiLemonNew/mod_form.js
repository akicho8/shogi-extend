import { LoopInfo            } from "../models/loop_info.js"
import { TurnEmbedInfo       } from "../models/turn_embed_info.js"
import { PieceFontWeightInfo } from "../models/piece_font_weight_info.js"
import { ViewpointInfo       } from "../models/viewpoint_info.js"
import { ColorThemeInfo      } from "../../models/color_theme_info.js"
import { AudioThemeInfo      } from "../models/audio_theme_info.js"
import { FactoryMethodInfo   } from "../models/factory_method_info.js"
import { RectSizeInfo        } from "../models/rect_size_info.js"
import { ParamInfo           } from "./models/param_info.js"
import { RecipeInfo          } from "../models/recipe_info.js"

import Big from "big.js"        // https://github.com/MikeMcl/big.js/

const TWITTER_ASPECT_RATIO_MAX = 2.39  // Twitterでアップロードできるのは比率がこれ以下のとき

export const mod_form = {
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// POST前
      body: "",                 // 棋譜
      loop_key:              null, // ループの有無(GIFの場合)
      turn_embed_key:        null, // 手数表示
      piece_font_weight_key: null, // 駒を太字にする条件
      rect_size_key:         null, // 画像サイズ
      rect_width:            null, // w
      rect_height:           null, // h
      viewpoint:             null, // 視点
      color_theme_key:       null, // 色テーマ
      audio_theme_key:       null, // 曲テーマ
      factory_method_key:    null, // 生成方法
      cover_text:            null, // 表紙文言
      video_crf:             null, // video品質レベル
      audio_bit_rate:        null, // 音声ビットレート
      main_volume:           null, // 音量
      page_duration:         null, // 1ページあたりの秒数
      end_duration:          null, // 終了図だけ指定枚数ぶん停止
      sleep:                 null, // 遅延(デバッグ用)
      raise_message:         null, // 例外メッセージ
      recipe_key:            null, // 変換先

      //////////////////////////////////////////////////////////////////////////////// POST後
      posted_record: null, // POSTして変換待ちになっているレコード
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
  //   // this.pc_data_set_by_query_or_default()
  //   // this.rect_width  = this.rect_width ?? this.rect_size_info.width
  //   // this.rect_height = this.rect_height ?? this.rect_size_info.height
  // },

  watch: {
    body() {
      this.bs_error = null
      this.posted_record = null
      this.done_record = null
    },
  },
  methods: {
    form_setup() {
      this.rect_width  = this.rect_width ?? this.rect_size_info.width
      this.rect_height = this.rect_height ?? this.rect_size_info.height
    },
    body_focus() {
      // // 開発時のホットリロードでは null.$refs になる
      // this.desktop_focus_to(this.$refs.KiwiLemonNewForm?.$refs.body.$refs?.textarea)
    },
    reset_handle() {
      this.sfx_click()
      this.body = ""

      this.response_hash = null
      this.done_record   = null
      this.posted_record = null
    },

    submit_handle() {
      this.done_record = null

      this.sfx_click()

      if (this.nuxt_login_required()) { return }

      if (this.bs_error) {
        this.error_show()
        return
      }

      if (this.$GX.blank_p(this.body)) {
        this.toast_warn("棋譜を入力しよう")
        return
      }

      this.app_log("動画作成●")

      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/kiwi/lemons/record_create.json", this.post_params).then(e => this.success_proc(e)).finally(() => {
        loading.close()
      })
    },

    success_proc(e) {
      // ../../../../app/controllers/api/kiwi/lemons_controller.rb
      if (e.bs_error) {
        this.bs_error = e.bs_error
        this.error_show()
      }
      if (e.error_message) {
        this.toast_ng(e.error_message)
      }
      if (e.response_hash) {
        this.response_hash = e.response_hash

        const posted_record = e.response_hash.posted_record
        if (posted_record) {
          this.posted_record = new this.Lemon(this, posted_record)
        }

        const message = this.response_hash.message
        if (message) {
          this.toast_ok(message)
        }

        const alert_message = this.response_hash.alert_message
        if (alert_message) {
          this.dialog_alert({
            hasIcon: true,
            type: "is-warning",
            title: "残念なお知らせ",
            message: alert_message,
          })
          this.$GX.delay_block(3, () => this.talk(alert_message))
        }
      }
    },

    error_show() {
      this.bs_error_message_dialog(this)
    },

    rect_size_key_input_handle(rect_size_key) {
      this.sfx_click()
      this.width_height_udpate()
    },

    width_height_udpate() {
      console.log(this.rect_size_info)
      if (this.rect_size_info.key === "is_rect_size_custom") {
      } else {
        this.rect_width = this.rect_size_info.width
        this.rect_height = this.rect_size_info.height
      }
    },

    adapter_handle() {
      this.sfx_click()
      const e = this.$router.resolve({
        name: "adapter",
        query: {
          body: this.body,
        },
      })
      this.other_window_open(e.href)
    },

    form2_show_toggle() {
      this.sfx_click()
      this.form2_show_p = !this.form2_show_p
    },

    //////////////////////////////////////////////////////////////////////////////// BGM ファイルアップロード

    xaudio_file_upload_handle(files) {
      if (files == null) {
        this.debug_alert("なぜか1つ上げて2つ目を上げようとしてダイアログキャンセルすると files が null で呼ばれる")
      } else {
        this.sfx_click()
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
      this.sfx_click()
      this.base.xaudio_list.splice(index, 1)
      // this.base.xaudio_list_for_v_model.splice(index, 1)
      this.toast_ok("削除しました")
    },

    // ドロップダウンを開閉するタイミング
    active_change_handle(e) {
      // 開いたときだけクリック音
      if (e) {
        this.sfx_click()
      } else {
        this.current_play_instance_stop()
      }
    },

    current_play_instance_stop() {
      if (this.current_play_instance) {
        this.current_play_instance.stop()
        this.current_play_instance = null
      }
    },

    // //////////////////////////////////////////////////////////////////////////////// 画像 ファイルアップロード
    //
    // ximage_file_upload_handle(files) {
    //   if (files == null) {
    //     this.debug_alert("なぜか1つ上げて2つ目を上げようとしてダイアログキャンセルすると files が null で呼ばれる")
    //   } else {
    //     this.sfx_click()
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
    //   this.sfx_click()
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
    //     this.sfx_click()
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
    //   this.sfx_click()
    //   this.base.u_bg_file = null
    //   this.toast_ok("削除しました")
    // },

    page_duration_set_by_fps(fps) {
      this.sfx_click()
      this.page_duration = 1.0 / fps
    },
    page_duration_set_by_value(v) {
      this.sfx_click()
      this.page_duration = v
    },
    page_duration_add(v) {
      this.sfx_click()
      this.page_duration = (new Big(this.page_duration)).plus(v).toNumber()
    },
    page_duration_mul(v) {
      this.sfx_click()
      this.page_duration = (new Big(this.page_duration)).times(v).toNumber()
    },
  },
  computed: {
    TWITTER_ASPECT_RATIO_MAX() { return TWITTER_ASPECT_RATIO_MAX                              },
    LoopInfo()                 { return LoopInfo                                              },
    loop_info()                { return LoopInfo.fetch(this.loop_key)                         },
    TurnEmbedInfo()            { return TurnEmbedInfo                                         },
    turn_embed_info()          { return TurnEmbedInfo.fetch(this.turn_embed_key)              },
    PieceFontWeightInfo()      { return PieceFontWeightInfo                                   },
    piece_font_weight_info()   { return PieceFontWeightInfo.fetch(this.piece_font_weight_key) },
    RectSizeInfo()             { return RectSizeInfo                                          },
    rect_size_info()           { return RectSizeInfo.fetch(this.rect_size_key)                },
    ParamInfo()                { return ParamInfo                                             },
    ViewpointInfo()            { return ViewpointInfo                                         },
    viewpoint_info()           { return ViewpointInfo.fetch(this.viewpoint)                   },
    ColorThemeInfo()           { return ColorThemeInfo                                        },
    color_theme_info()         { return ColorThemeInfo.fetch(this.color_theme_key)            },
    FactoryMethodInfo()        { return FactoryMethodInfo                                     },
    factory_method_info()      { return FactoryMethodInfo.fetch(this.factory_method_key)      },
    AudioThemeInfo()           { return AudioThemeInfo                                        },
    audio_theme_info()         { return AudioThemeInfo.fetch(this.audio_theme_key)            },
    RecipeInfo()               { return RecipeInfo                                            },
    recipe_info()              { return this.base.RecipeInfo.fetch(this.recipe_key)           },

    // end_seconds() { return this.$GX.number_floor(this.page_duration * this.end_duration, 2) },

    body_field_type() {
      if (this.bs_error) {
        return "is-danger"
      }
      if (this.posted_record) {
        return "is-success"
      }
    },
    post_params() {
      return {
        __ERROR_THEN_STATUS_200__: true, // 互換性のため

        // for Lemon
        body: this.body,

        // for Lemon#all_params
        all_params: {
          sleep: this.sleep,
          raise_message: this.raise_message,

          // パラメータの差異はなるべくここだけで吸収する
          media_builder_params: {
            //////////////////////////////////////// MediaBuilder で処理
            recipe_key: this.recipe_key,
            ...this.u_audio_file_if_enabled,
            ...this.u_image_file_if_enabled,
            //////////////////////////////////////// bioshogi まで伝わる
            loop_key:          this.loop_key,
            turn_embed_key:    this.turn_embed_key,
            page_duration:     this.page_duration,
            end_duration:      this.end_duration,
            viewpoint:         this.viewpoint,
            color_theme_key:   this.color_theme_key,
            audio_theme_key:   this.audio_theme_key,
            piece_font_weight_key:         this.piece_font_weight_key,
            factory_method_key: this.factory_method_key,
            cover_text:        this.cover_text,
            // bottom_text:       this.audio_theme_info.bottom_text,
            video_crf:         this.video_crf,
            audio_bit_rate:    this.audio_bit_rate,
            main_volume:       this.main_volume,
            width:             this.rect_width,
            height:            this.rect_height,
            // renderer_override_params: { // テーマの上書き
            //   ...this.piece_font_weight_info.to_params,
            // },
          },
        },
      }
    },

    u_audio_file_if_enabled() {
      if (this.audio_theme_info.key === "is_audio_theme_custom") {
        return {
          u_audio_file_a: this.u_audio_file_a,
          u_audio_file_b: this.u_audio_file_b,
        }
      }
    },

    u_image_file_if_enabled() {
      return {
        u_bg_file: this.u_bg_file,
        u_fg_file: this.u_fg_file,
        u_pt_file: this.u_pt_file,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    i_size_aspect_ratio_human() {
      let r = this.$GX.aspect_ratio_gcd(this.rect_width, this.rect_height)
      if (r == null) {
        return "? : ?"
      }
      return r.map(e => this.$GX.number_floor(e, 2)).join(" : ")
    },

    i_size_danger_p() {
      return false

      let r = this.$GX.aspect_ratio_normalize(this.rect_width, this.rect_height)
      if (r == null) {
        return true
      }
      return Math.max(...r) > TWITTER_ASPECT_RATIO_MAX
    },

    ////////////////////////////////////////////////////////////////////////////////

    fps_value() {
      if (this.page_duration > 0) {
        return this.$GX.number_round(1 / this.page_duration, 2)
      }
    },

    page_duration_message() {
      if (this.page_duration > 0) {
        return `${this.fps_value}fps ${this.page_duration_bpm120}BPM`
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    page_duration_step() {
      if (this.page_duration <= 0.1) {
        return 0.1
      } else {
        return 0.1
      }
    },

    page_duration_bpm120() {
      return (new Big(this.page_duration)).times(120).toNumber()
    },

    page_duration_bpm60() {
      return (new Big(this.page_duration)).times(60).toNumber()
    },
  },
}
