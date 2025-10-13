import { GX } from "@/components/models/gs.js"
import { AnyLinkCreator } from "@/components/models/any_link_creator.js"
import _ from "lodash"

export class PiyoUrlLinkCreator extends AnyLinkCreator {
  // private

  get base_url() {
    return "piyoshogi://"
  }

  get allowed_keys() {
    return ["viewpoint", "num", "url"]
  }

  get transform_params() {
    GX.assert(GX.present_p(this.params.kif_url), "GX.present_p(this.params.kif_url)")

    return {
      num: this.params.turn,
      url: this.params.kif_url,
    }
  }
}
