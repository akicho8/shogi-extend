import { DotSfen } from "@/components/models/dot_sfen.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { KifuVo } from "@/components/models/kifu_vo.js"
const TinyURL = require("tinyurl")
import _ from "lodash"
const QueryString = require("query-string")

const OWN_SHORTENED_URL_FUNCTION = false // 自前の短縮URL機能を使うか？

export const mod_urls = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    room_url_copy_handle() {
      if (this.if_room_is_empty()) { return }

      this.$gs.assert(this.$gs.present_p(this.room_code), "this.$gs.present_p(this.room_code)")
      if (this.$gs.blank_p(this.room_code)) {
        // ここは通らないはず
        this.$sound.play_click()
        this.toast_warn("まだ合言葉を設定してません")
        return
      }

      this.sidebar_p = false
      this.$sound.play_click()
      return this.clipboard_copy({text: this.room_url, success_message: "部屋のリンクをコピーしました"})
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
      const url = await this.current_short_url()
      this.clipboard_copy({text: url, success_message: "棋譜再生用の短縮URLをコピーしました"})
    },
    async current_short_url() {
      let url = null
      this.debug_alert(this.current_url)
      if (OWN_SHORTENED_URL_FUNCTION) {
        url = (await this.long_url_to_short_url(this.current_url)).compact_url
      } else {
        url = await TinyURL.shorten(this.current_url)
      }
      this.debug_alert(url)
      return url
    },

    other_app_click_handle(app_name) {
      this.sidebar_p = false
      this.$sound.play_click()
      this.ga_click(app_name)
      this.app_log({emoji: ":外部アプリ:", subject: "共有将棋盤→外部アプリ起動", body: app_name})

      this.shared_al_add({
        label: `${app_name}起動`,
        message: `${app_name}を起動しました`,
        // message_except_self: false,
        sfen: this.current_sfen,
        turn: this.current_turn,
      })
    },

    // ../../../app/controllers/share_boards_controller.rb の current_og_image_path と一致させること
    // AbstractViewpointKeySelectModal から新しい viewpoint が渡されるので params で上書きする
    url_merge(params = {}) {
      return this.url_for({...this.current_url_params, ...params})
    },

    url_for(params) {
      params = {...params}
      const format = this.$gs.hash_delete(params, "format")
      let extname = ""
      if (this.$gs.present_p(format)) {
        extname = `.${format}`
      }
      return QueryString.stringifyUrl({
        url: `${this.$config.MY_SITE_URL}/share-board${extname}`,
        query: params,
      })
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
        xbody: SafeSfen.encode(this.current_sfen),
        turn:  this.current_turn,
        title: this.current_title,
        viewpoint: this.viewpoint,
        ...this.url_share_params,
        ...this.player_names,
      }
      return this.pc_url_params_clean(params)
    },

    // 履歴にも含める情報
    url_share_params() {
      return {
        color_theme_key: this.color_theme_key,
      }
    },

    current_kifu_vo() {
      return this.$KifuVo.create({
        kif_url: this.current_kif_url,
        sfen: this.current_sfen,
        turn: this.current_turn,
        viewpoint: this.viewpoint,
      })
    },
  },
}
