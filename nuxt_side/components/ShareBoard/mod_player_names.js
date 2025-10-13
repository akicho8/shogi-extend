import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"

export const mod_player_names = {
  methods: {
    // メンバーの名前をコピーする
    player_names_copy_handle() {
      this.sfx_click()
      this.clipboard_copy(this.player_names_with_title_as_human_text)
    },
  },

  computed: {
    player_names_with_title_as_human_text() {
      let info = {}
      info["棋戦"] = this.player_names_with_title.title
      Location.values.forEach(e => {
        info[`${e.name}側`] = this.player_names_with_title[e.key]
      })
      info["観戦"] = this.player_names_with_title.other
      info["面子"] = this.player_names_with_title.member
      info = GX.hash_compact_blank(info)
      return _.map(info, (v, k) => `${k}: ${v}\n`).join("")
    },

    // ぴよ将棋用のパラメータに変換する
    player_names_for_piyo() {
      return GX.hash_compact_blank({
        game_name:  this.player_names_with_title.title,
        sente_name: this.player_names_with_title.black,
        gote_name:  this.player_names_with_title.white,
      })
    },

    // ActionLog にまるごと保存し「棋譜コピー」や「棋譜リンク」のときに渡す内容
    player_names_with_title() {
      return {
        title: this.current_title,
        ...this.player_names,
      }
    },

    // black, white, other のキーを持ったハッシュ
    player_names() {
      if (this.ac_room) {
        return this.player_names_from_member
      } else {
        return this.player_names_from_query
      }
    },

    // 部屋を立てているとき用
    // 先後に分けた順番のリスト
    // |--------+----------------------------+----------+------------------------------------|
    // | key    | value (string)             | 意味     |                                    |
    // |--------+----------------------------+----------+------------------------------------|
    // | black  | alice,bob                  | ▲       |                                    |
    // | white  | carol,eve                  | △       |                                    |
    // | other  | justin                     | 観戦     |                                    |
    // | member | alice,bob,carol,eve,justin | メンバー | 順番設定してないとすべてここに入る |
    // |--------+----------------------------+----------+------------------------------------|
    player_names_from_member() {
      const av = {
        black: [],
        white: [],
        other: [],
        member: [],
      }
      this.member_infos.forEach(e => {
        let name = e.from_user_name
        const location = this.user_name_to_initial_location(name)      // 先後
        let key = null
        let index = this.member_infos.length
        if (location) {
          key = location.key
          index = this.name_to_turns_hash[name][0] // 順番設定から自分の番号(0..)を取得
        } else {
          if (this.order_enable_p) {
            key = "other"       // 順番設定されているけど順番に含まれていないということは観戦している人
          } else {
            key = "member"
          }
        }
        if (false) {
          name = encodeURIComponent(name)
        }
        av[key].push({index, name}) // あとで index でソートする
      })
      return _.reduce(av, (a, list, key) => {
        // 既存パラメータがURLにあっても上書きしたいのですべてのキーを含める
        a[key] = _.sortBy(list, "index").map(e => e.name).join(",")
        return a
      }, {})
    },

    // クエリから作成する。部屋を立ててないとき用
    player_names_from_query() {
      let hv = Location.values.reduce((a, e, i) => ({...a, [e.key]: this.$route.query[e.key]}), {})
      hv["other"] = this.$route.query["other"]
      hv["member"] = this.$route.query["member"]
      hv = GX.hash_compact_blank(hv)
      return hv
    },
  },
}
