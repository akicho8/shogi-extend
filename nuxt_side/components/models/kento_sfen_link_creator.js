import { AnyLinkCreator } from "@/components/models/any_link_creator.js"
import { GX } from "@/components/models/gs.js"
import _ from "lodash"
import { SfenParser } from "shogi-player/components/models/sfen_parser.js"

export class KentoSfenLinkCreator extends AnyLinkCreator {
  // private

  get base_url() {
    return "https://www.kento-shogi.com/"
  }

  get allowed_keys() {
    return ["viewpoint", "initpos", "moves"]
  }

  get transform_params() {
    GX.assert(GX.present_p(this.params.sfen), "GX.present_p(this.params.sfen)")
    return {
      initpos: this.sfen_info.init_sfen_strip,
      moves: this.moves_space_to_dot_replaced_string,
    }
  }

  get tail_hash() {
    return this.params.turn
  }

  get sfen_info() {
    return SfenParser.parse(this.params.sfen)
  }

  get moves_space_to_dot_replaced_string() {
    const moves = this.sfen_info.attributes.moves
    if (moves) {
      return moves.replace(/\s+/g, ".")
    }
  }
}
