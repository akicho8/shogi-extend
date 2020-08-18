export const application_battle_sy_versus = {
  data() {
    return {
      vs_share_sfen: "",
    }
  },

  methods: {
    vs_func_play_mode_advanced_full_moves_sfen_set(long_sfen) {
      this.debug_alert(long_sfen)
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
      this.vs_func_play_board_share(long_sfen)
      //   }
      //
      //   if (this.current_question.sfen_valid_p(long_sfen)) {
      //     this.kotae_sentaku("correct")
      //   }
      // }
    },

    vs_func_play_board_share(vs_share_sfen) {
      this.ac_battle_perform("vs_func_play_board_share", { // 戻値なし
        vs_share_sfen: vs_share_sfen,
      }) // --> app/channels/actb/battle_channel.rb
    },
    vs_func_play_board_share_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
        // 自分は操作中なので何も変化させない
        this.debug_alert("自分受信")
      } else {
        this.debug_alert("相手受信")
        // 自分の操作を相手の盤面で動かす
        this.vs_share_sfen = params.vs_share_sfen
        // this.sound_play("pishi") // shogi-player で音が鳴らないのでここで鳴らす
      }
    },

    vs_func_toryo_handle(ms_flip = false) {
      this.ac_battle_perform("vs_func_toryo_handle", {ms_flip: ms_flip})
    },
    vs_func_toryo_handle_broadcasted(params) {
      if (params.membership_id === this.current_membership.id) {
      } else {
      }
    },
  },
  computed: {
  },
}
