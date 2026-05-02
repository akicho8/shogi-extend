// 本譜機能

import { GX } from "@/components/models/gx.js"
import { HonpuStageInfo } from "./honpu_stage_info.js"

export const honpu_core = {
  data() {
    return {
      honpu_master: null,   // 投了したときに履歴と同じ形式のデータを1つだけ保持する
      honpu_branch: null, // 新しい手を指した最初の履歴を持つ
    }
  },
  mounted() {
    this.honpu_init()
  },
  methods: {
    // 条件
    // ・合言葉を持っていない
    // ・引数に棋譜の指定がある
    honpu_init() {
      this.tl_add("HONPU", "起動時に本譜登録する")
      if (!this.url_room_key_exist_p) {
        const body  = GX.present_p(this.$route.query.body)
        const xbody = GX.present_p(this.$route.query.xbody)
        if (body || xbody) {
          this.honpu_master_setup()
        }
      }
    },

    honpu_all_clear() {
      this.tl_add("HONPU", "全消去")
      this.honpu_master = null
      this.honpu_branch_clear()
    },

    honpu_branch_clear() {
      this.tl_add("HONPU", "ブランチ消去(time_machine_restore の中で呼んでいる)")
      this.honpu_branch = null
      this.perpetual_cop.reset$() // これがないと元に戻して同じ手を指すと千日手になる
    },

    honpu_master_setup() {
      this.tl_add("HONPU", "本譜を準備する")
      this.honpu_master = this.xhistory_create({modal_title: "本譜"})
      this.honpu_branch_clear()
    },

    honpu_master_setup_for_shortcut() {
      this.honpu_master_setup()
      this.toast_primary("現在の棋譜を本譜としました")
    },

    honpu_branch_setup(params) {
      this.tl_add("HONPU", "ブランチを初回だけ設定する", params)
      if (this.honpu_stage_info.key === "hs_honpu_only") {
        this.honpu_branch = this.xhistory_create(params)
      }
    },

    honpu_modal_toggle_handle() {
      if (this.time_machine_modal_instance) {
        this.time_machine_modal_close_handle()
      } else {
        this.honpu_modal_open_handle()
      }
    },

    honpu_modal_open_handle() {
      if (this.honpu_master) {
        this.time_machine_modal_open_handle_for_honpu(this.honpu_master)
      }
    },

    honpu_direct_return_handle() {
      this.tl_add("HONPU", "本譜に戻るをクリックしたときはダイアログを出さずに即戻る (戻ったときに音がでるためクリック音は不要)")
      if (this.honpu_stage_info.key === "hs_branching") {
        this.time_machine_restore({
          ...this.honpu_master,
          turn: this.honpu_branch.turn - 1,
          fast_forward: false,
          general_mark_clear_all: true,
          message: "分岐前に戻しました",
        })
        this.xhistory_action({label: "本譜", label_type: "is-primary", __standalone_mode__: true})
      }
    },

    honpu_click_handle() {
      if (this.honpu_return_button_active_p) {
        this.honpu_direct_return_handle()
        return
      }
      if (this.honpu_open_button_show_p) {
        this.honpu_modal_open_handle()
        return
      }
    },
  },

  computed: {
    // 本譜ボタンの表示条件
    honpu_open_button_show_p() {
      if (this.honpu_button_show_share_condition) {
        return this.honpu_stage_info.honpu_visible_p
      }
    },

    // 本譜に戻るボタンの表示条件
    honpu_return_button_active_p() {
      if (this.honpu_button_show_share_condition) {
        return this.honpu_stage_info.return_to_honpu_p
      }
    },

    // 本譜系ボタンの共通表示条件
    // ・操作モード
    // ・時計の秒針が動いていない
    honpu_button_show_share_condition() {
      return this.play_mode_p && !this.cc_play_p
    },

    // ブランチは本譜と同じ指し手をたどっているか？ (未使用)
    // たとえば、
    //   main:   a b c d e
    //   branch: a b c
    // この状態であれば true になる
    // honpu_branch_is_same_route_p() {
    //   if (this.honpu_master && this.honpu_branch) {
    //     return this.honpu_master.sfen.startsWith(this.honpu_branch.sfen) // ← 判定がバグっている
    //   }
    // },

    // 本譜から外れた？ (未使用)
    // たとえば、
    //   main:    a b c d e
    //   branch1: a b c
    //   branch2: a b c d e f
    // この状態であれば true になる
    // つまり指したら外れたことになる
    // honpu_branch_exist_p() {
    //   if (this.honpu_master && this.honpu_branch) {
    //     return this.honpu_master.sfen !== this.honpu_branch.sfen
    //   }
    // },

    honpu_stage_key() {
      if (this.honpu_master) {
        if (this.honpu_branch) {
          return "hs_branching"
        } else {
          return "hs_honpu_only"
        }
      } else {
        return "hs_honpu_none"
      }
    },

    honpu_stage_info() {
      return HonpuStageInfo.fetch(this.honpu_stage_key)
    }
  },
}
