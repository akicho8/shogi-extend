import { Gs2 } from "@/components/models/gs2.js"
import Vue from "vue"
import _ from "lodash"

export class SennichiteCop {
  static trigger_on_n_times = 4 // N回目の繰り返しで千日手となる

  static create(...args) {
    return new this(...args)
  }

  constructor() {
    this.counts_hash = {}
    this.count = 0
  }

  reset() {
    this.counts_hash = {}
    this.count = 0
  }

  // 同一局面になった回数をカウント
  update(key) {
    Gs2.__assert__(Gs2.present_p(key), "Gs2.present_p(key)")
    Vue.set(this.counts_hash, key, (this.counts_hash[key] || 0) + 1)
    this.count += 1
  }

  // 千日手か？
  available_p(key) {
    Gs2.__assert__(Gs2.present_p(key), "Gs2.present_p(key)")
    const v = this.constructor.trigger_on_n_times
    if (Gs2.present_p(v)) {
      return this.counts_hash[key] >= v
    }
  }

  // デバッグ用
  get keys_count() {
    return Gs2.hash_count(this.counts_hash)
  }

  get to_h() {
    return {
      trigger_on_n_times: this.constructor.trigger_on_n_times,
      count:                  this.count,
      keys_count:             this.keys_count,
    }
  }

  get inspect() {
    return _.map(this.to_h, (v, k) => `${k}: ${v}`).join(", ")
  }
}
