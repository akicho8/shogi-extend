import { ClockBox   } from "@/components/models/clock_box/clock_box.js"
import { Location } from "shogi-player/components/models/location.js"

export const application_battle_sy_versus = {
  data() {
    return {
      vs_share_sfen: "",
      clock_box: null,
    }
  },

  created() {
    this.clock_box = new ClockBox({time_zero_callback: e => {
      this.vs_func_time_zero_handle(e)
    }})
  },

  methods: {
    vs_func_init() {
      // this.clock_box.initial_boot_from(this.current_membership.location.code)
      this.clock_box.initial_boot_from(0) // ▲から始まる
    },

    vs_func_play_mode_advanced_full_moves_sfen_set(e) {
      this.debug_alert(e.sfen)
      // if (this.sub_mode === "sm4_tactic") {
      //
      //   if (this.current_strategy_key === "sy_singleton") {
      //     // 安全のため残り0秒になってから操作しても無効とする
      //     if (this.ops_rest_seconds === 0) {
      //       return
      //     }
      //
      //     // 駒を1つでも動かしたら3秒に復帰する
      //     if (this.x_mode === "x2_play") {
      //       this.ops_interval_restart()
      //     }
      //
      this.clock_box.tap_on(this.current_membership.location)
      this.vs_func_play_board_share(e.sfen)
      //   }
      //
      //   if (this.current_question.sfen_valid_p(e.sfen)) {
      //     this.kotae_sentaku("correct")
      //   }
      // }
    },

    vs_func_play_board_share(vs_share_sfen) {
      this.ac_battle_perform("vs_func_play_board_share", { // 戻値なし
        vs_share_sfen: vs_share_sfen,
      }) // --> base/channels/actb/battle_channel.rb
    },
    vs_func_play_board_share_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
        // 自分は操作中なので何も変化させない、けど変数には入れておきたい
        this.vs_share_sfen = params.vs_share_sfen
        this.debug_alert("自分受信")
      } else {
        this.debug_alert("相手受信")
        // 自分の操作を相手の盤面で動かす
        this.vs_share_sfen = params.vs_share_sfen
        // this.sound_play("piece_sound") // shogi-player で音が鳴らないのでここで鳴らす
      }
    },

    vs_func_toryo_handle(ms_flip = false) {
      this.$buefy.dialog.confirm({
        title: "投了",
        message: `本当によいか？`,
        confirmText: "投了する",
        cancelText: "考え直す",
        type: "is-danger",
        hasIcon: false,
        trapFocus: true,
        animation: "",
        onConfirm: () => {
          this.ac_battle_perform("vs_func_toryo_handle", {ms_flip: ms_flip, vs_share_sfen: this.vs_share_sfen})
        },
        onCancel: () => { this.debug_alert("キャンセル") },
      })
    },
    vs_func_toryo_handle_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
      } else {
      }
    },

    vs_func_time_zero_handle(single_clock, ms_flip = false) {
      const membership = this.battle.memberships[single_clock.location.code]
      if (membership.id === this.current_membership.id) {
        this.ac_battle_perform("vs_func_time_zero_handle", {ms_flip: ms_flip, vs_share_sfen: this.vs_share_sfen})
      }
    },
    vs_func_time_zero_handle_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
      } else {
      }
    },
  },
  computed: {
  },
}
