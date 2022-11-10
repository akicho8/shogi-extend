import { PiyoUrlLinkCreator } from "@/components/models/piyo_url_link_creator.js"
import { PiyoSfenLinkCreator } from "@/components/models/piyo_sfen_link_creator.js"
import { KentoUrlCreator } from "@/components/models/kento_url_creator.js"
import { Gs2 } from "@/components/models/gs2.js"
import { DotSfen } from "@/components/models/dot_sfen.js"

export class KifuVo {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    Gs2.__assert__(params, "params")
    Gs2.__assert__(params["sfen"] || params["kif_url"], 'params["sfen"] || params["kif_url"]')
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
    return KentoUrlCreator.url_for(this.params)
  }
}
