import { GX } from "@/components/models/gs.js"
import { AnyLinkCreator } from "@/components/models/any_link_creator.js"
import _ from "lodash"

export class PiyoSfenLinkCreator extends AnyLinkCreator {
  // private

  get base_url() {
    return "piyoshogi://"
  }

  get allowed_keys() {
    return ["viewpoint", "num", "sente_name", "gote_name", "game_name", "sfen"]
  }

  get transform_params() {
    return {
      num: this.params.turn,
    }
  }
}
