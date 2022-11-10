import { Gs2 } from "@/components/models/gs2.js"
import { AnyLinkCreator } from "@/components/models/any_link_creator.js"
import _ from "lodash"

export class PiyoSfenLinkCreator extends AnyLinkCreator {
  get url() { return this.url_build_for_piyo } // TODO: ぴよ将棋 URLSearchParams に対応したら取る

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
