import { Gs } from "@/components/models/gs.js"
import { SimpleCache } from "@/components/models/simple_cache.js"
import { DotSfen } from "@/components/models/dot_sfen.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import { KifuVo } from "@/components/models/kifu_vo.js"
const TinyURL = require("tinyurl")
import _ from "lodash"
import QueryString from "query-string"

const OWN_SHORTENED_URL_FUNCTION = true // 自前の短縮URL機能を使うか？

const simple_cache = new SimpleCache()

export const mod_urls = {
  methods: {
    ////////////////////////////////////////////////////////////////////////////////
    room_url_copy_handle() {
      if (this.room_is_empty_p()) { return }

      Gs.assert(Gs.present_p(this.room_key), "Gs.present_p(this.room_key)")
      if (Gs.blank_p(this.room_key)) {
        // ここは通らないはず
        this.sfx_click()
        this.toast_warn("まだ合言葉を設定してません")
        return
      }

      this.sidebar_p = false
      this.sfx_click()
      return this.clipboard_copy(this.room_url, {success_message: "部屋のリンクをコピーしました"})
    },

    // 「棋譜コピー (リンク)」
    current_url_copy_handle() {
      this.sidebar_p = false
      this.sfx_click()
      this.clipboard_copy(this.current_url, {success_message: "棋譜再生用のURLをコピーしました"})
    },

    // 「短縮URLのコピー」
    //
    // 次のように書いても一応動いたが予想に反してキャッシュの中に Promise オブジェクトが入ってしまう
    //
    //  async current_short_url_copy_handle() {
    //    if (false) {
    //      this.sfx_click()
    //      const url = await simple_cache.fetch(this.current_url, this.__short_url_fetch)
    //      if (this.clipboard_copy(url, {success_message: "棋譜再生用の短縮URLをコピーしました"})) {
    //        this.sidebar_p = false
    //      }
    //    }
    //  }
    //
    async current_short_url_copy_handle() {
      this.sfx_click()

      const key = Gs.str_to_md5(this.current_url)

      // 1回目
      if (simple_cache.empty_p(key)) {
        simple_cache.write(key, await this.__short_url_fetch())
      }

      // 1, 2回目
      if (this.clipboard_copy(simple_cache.read(key), {success_message: "棋譜再生用の短縮URLをコピーしました"})) {
        this.sidebar_p = false
      }
    },
    __short_url_fetch() {
      this.debug_alert("APIアクセス発生")
      if (OWN_SHORTENED_URL_FUNCTION) {
        const body = {room_key: this.room_key, user_name: this.user_name, current_url: this.current_url}
        this.app_log({emoji: ":短縮URL:", subject: `[短縮URL][作成希望](${this.user_name})`, body: body, mail_notify: false, table_format: false})
        return this.long_url_to_short_url(this.current_url)
      } else {
        return TinyURL.shorten(this.current_url)
      }
    },

    other_app_click_handle(app_name) {
      this.sidebar_p = false
      this.sfx_click()
      this.app_log({emoji: ":外部アプリ:", subject: "共有将棋盤→外部アプリ起動", body: app_name})

      this.al_share({
        label: `${app_name}起動`,
        message: `${app_name}を起動しました`,
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
      const format = Gs.hash_delete(params, "format")
      let extname = ""
      if (Gs.present_p(format)) {
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
    room_url()         { return this.url_for({room_key: this.room_key}) }, // 合言葉だけを付与したURL(タイトル不要)

    // room_key や autoexec は含めない
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
