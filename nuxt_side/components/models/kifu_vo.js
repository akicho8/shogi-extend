import { SfenParser } from "shogi-player/components/models/sfen_parser.js"
import { Mediator } from "shogi-player/components/models/mediator.js"

export class KifuVo {
  static KYOKUMENPEDIA_URL_PREFIX = "http://kyokumen.jp/positions/"

  static create(...args) {
    return new this(...args)
  }

  constructor(attributes = {}) {
    this.attributes = attributes
  }

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
    const mediator = new Mediator()
    mediator.data_source = SfenParser.parse(this.attributes.sfen)
    mediator.current_turn = this.attributes.turn || 0
    mediator.run()
    return this.constructor.KYOKUMENPEDIA_URL_PREFIX + mediator.to_sfen_without_turn
  }

  // 方法2: moves がない SFEN から変換する場合 (速い)
  get kpedia_url2() {
    let s = this.attributes.sfen
    s = s.replace(/^position sfen /, "")
    s = s.replace(/\s*\d+$/, "")
    return this.constructor.KYOKUMENPEDIA_URL_PREFIX + s
  }
}
