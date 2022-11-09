import { SfenParser } from "shogi-player/components/models/sfen_parser.js"
import { Xcontainer } from "shogi-player/components/models/xcontainer.js"
import { PiyoShogiUrlCreator } from "@/components/models/piyo_shogi_url_creator.js"
import { KentoUrlCreator } from "@/components/models/kento_url_creator.js"
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

  get piyo_url() {
    return PiyoShogiUrlCreator.url_for(this.attributes)
  }

  get kento_url() {
    return KentoUrlCreator.url_for(this.attributes)
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
