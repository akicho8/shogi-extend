import { GX } from "@/components/models/gx.js"
import _ from "lodash"
import { SfenParser } from "shogi-player/components/models/sfen_parser.js"

const SFEN_SEPARATE_SPACE = " "

export class TimelineResolver {
  static create(...args) {
    return new this(...args)
  }

  constructor(params = {}) {
    // old
    {
      GX.assert_kind_of_string(params.old_sfen)
      GX.assert_kind_of_integer(params.old_turn)
    }

    // new
    {
      GX.assert_kind_of_string(params.new_sfen)
      if (params.to != null) {
        GX.assert_kind_of_integer(params.to)
      }
      if (params.by != null) {
        GX.assert_kind_of_integer(params.by)
      }
      GX.assert(params.to != null || params.by != null)
    }

    Object.assign(this, params)
    Object.freeze(this)
  }

  get new_turn() {
    let turn = null
    if (this.to != null) {
      turn = this.to
    }
    if (this.by != null) {
      turn = this.old_turn + this.by
    }
    if (turn < 0) {
      turn = 0
    }
    return turn
  }

  get turn_diff() {
    return this.new_turn - this.old_turn
  }

  get turn_step() {
    return Math.abs(this.turn_diff)
  }

  get turn_next_p() {
    return this.turn_diff > 0
  }

  get turn_previous_p() {
    return this.turn_diff < 0
  }

  get turn_same_p() {
    return this.turn_diff === 0
  }

  get turn_zero_p() {
    return this.new_turn === 0
  }

  get will_message() {
    let str = null
    if (str == null) {
      if (this.sfen_another_p) {
        str = `別の棋譜の${this.new_turn}手目に移動する`
      }
    }
    if (str == null) {
      if (this.turn_zero_p) {
        str = `初期配置に戻す`
      }
    }
    // if (str == null) {
    //   if (this.sfen_turn_max === this.new_turn) {
    //     str = `最後に移動する`
    //   }
    // }
    if (false) {
      if (str == null) {
        if (this.sfen_go_back_p) {
          str = `${this.new_turn}手目(過去)に移動する` // old_sfen をマスターにしたからといって移動先が「過去」とは限らないため「過去」と表現すると混乱させてしまう
        }
      }
      if (str == null) {
        if (this.sfen_go_forward_p) {
          str = `${this.new_turn}手目(未来)に移動する` // new_sfen をマスターにしたからといって移動先が「未来」とは限らないため「未来」と表現すると混乱させてしまう
        }
      }
    }
    if (str == null) {
      if (this.to != null) {    // 絶対指定であれば
        if (this.turn_next_p) {
          str = `${this.new_turn}手目に進める`
        }
        if (this.turn_previous_p) {
          str = `${this.new_turn}手目に戻す`
        }
      }
    }
    if (str == null) {
      if (this.by != null) {    // 相対指定であれば
        if (this.turn_next_p) {
          str = `${this.turn_step}手進める`
        }
        if (this.turn_previous_p) {
          str = `${this.turn_step}手戻す`
        }
      }
    }
    if (str == null) {
      str = `${this.new_turn}手目に戻す`
    }

    if (this.message_prefix != null) {
      str = [this.message_prefix, str].join("")
    }

    return str
  }

  get past_message() {
    let str = this.will_message
    str = str.replace(/進める/, "進めました")
    str = str.replace(/戻す/, "戻しました")
    str = str.replace(/移動する/, "移動しました")
    return str
  }

  get label() {
    return `局面変更 #${this.new_turn}`
  }

  // 古棋譜に対して新棋譜は過去に戻ろうとしている？
  // つまり次のような状態であれば真となる
  //   old_sfen: "a b c d e"
  //   new_sfen: "a b c"
  get sfen_go_back_p() {
    return this.flow_a_to_b(this.new_sfen, this.old_sfen)
  }

  // 古棋譜に対して新棋譜は未来に進もうとしている？
  // つまり次のような状態であれば真となる
  //   old_sfen: "a b c"
  //   new_sfen: "a b c d e"
  get sfen_go_forward_p() {
    return this.flow_a_to_b(this.old_sfen, this.new_sfen)
  }

  // 棋譜は同じ？
  // つまり次のような状態であれば真となる
  //   old_sfen: "a b c"
  //   new_sfen: "a b c"
  get sfen_same_p() {
    return this.old_sfen === this.new_sfen
  }

  // まったく異なる棋譜？
  get sfen_another_p() {
    return !this.sfen_same_p && !this.sfen_go_back_p && !this.sfen_go_forward_p
  }

  // 設定するSFEN
  // つまり(可能な限り)本線を返す
  get master_sfen() {
    if (this.sfen_go_back_p) {
      return this.old_sfen      // 過去の局面または同じであればそのままの未来を含む棋譜を返す
    }
    if (this.sfen_go_forward_p) {
      return this.new_sfen      // 未来に進もうとしているなら大きい方を返す
    }
    return this.new_sfen        // 同じまたはまったく異なる場合は新しい方の棋譜を返す
  }

  get to_sfen_and_turn() {
    return {
      sfen: this.master_sfen,
      turn: this.new_turn,
    }
  }

  get to_reflection_call_params() {
    return {
      sfen: this.master_sfen,
      turn: this.new_turn,
      message_prefix: this.message_prefix,
    }
  }

  get description() {
    const av = []
    if (this.sfen_go_back_p) {
      av.push("古棋譜は新棋譜を含むので古棋譜をマスターとする")
    }
    if (this.sfen_go_forward_p) {
      av.push("新棋譜は古棋譜を含むので新棋譜をマスターとする")
    }
    if (this.sfen_same_p) {
      av.push("新棋譜と古棋譜は同じなので(どちらもでよいが)新棋譜をマスターとする")
    }
    if (this.sfen_another_p) {
      av.push("新棋譜と古棋譜はまったく異なるので別の世界線である新棋譜をマスターとする")
    }
    return av
  }

  get to_debug_h() {
    return {
      "古棋譜": this.old_sfen,
      "新棋譜": this.new_sfen,
      "古棋譜は新棋譜を含む→古棋譜採用?": this.sfen_go_back_p,
      "新棋譜は古棋譜を含む→新棋譜採用?": this.sfen_go_forward_p,
      "古棋譜と新棋譜は同じため手数のみの変化?": this.sfen_same_p,
      "動作前メッセージ": this.will_message,
      "動作後メッセージ": this.past_message,
      "棋譜選択理由": this.description,
      //
      "手数セット絶対値": this.to,
      "手数セット相対値": this.by,
      "手数計算後": this.new_turn,
      "手数差分": this.turn_diff,
      "手数進める?": this.turn_next_p,
      "手数戻す?": this.turn_previous_p,
      "手数最大": this.sfen_turn_max,
    }
  }

  // private

  // 棋譜は a の状態から b に進んでいるか？
  // つまり b の最初の方は a と同じか？
  // ただし単純に startsWith をするとバグる
  // 最後の指し手が "8h2b+" と "8h2b" のように異なる場合 "8h2b+".startsWith("8h2b") が真となりまったく異なる棋譜にもかかわらず同じ棋譜と見なしてしまう
  // 最後にスペースを入れると "8h2b+ ".startsWith("8h2b ") となり正しく偽になる
  flow_a_to_b(a, b) {
    if (a === b) {
      return false
    }
    return (b + SFEN_SEPARATE_SPACE).startsWith(a + SFEN_SEPARATE_SPACE)
  }

  get sfen_turn_max() {
    return SfenParser.parse(this.master_sfen).moves.length
  }
}
