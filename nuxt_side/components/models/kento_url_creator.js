import { SfenParser } from "shogi-player/components/models/sfen_parser.js"
import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

export class KentoUrlCreator {
  static url_for(params) {
    return this.create(params).url
  }

  static create(params) {
    Gs2.__assert__(Gs2.present_p(params.sfen), "Gs2.present_p(params.sfen)")
    return new this(params)
  }

  constructor(params) {
    this.params = params
  }

  get url() {
    const url = new URL("https://www.kento-shogi.com")
    _.each(this.allowed_params, (v, k) => url.searchParams.set(k, v))
    if (this.params.turn != null) {
      url.hash = this.params.turn
    }
    return url.toString()
  }

  // private

  get all_params() {
    return Gs2.hash_compact({
      ...this.params,
      initpos: this.sfen_info.init_sfen_strip,
      moves: this.moves_space_to_dot_replaced_string,
    })
  }

  get allowed_keys() {
    return ["viewpoint", "initpos", "moves"]
  }

  get allowed_params() {
    return Gs2.hash_slice(this.all_params, ...this.allowed_keys)
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
