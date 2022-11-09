import { SfenParser } from "shogi-player/components/models/sfen_parser.js"
import { Xcontainer } from "shogi-player/components/models/xcontainer.js"
import { PiyoUrlCreator } from "@/components/models/piyo_url_creator.js"
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
    return PiyoUrlCreator.url_for(this.attributes)
  }

  get kento_url() {
    return KentoUrlCreator.url_for(this.attributes)
  }
}
