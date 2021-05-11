import { ClockBox   } from "@/components/models/clock_box/clock_box.js"
import { Location } from "shogi-player/components/models/location.js"

export const application_battle_versus = {
  data() {
    return {
      vs_share_sfen: "",
      clock_box: null,
    }
  },

  beforeDestroy() {
    this.clock_box_free()
  },

  methods: {
    clock_box_free() {
      if (this.clock_box) {
        this.clock_box.timer_stop()
        this.clock_box = null
      }
    },

    membership_clock_time_format(membership) {
      return this.clock_box.single_clocks[membership.position].to_time_format
    },

    vs_func_init() {
      // this.clock_box.initial_boot_from(this.current_membership.location.code)
      this.clock_box_free()
      this.clock_box = new ClockBox({
        initial_main_sec:  this.current_rule_info.initial_main_sec,
        initial_read_sec:  this.current_rule_info.initial_read_sec,
        initial_extra_sec: this.current_rule_info.initial_extra_sec,
        every_plus:        this.current_rule_info.every_plus,
        time_zero_callback: e => {
          this.toast_ng("時間切れ")
          this.vs_func_time_zero_handle(e)
        },
      })
      this.clock_box.initial_boot_from(0) // ▲から始まる
    },

    vs_func_play_mode_advanced_full_moves_sfen_set(long_sfen) {
      this.clock_box.tap_on(this.current_membership.location)
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
        this.clock_box.tap_on(this.opponent_membership.location)
      }
    },

    vs_func_toryo_handle(ms_flip = false) {
      this.$buefy.dialog.confirm({
        message: `本当に投了しますか？`,
        confirmText: "投了する",
        cancelText: "まだねばる",
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
