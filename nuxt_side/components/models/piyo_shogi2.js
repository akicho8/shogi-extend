// https://www.studiok-i.net/kifu/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201&game_name=&sente_name
// https://www.studiok-i.net/ps/?sfen=position%20sfen%20lnsgkgsnl%2F1r5b1%2Fp1pppp1pp%2F1p4p2%2F9%2F2P4P1%2FPP1PPPP1P%2F1B5R1%2FLNSGKGSNL%20b%20-%201

import { Gs2 } from "@/components/models/gs2.js"
import { Gs3 } from "@/components/models/gs3.js"
import { isMobile } from "@/components/models/is_mobile.js"
import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { PiyoShogiTypeInfo } from "@/components/models/piyo_shogi_type_info.js"

const FORCE_PIYO_SHOGI_TYPE_KEY = null // 種類を強制する

export class PiyoShogi2 {
  // モバイルアプリ版が起動できるか？
  // public
  static get native_p() {
    if ("memo_native_p" in this) {
      return this.memo_native_p
    }
    this.memo_native_p = this.__native_p
    return this.memo_native_p
  }
  // private
  static get __native_p() {
    const v = MyLocalStorage.get("user_settings")
    Gs2.p(`PiyoShogi2.__native_p -> ${Gs2.i(v)}`)
    let piyo_shogi_type_key = "auto"
    if (v) {
      piyo_shogi_type_key = v.piyo_shogi_type_key
    }
    if (FORCE_PIYO_SHOGI_TYPE_KEY) {
      piyo_shogi_type_key = FORCE_PIYO_SHOGI_TYPE_KEY
    }
    return PiyoShogiTypeInfo.fetch(piyo_shogi_type_key).func()
  }

  static create(params) {
    return new this(params)
  }

  constructor(params) {
    this.params = params
  }

  // app, web 自動切り替え
  // app のとき path があれば kif の URL を渡す
  get url() {
    if (this.native_p) {    // モバイル版
      if (this.params.path) {
        return this.deep_link_url // KIFファイルを渡す方法
      } else {
        return this.http_link_url // SFENを引数に渡す方法
      }
    } else {
      return this.http_link_url   // SFENを引数に渡す方法
    }
  }

  //////////////////////////////////////////////////////////////////////////////// private

  // ぴよ将棋はコンテンツを見ているのではなく .kif という拡張子を見ているので format=kif にはできない
  get deep_link_url() {
    Gs2.__assert__(this.params.path, "this.params.path")
    const url = new URL(Gs3.as_full_url(this.params.path))

    // http://xxx/native_p?yyy=1 --> http://xxx/native_p.kif?yyy=1
    url.pathname = url.pathname + ".kif"

    const a = {...this.params, url: url}
    const ordered_keys = ["viewpoint", "num", "url"]
    const url2 = this.params_to_url(a, ordered_keys) // 最後を url=xxx.kif にしないと動かない。順序重要。
    return url2
  }

  // app, web 自動切り替え
  // 常にSFENを渡す
  get http_link_url() {
    Gs2.__assert__(this.params.sfen, "this.params.sfen")
    const ordered_keys = ["viewpoint", "num", "sente_name", "gote_name", "game_name", "sfen"]
    return this.params_to_url(this.params, ordered_keys)
  }

  params_to_url(params, ordered_keys) {
    params = {
      ...params,
      num: params.turn, // turn -> num
    }
    return [
      this.url_prefix,
      "?",
      this.params_to_sorted_query(params, ordered_keys),
    ].join("")
  }

  params_to_sorted_query(params, ordered_keys) {
    const values = []
    ordered_keys.forEach(e => {
      let v = params[e]
      if (v != null) {
        if (this.native_p) {
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
  }

  // モバイル or WEB に合わせたプレフィクス
  get url_prefix() {
    if (this.native_p) {
      return "piyoshogi://"
    } else {
      return "https://www.studiok-i.net/ps/"
    }
  }

  get native_p() {
    return this.constructor.native_p
  }
}
