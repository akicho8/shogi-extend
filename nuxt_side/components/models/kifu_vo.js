import { SfenParser } from "shogi-player/components/models/sfen_parser.js"
import { Xcontainer } from "shogi-player/components/models/xcontainer.js"
import { PiyoShogi2 } from "@/components/models/piyo_shogi2.js"
import { Gs2 } from "@/components/models/gs2.js"
import { DotSfen } from "@/components/models/dot_sfen.js"

export class KifuVo {
  static create(...args) {
    return new this(...args)
  }

  constructor(attributes = {}) {
    Gs2.__assert__(Gs2.present_p(attributes), "attributes is blank")
    this.attributes = attributes
  }

  //////////////////////////////////////////////////////////////////////////////// ぴよ将棋

  get piyo_url() {
    return PiyoShogi2.create(this.attributes).url
  }

  //////////////////////////////////////////////////////////////////////////////// KENTO

  get kento_url() {
    Gs2.__assert__(this.attributes.sfen, "sfen is blank")

    const info = SfenParser.parse(this.attributes.sfen)
    const url = new URL("https://www.kento-shogi.com")

    // initpos は position sfen と moves がない初期局面の sfen
    url.searchParams.set("initpos", info.init_sfen_strip)

    // 視点も対応してくれるかもしれないので入れとく
    if (this.attributes.viewpoint) {
      url.searchParams.set("viewpoint", this.attributes.viewpoint)
    }

    // moves は別のパラメータでスペースを . に置き換えている(KENTOの独自の工夫)
    // moves のところだけなので DotSfen.escape は使えない
    const { moves } = info.attributes
    if (moves) {
      url.searchParams.set("moves", moves.replace(/\s+/g, "."))
    }

    // #n が手数
    if (this.attributes.turn != null) {
      url.hash = this.attributes.turn
    }

    return url.toString()
  }

  //////////////////////////////////////////////////////////////////////////////// 局面ペディア

  static KYOKUMENPEDIA_URL_PREFIX = "http://kyokumen.jp/positions/"

  // ハイブリッド
  // "http://kyokumen.jp/positions/lnsgkgsnl/1r5b1/ppppppppp/9/9/7P1/PPPPPPP1P/1B5R1/LNSGKGSNL%20w%20-"
  get kpedia_url() {
    if (this.attributes.sfen.includes("moves")) {
      return this.kpedia_url1
    } else {
      return this.kpedia_url2
    }
  }

  // 方法1: moves がついた SFEN から変換する場合 (遅い)
  get kpedia_url1() {
    const info = SfenParser.parse(this.attributes.sfen)
    const xcontainer = new Xcontainer()
    xcontainer.data_source = SfenParser.parse(this.attributes.sfen)
    xcontainer.current_turn = this.attributes.turn || 0
    xcontainer.run()
    return this.constructor.KYOKUMENPEDIA_URL_PREFIX + xcontainer.to_sfen_without_turn
  }

  // 方法2: moves がない SFEN から変換する場合 (速い)
  get kpedia_url2() {
    let s = this.attributes.sfen
    s = s.replace(/^position sfen /, "")
    s = s.replace(/\s*\d+$/, "")
    return this.constructor.KYOKUMENPEDIA_URL_PREFIX + s
  }
}
