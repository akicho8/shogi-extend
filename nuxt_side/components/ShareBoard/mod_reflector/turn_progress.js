import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export class TurnProgress {
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
    let value = null
    if (this.to != null) {
      value = this.to
    }
    if (this.by != null) {
      value = this.old_turn + this.by
    }
    if (value < 0) {
      value = 0
    }
    return value
  }

  get diff() {
    return this.new_turn - this.old_turn
  }

  get step() {
    return Math.abs(this.diff)
  }

  get next_p() {
    return this.diff > 0
  }

  get previous_p() {
    return this.diff < 0
  }

  get same_p() {
    return this.diff === 0
  }

  get initial_position_p() {
    return this.new_turn === 0
  }

  get will_message() {
    let str = null

    if (this.initial_position_p) {
      str = `初期配置に戻す`
    }

    if (str == null) {
      if (this.to != null) {
        if (this.next_p) {
          str = `${this.new_turn}手目に進める`
        } else if (this.previous_p) {
          str = `${this.new_turn}手目に戻す`
        } else {
          str = `${this.new_turn}手目に戻す`
        }
      }
    }

    if (str == null) {
      if (this.by != null) {
        if (this.next_p) {
          str = `${this.step}手進める`
        } else if (this.previous_p) {
          str = `${this.step}手戻す`
        } else {
          str = `${this.step}手戻す`
        }
      }
    }

    return str
  }

  get past_message() {
    let str = this.will_message
    str = str.replace(/進める/, "進めました")
    str = str.replace(/戻す/, "戻しました")
    return str
  }

  get label() {
    return `局面変更 #${this.new_turn}`
  }

  // 新しい棋譜は前の棋譜の過去の状態、または同じか？
  // つまり次のような状態であれば真となる
  //   old_sfen: "a b c d e"
  //   new_sfen: "a b c"
  get descendant_sfen_p() {
    return this.old_sfen.startsWith(this.new_sfen)
  }

  // 設定するSFEN
  get master_sfen() {
    if (this.descendant_sfen_p) {
      return this.old_sfen      // 過去の局面または同じであればそのままの未来を含む棋譜を返す
    } else {
      return this.new_sfen      // 異なる棋譜または変化しているのであれば新しい方を返す
    }
  }

  get to_sfen_and_turn() {
    return {
      sfen: this.master_sfen,
      turn: this.new_turn,
    }
  }
}
