import { DotSfen } from "@/components/models/dot_sfen.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { KifuVo } from "@/components/models/kifu_vo.js"
const TinyURL = require("tinyurl")
import _ from "lodash"

export const app_urls = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    room_url_copy_handle() {
      if (this.if_room_is_empty()) { return }

      this.__assert__(this.present_p(this.room_code), "this.present_p(this.room_code)")
      if (this.blank_p(this.room_code)) {
        // ここは通らないはず
        this.$sound.play_click()
        this.toast_warn("まだ合言葉を設定してません")
        return
      }

      this.sidebar_p = false
      this.$sound.play_click()
      this.clipboard_copy({text: this.room_url, success_message: "部屋のリンクをコピーしました"})
    },

    // 「棋譜コピー (リンク)」
    current_url_copy_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.clipboard_copy({text: this.current_url, success_message: "棋譜再生用のURLをコピーしました"})
    },

    // 「短縮URLのコピー」
    async current_url_short_copy_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      const url = await TinyURL.shorten(this.current_url)
      this.clipboard_copy({text: url, success_message: "棋譜再生用の短縮URLをコピーしました"})
    },

    other_app_click_handle(app_name) {
      this.sidebar_p = false
      this.$sound.play_click()
      this.ga_click(app_name)
      this.remote_notify({emoji: ":外部アプリ:", subject: "共有将棋盤→外部アプリ起動", body: app_name})

      this.shared_al_add({
        label: `${app_name}起動`,
        message: `${app_name}を起動しました`,
        // message_except_self: false,
        sfen: this.current_sfen,
        turn: this.current_turn,
      })
    },

    // ../../../app/controllers/share_boards_controller.rb の current_og_image_path と一致させること
    // AbstractViewpointKeySelectModal から新しい abstract_viewpoint が渡されるので params で上書きする
    url_merge(params = {}) {
      return this.url_for({...this.current_url_params, ...params})
    },

    url_for(params) {
      params = {...params}
      const format = this.hash_delete(params, "format")
      let extname = ""
      if (this.present_p(format)) {
        extname = `.${format}`
      }
      const url = new URL(`${this.$config.MY_SITE_URL}/share-board${extname}`)
      _.each(params, (v, k) => url.searchParams.set(k, v))
      return url.toString()
    },
  },
  computed: {
    current_url()      { return this.url_merge({})                         },
    current_kif_url()  { return this.url_merge({format: "kif"})            },
    json_debug_url()   { return this.url_merge({format: "json"})           },
    twitter_card_url() { return this.url_merge({format: "png"})            },
    room_url()         { return this.url_for({room_code: this.room_code}) }, // 合言葉だけを付与したURL(タイトル不要)

    // room_code や autoexec は含めない
    current_url_params() {
      const params = {
        ...this.player_names,
        abstract_viewpoint:   this.abstract_viewpoint,
        color_theme_key:      this.color_theme_key,
        title:                this.current_title,
        turn:                 this.current_turn,
        xbody:                SafeSfen.encode(this.current_sfen),
      }
      return this.pc_url_params_clean(params)
    },

    // 外部アプリ
    piyo_shogi_app_with_params_url() {
      return this.$KifuVo.create({
        kif_url: this.current_kif_url,
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.sp_viewpoint,
        ...this.player_names_for_piyo,
      }).piyo_url
    },

    kento_app_with_params_url() {
      return this.$KifuVo.create({
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.sp_viewpoint,
      }).kento_url
    },

    kpedia_url() {
      return this.$KifuVo.create({sfen: this.short_sfen}).kpedia_url
    },
  },
}
