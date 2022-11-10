import { Gs2 } from "@/components/models/gs2.js"
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
    Gs2.__assert__(Gs2.present_p(this.params.kif_url), "Gs2.present_p(this.params.kif_url)")

    return {
      num: this.params.turn,
      url: this.params.kif_url,
    }
  }
}
