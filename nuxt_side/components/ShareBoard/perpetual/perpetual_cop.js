import { GX } from "@/components/models/gs.js"
import Vue from "vue"
import _ from "lodash"

export class PerpetualCop {
  static trigger_on_n_times = 4 // X回目の繰り返しで千日手となる

  static create(...args) {
    return new this(...args)
  }

  constructor() {
    this.counts_hash = {}
    this.count = 0           // increment 回数
  }

  reset() {
    this.counts_hash = {}
    this.count = 0
  }

  // 同一局面になった回数をカウント
  increment(key) {
    GX.assert(GX.present_p(key), "GX.present_p(key)")
    Vue.set(this.counts_hash, key, (this.counts_hash[key] || 0) + 1)
    this.count += 1
  }

  // 千日手か？
  available_p(key) {
    GX.assert(GX.present_p(key), "GX.present_p(key)")
    const v = this.constructor.trigger_on_n_times
    if (GX.present_p(v)) {
      return this.counts_hash[key] >= v
    }
  }

  // キーの数
  // デバッグ用
  // increment の回数ではないので注意せよ
  get keys_count() {
    return GX.hash_count(this.counts_hash)
  }

  // 確認用
  get to_h() {
    return {
      trigger_on_n_times: this.constructor.trigger_on_n_times,
      count:              this.count,
      keys_count:         this.keys_count,
    }
  }

  // デバッグ用
  get inspect() {
    return _.map(this.to_h, (v, k) => `${k}: ${v}`).join(", ")
  }
}
