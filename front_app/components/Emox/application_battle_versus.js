import { ChessClock   } from "@/components/models/ChessClock.js"
import Location from "shogi-player/src/location.js"

export const application_battle_versus = {
  data() {
    return {
      vs_share_sfen: "",
      chess_clock: null,
    }
  },

  beforeDestroy() {
    this.chess_clock_free()
  },

  methods: {
    chess_clock_free() {
      if (this.chess_clock) {
        this.chess_clock.timer_stop()
        this.chess_clock = null
      }
    },

    vs_func_init() {
      // this.chess_clock.initial_boot_from(this.current_membership.location.code)
      this.chess_clock_free()
      this.chess_clock = new ChessClock({
        initial_main_sec: 60*3,
        initial_read_sec:0,
        initial_extra_sec: 0,
        every_plus:0,

        time_zero_callback: e => {
          // this.sound_play("lose")
          this.toast_ng("時間切れ")
          // this.$buefy.dialog.alert({
          //   message: "時間切れ",
          //   onConfirm: () => { this.stop_handle() },
          // })
          this.vs_func_time_zero_handle(e)
        },
      })
      this.chess_clock.initial_boot_from(0) // ▲から始まる
    },

    vs_func_play_mode_advanced_full_moves_sfen_set(long_sfen) {
      this.chess_clock.single_clocks[this.current_membership.location.code].simple_switch_handle()
      this.vs_func_play_board_share(long_sfen)
    },

    vs_func_play_board_share(vs_share_sfen) {
      this.ac_battle_perform("vs_func_play_board_share", { // 戻値なし
        vs_share_sfen: vs_share_sfen,
      }) // --> app/channels/emox/battle_channel.rb
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
        this.chess_clock.single_clocks[this.opponent_membership.location.code].simple_switch_handle()
      }
    },

    vs_func_toryo_handle(ms_flip = false) {
      this.$buefy.dialog.confirm({
        message: `本当に投了しますか？`,
        confirmText: "投了する",
        cancelText: "もう少しねばる",
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
