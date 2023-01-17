import { Gs2 } from "@/components/models/gs2.js"
import Vue from "vue"

export class SennichiteModel {
  static SNT_TRIGGER_ON_N_TIMES = 4 // N回目の繰り返しで千日手となる

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
    return this.counts_hash[key] >= this.constructor.SNT_TRIGGER_ON_N_TIMES
  }

  // デバッグ用
  get keys_count() {
    return Gs2.hash_count(this.counts_hash)
  }
}
