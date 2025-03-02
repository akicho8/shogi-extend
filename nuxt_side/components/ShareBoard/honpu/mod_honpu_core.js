// 本譜機能

import { Gs } from "@/components/models/gs.js"

export const mod_honpu_core = {
  data() {
    return {
      honpu_main: null,   // 投了したときに履歴と同じ形式のデータを1つだけ保持する
      honpu_branch: null, // 新しい手を指した最初の履歴を持つ
    }
  },
  mounted() {
    this.honpu_init()
  },
  methods: {
    // 起動時に本譜登録する
    // ・合言葉を持っていない
    // ・body を持っている
    honpu_init() {
      if (this.url_room_key_blank_p) {
        if (Gs.present_p(this.$route.query.body) || Gs.present_p(this.$route.query.xbody)) {
          this.honpu_main_setup()
        }
      }
    },

    // すべて削除する
    honpu_clear() {
      this.honpu_main = null
      this.honpu_branch_clear()
    },

    // al_restore の中で呼んでいる
    honpu_branch_clear() {
      this.honpu_branch = null
      this.perpetual_cop.reset() // これがないと元に戻して同じ手を指すと千日手になる
    },

    // 本譜を準備する
    honpu_main_setup() {
      this.honpu_main = this.al_create({modal_title: "本譜"})
      this.honpu_branch_clear()
    },

    // ブランチを初回だけ設定する
    honpu_branch_setup(params) {
      if (this.honpu_main) {
        if (this.honpu_branch == null) {
          this.honpu_branch = this.al_create(params)
        }
      }
    },

    // 本譜をクリックしたらダイアログを出す
    honpu_jump_click_handle() {
      if (this.honpu_main) {
        this.al_click_handle(this.honpu_main)
      }
    },

    // 本譜に戻るをクリックしたときはダイアログを出さずに即戻る
    honpu_return_click_handle() {
      if (this.honpu_main && this.honpu_branch) {
        this.$sound.play_click()
        this.al_restore({...this.honpu_main, turn: this.honpu_branch.turn - 1})
      }
    },
  },

  computed: {
    // 本譜ボタンの表示条件
    honpu_jump_button_show_p() {
      if (this.honpu_button_show_share_condition) {
        return this.honpu_main
      }
    },

    // 本譜に戻るボタンの表示条件
    honpu_return_button_show_p() {
      if (this.honpu_button_show_share_condition) {
        return this.honpu_main && this.honpu_branch
      }
    },

    // 本譜系ボタンの共通表示条件
    // ・順番設定 OFF
    // ・時計の秒針が動いていない
    honpu_button_show_share_condition() {
      return !this.order_enable_p && !this.cc_play_p
    },

    // ブランチは本譜と同じ指し手をたどっているか？ (未使用)
    // たとえば、
    //   main:   a b c d e
    //   branch: a b c
    // この状態であれば true になる
    honpu_branch_is_same_route_p() {
      if (this.honpu_main && this.honpu_branch) {
        return this.honpu_main.sfen.startsWith(this.honpu_branch.sfen)
      }
    },

    // 本譜から外れた？ (未使用)
    // たとえば、
    //   main:    a b c d e
    //   branch1: a b c
    //   branch2: a b c d e f
    // この状態であれば true になる
    // つまり指したら外れたことになる
    honpu_branch_exist_p() {
      if (this.honpu_main && this.honpu_branch) {
        return this.honpu_main.sfen !== this.honpu_branch.sfen
      }
    },
  },
}
