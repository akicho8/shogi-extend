import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { RoleGroup } from "./role_group.js"

export const mod_role = {
  computed: {
    // black, white, other, member のキーを持ったハッシュ
    current_role_group() {
      if (this.cable_p) {
        return this.room_role_group
      } else {
        return this.query_role_group
      }
    },

    // 部屋を立てているとき用
    // 先後に分けた順番のリスト
    // |--------+--------------------------------------------+----------+------------------------------------|
    // | key    | value (string)                             | 意味     |                                    |
    // |--------+--------------------------------------------+----------+------------------------------------|
    // | black  | ["alice", "bob"]                           | ▲       |                                    |
    // | white  | ["carol", "eve"]                           | △       |                                    |
    // | other  | ["justin"]                                 | 観戦     |                                    |
    // | member | ["alice", "bob", "carol", "eve", "justin"] | メンバー | 対局設定してないとすべてここに入る |
    // |--------+--------------------------------------------+----------+------------------------------------|
    room_role_group() {
      const hv = {}
      RoleGroup.attribute_keys.forEach(key => hv[key] = [])
      this.member_infos.forEach(e => {
        let name = e.from_user_name
        const location = this.user_name_to_initial_location(name)      // 先後。なければ観戦者
        let key = null
        let index = this.member_infos.length
        if (location) {
          key = location.key
          index = this.name_to_turns_hash[name][0] // 対局設定から自分の番号(0..)を取得
        } else {
          if (this.order_enable_p) {
            key = "other"       // 対局設定されているけど順番に含まれていないということは観戦している人
          } else {
            key = "member"
          }
        }
        hv[key].push({index: index, name: name}) // あとで index でソートする
      })

      // 既存パラメータがURLにあっても上書きしたいのですべてのキーを含める
      const attributes = {}
      _.each(hv, (list, key) => {
        attributes[key] = _.sortBy(list, "index").map(e => e.name)
      })
      return RoleGroup.create(attributes)
    },

    // クエリから作成する。部屋を立ててないとき用
    query_role_group() {
      let hv = {}
      RoleGroup.attribute_keys.forEach(key => {
        const str = this.$route.query[key] ?? ""
        hv[key] = GX.str_split(str, /,/)
      })
      return RoleGroup.create(hv)
    },
  },
}
