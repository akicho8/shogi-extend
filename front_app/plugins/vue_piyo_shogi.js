// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

import { isMobile } from "../components/models/isMobile.js"

export default {
  methods: {
    // app, web 自動切り替え
    // app のとき path があれば kif の URL を渡す
    piyo_shogi_auto_url(params) {
      if (this.piyo_shogi_app_p) {
        if (params.path) {
          return this.piyo_shog_native_url(params)
        } else {
          return this.piyo_shogi_sfen_url(params)
        }
      } else {
        return this.piyo_shogi_sfen_url(params)
      }
    },

    // ぴよ将棋はコンテンツを見ているのではなく .kif という拡張子を見ているので format=kif にはできない
    piyo_shog_native_url(params) {
      this.__assert__(params.path, "params.path")
      const url = new URL(this.as_full_url(params.path))

      // http://xxx/foo?yyy=1 --> http://xxx/foo.kif?yyy=1
      url.pathname = url.pathname + ".kif"

      const a = {...params, url: url}
      const url2 = this.piyo_shogi_url_build(a, ["num", "flip", "url"])
      return url2
    },

    // app, web 自動切り替え
    // 常にSFENを渡す
    piyo_shogi_sfen_url(params) {
      this.__assert__(params.sfen, "params.sfen")
      return this.piyo_shogi_url_build(params, ["num", "flip", "sente_name", "gote_name", "game_name", "sfen"])
    },

    //////////////////////////////////////////////////////////////////////////////// private

    piyo_shogi_url_build(params, keys) {
      params = {...params, num: params.turn} // turn -> num

      return [
        this.piyo_shogi_url_prefix,
        "?",
        this.piyo_shogi_url_params_build(params, keys),
      ].join("")
    },

    piyo_shogi_url_params_build(params, keys, encode) {
      const values = []
      keys.forEach(e => {
        let v = params[e]
        if (v != null) {
          if (this.piyo_shogi_app_p) {
            // 「ぴよ将棋」のアプリ版はエンコードするとまったく読めなくなる
            // そして .kif が最後に来るように調整しないといけない
          } else {
            v = encodeURIComponent(v)
          }
          values.push([e, v].join("="))
        }
      })
      return values.join("&")
    },
  },

  computed: {
    // アプリ版「ぴよ将棋」が起動できるか？
    piyo_shogi_app_p() {
      return isMobile.iOS() || isMobile.Android()
    },

    piyo_shogi_url_prefix() {
      if (this.piyo_shogi_app_p) {
        return "piyoshogi://"
      } else {
        return "https://www.studiok-i.net/ps/"
      }
    },
  },
}
