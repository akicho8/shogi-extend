import { PiyoUrlLinkCreator } from "@/components/models/piyo_url_link_creator.js"
import { PiyoSfenLinkCreator } from "@/components/models/piyo_sfen_link_creator.js"
import { KentoSfenLinkCreator } from "@/components/models/kento_sfen_link_creator.js"
import { Gs } from "@/components/models/gs.js"

export class KifuVo {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    Gs.assert(params, "params")
    Gs.assert(Gs.blank_p(params.path), "Gs.blank_p(params.path)")
    Gs.assert(params["sfen"] || params["kif_url"], 'params["sfen"] || params["kif_url"]')
    this.params = params
  }

  get piyo_url() {
    if (this.params["kif_url"]) {
      return PiyoUrlLinkCreator.url_for(this.params)
    } else {
      return PiyoSfenLinkCreator.url_for(this.params)
    }
  }

  get kento_url() {
    return KentoSfenLinkCreator.url_for(this.params)
  }
}
