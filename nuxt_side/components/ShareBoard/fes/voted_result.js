import { Gs } from "@/components/models/gs.js"

export class VotedResult {
  // Value Object
  static create(...args) {
    return Object.freeze(new this(...args))
  }

  // 直接は使うな
  constructor(hash_value = {}) {
    this.hash_value = hash_value
  }

  // 投票数
  get count() {
    return this.user_names.length
  }

  // 投票者たちの名前
  get user_names() {
    return Object.keys(this.hash_value)
  }

  // user_name さんが index を選択する (新しいオブジェクトを返す)
  post(user_name, index) {
    Gs.assert(Gs.present_p(user_name), "Gs.present_p(user_name)")
    Gs.assert(Gs.present_p(index), "Gs.present_p(index)")
    return this.merge({[user_name]: index})
  }

  // 新しい投票の追加
  merge(other) {
    return this.constructor.create({...this.hash_value, ...other})
  }

  // 指定の人はすでに投票済み？
  already_vote_p(user_name) {
    return user_name in this.hash_value
  }

  // いまのところダンプ時に見やすくするため
  toJSON() {
    return this.hash_value
  }

  // ハッシュを返す (あんまり使うな)
  get to_h() {
    return this.hash_value
  }
}
