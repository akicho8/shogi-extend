// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

import { isMobile } from "@/components/models/is_mobile.js"
import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { PiyoShogiTypeInfo } from "@/components/models/piyo_shogi_type_info.js"

export default {
  methods: {
    // app, web 自動切り替え
    // app のとき path があれば kif の URL を渡す
    piyo_shogi_auto_url(params) {
      if (this.piyo_shogi_app_p()) {
        // モバイル版
        if (params.path) {
          // KIFファイルを渡す方法
          return this.piyo_shog_native_url(params)
        } else {
          // SFENを引数に渡す方法
          return this.piyo_shogi_sfen_url(params)
        }
      } else {
        // SFENを引数に渡す方法
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
      const ordered_keys = ["viewpoint", "num", "url"]
      const url2 = this.piyo_shogi_url_build(a, ordered_keys) // 最後を url=xxx.kif にしないと動かない。順序重要。
      return url2
    },

    // app, web 自動切り替え
    // 常にSFENを渡す
    piyo_shogi_sfen_url(params) {
      this.__assert__(params.sfen, "params.sfen")
      const ordered_keys = ["viewpoint", "num", "sente_name", "gote_name", "game_name", "sfen"]
      return this.piyo_shogi_url_build(params, ordered_keys)
    },

    //////////////////////////////////////////////////////////////////////////////// private

    piyo_shogi_url_build(params, ordered_keys) {
      params = {...params, num: params.turn} // turn -> num

      return [
        this.piyo_shogi_url_prefix(),
        "?",
        this.piyo_shogi_url_params_build(params, ordered_keys),
      ].join("")
    },

    piyo_shogi_url_params_build(params, ordered_keys) {
      const values = []
      const piyo_shogi_app_p = this.piyo_shogi_app_p()
      ordered_keys.forEach(e => {
        let v = params[e]
        if (v != null) {
          if (piyo_shogi_app_p) {
            // 注意点
            // ・「ぴよ将棋」のアプリ版はエンコードするとまったく読めなくなる
            // ・URLの最後に ".kif" の文字列が来ないといけない
          } else {
            v = encodeURIComponent(v)
          }
          values.push([e, v].join("="))
        }
      })
      return values.join("&")
    },

    // モバイルアプリ版が起動できるか？
    piyo_shogi_app_p() {
      const v = MyLocalStorage.get("user_settings")
      this.clog(v)
      if (v) {
        const info = PiyoShogiTypeInfo.fetch(v.piyo_shogi_type_key)
        if (info.key === "native") {
          return true
        }
        if (info.key === "web") {
          return false
        }
      }
      return isMobile.iOS() || isMobile.Android()
    },

    // モバイル or WEB に合わせたプレフィクス
    piyo_shogi_url_prefix() {
      if (this.piyo_shogi_app_p()) {
        return "piyoshogi://"
      } else {
        return "https://www.studiok-i.net/ps/"
      }
    },
  },
}
