// 本譜機能

import { Gs } from "@/components/models/gs.js"

export const mod_honpu = {
  data() {
    return {
      honpu_log1: null, // 投了したときに履歴と同じ形式のデータを1つだけ保持する。共有はしない
      honpu_log2: null, // 投了したときに履歴と同じ形式のデータを1つだけ保持する。共有はしない
    }
  },
  mounted() {
    // 起動時に本譜登録する
    // ・合言葉を持っていない
    // ・body を持っている
    if (this.url_room_key_blank_p) {
      if (Gs.present_p(this.$route.query.body) || Gs.present_p(this.$route.query.xbody)) {
        this.honpu_log_set()
      }
    }
  },
  methods: {
    // 本譜を準備する
    honpu_log_set() {
      const params = {
        // win_location_key: this.current_location.flip.key, // SFENと手数を確認しなくても投了した側がすぐにわかるようにしておく
      }
      this.honpu_log1 = this.al_create(params)
      this.honpu_log2 = null
    },

    // 本譜を準備する
    honpu2_log_set(params) {
      this.honpu_log2 = this.al_create(params)
    },

    // 本譜を削除する
    honpu_log_clear() {
      this.honpu_log1 = null
      this.honpu_log2 = null
    },

    // 本譜をクリックしたときの処理
    honpu_log_click_handle() {
      if (this.honpu_log1) {
        this.al_click_handle(this.honpu_log1)
      }
    },

    // 本譜の共有
    honpu_share() {
      if (this.honpu_log1) {
        this.ac_room_perform("honpu_share", this.honpu_share_data) // --> app/channels/share_board/room_channel.rb
      }
    },
    honpu_share_broadcasted(params) {
      // 相手側で本譜とする
      if (this.received_from_self(params)) {
      } else {
        this.honpu_share_data_receive(params)
      }
    },

    honpu_share_data_receive(params) {
      this.honpu_log1 = params.honpu_log1 // FIXME: クラスが外れているのはいいのか？
    },
  },

  computed: {
    // 本譜ボタンの表示条件
    // ・本譜がある
    // ・時計の秒針が動いていない
    // ・順番設定 OFF
    honpu_button_show_p() {
      return this.honpu_log1 && !this.order_enable_p && !this.cc_play_p
    },

    honpu_share_data() {
      return {
        honpu_log1: this.honpu_log1,
      }
    },
  },
}
