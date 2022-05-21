import _ from "lodash"
import { Location } from "shogi-player/components/models/location.js"

export const app_player_names = {
  methods: {
    // メンバーの名前をコピーする
    player_names_copy_handle() {
      this.sound_play_click()
      this.simple_clipboard_copy(this.player_names_with_title_as_human_text)
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
      info = this.hash_compact_if_blank(info)
      return _.map(info, (v, k) => `${k}: ${v}\n`).join("")
    },

    // ぴよ将棋用のパラメータに変換する
    player_names_for_piyo() {
      return this.hash_compact_if_blank({
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
        const location = this.location_by_name(name)
        let key = null
        if (location) {
          key = location.key
        } else {
          if (this.order_enable_p) {
            key = "other"
          } else {
            key = "member"
          }
        }
        if (false) {
          name = encodeURIComponent(name)
        }
        av[key].push(name)
      })
      return _.reduce(av, (a, list, key) => {
        // 既存パラメータがURLにあっても上書きしたいのですべてのキーを含める
        // if (this.present_p(list)) {
        // }
        a[key] = list.join(", ")
        return a
      }, {})
    },

    // クエリから作成する。部屋を立ててないとき用
    player_names_from_query() {
      let hv = Location.values.reduce((a, e, i) => ({...a, [e.key]: this.$route.query[e.key]}), {})
      hv["other"] = this.$route.query["other"]
      hv["member"] = this.$route.query["member"]
      hv = this.hash_compact_if_blank(hv)
      return hv
    },
  },
}
