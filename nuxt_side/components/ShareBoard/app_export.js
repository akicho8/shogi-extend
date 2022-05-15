import _ from "lodash"
import { Location } from "shogi-player/components/models/location.js"

export const app_export = {
  methods: {
    //////////////////////////////////////////////////////////////////////////////// clipboard

    // 現在のURLをコピー
    current_url_copy_handle() {
      this.sound_play_click()
      this.clipboard_copy({text: this.current_url, success_message: "現在のURLをコピーしました"})
    },

    // 指定の棋譜をコピー
    kifu_copy_handle(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      this.sidebar_p = false
      this.sound_play_click()
      this.general_kifu_copy(this.current_sfen, {
        to_format: e.format_key,
        turn: this.current_turn,
        title: this.current_title,
        ...this.player_names,
      })
      this.shared_al_add_simple("棋譜コピー")
    },

    //////////////////////////////////////////////////////////////////////////////// show

    // 指定の棋譜への直リンURL
    kifu_show_url(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      return this.permalink_for({
        format: e.format_key,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方を優先する
        // ...this.player_names,
      })
    },

    // 指定の棋譜を表示
    kifu_show_handle(e) {
      this.window_popup(this.kifu_show_url(e))
      this.shared_al_add_simple("棋譜表示")
    },

    //////////////////////////////////////////////////////////////////////////////// download

    // 指定の棋譜のダウンロードURL
    kifu_download_url(e) {
      this.__assert__("format_key" in e, '"format_key" in e')
      return this.permalink_for({
        format: e.format_key,
        body_encode: e.body_encode,
        image_viewpoint: this.sp_viewpoint, // abstract_viewpoint より image_viewpoint の方が優先される
        disposition: "attachment",
      })
    },

    // 指定の棋譜をダウンロード
    kifu_download_handle(e) {
      if (typeof window !== 'undefined') {
        window.location.href = this.kifu_download_url(e)
        this.shared_al_add_simple("棋譜ダウンロード")
      }
    },
  },

  computed: {
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
    // |-------+----------------+------+------------------------------------------------|
    // | key   | value (string) | 意味 |                                                |
    // |-------+----------------+------+------------------------------------------------|
    // | black | alice,bob      | ▲   |                                                |
    // | white | carol,eve      | △   |                                                |
    // | other | justin         | 観戦 | ordered_members しか見てないから観戦は入らない |
    // |-------+----------------+------+------------------------------------------------|
    player_names_from_member() {
      const av = { black: [], white: [], other: [] }
      this.member_infos.forEach(e => {
        let name = e.from_user_name
        const location = this.location_by_name(name)
        let key = "other"   // 観戦
        if (location) {
          key = location.key
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
      hv = this.hash_compact_if_blank(hv)
      return hv
    },
  },
}
