import { PiyoUrlLinkCreator } from "@/components/models/piyo_url_link_creator.js"
import { PiyoSfenLinkCreator } from "@/components/models/piyo_sfen_link_creator.js"
import { KentoSfenLinkCreator } from "@/components/models/kento_sfen_link_creator.js"
import { GX } from "@/components/models/gx.js"

export class KifuVo {
  static create(attributes) {
    return new this(attributes)
  }

  constructor(attributes) {
    GX.assert(attributes, "attributes")
    GX.assert(GX.blank_p(attributes.path), "GX.blank_p(attributes.path)")
    GX.assert(attributes["sfen"] || attributes["kif_url"], 'attributes["sfen"] || attributes["kif_url"]')
    this.attributes = attributes
  }

  get piyo_url() {
    if (this.attributes["kif_url"]) {
      return PiyoUrlLinkCreator.url_for(this.attributes)
    } else {
      return PiyoSfenLinkCreator.url_for(this.attributes)
    }
  }

  get kento_url() {
    return KentoSfenLinkCreator.url_for(this.attributes)
  }

  get sfen_and_turn() {
    return { sfen: this.attributes.sfen, turn: this.attributes.turn }
  }
}
