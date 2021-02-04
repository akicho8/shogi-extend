<template lang="pug">
.modal-card.FixedSfenConfirmModal
  header.modal-card-head
    p.modal-card-title.is-size-6
      //- template(v-if="mode === 'from'") 初期配置とする局面を決めてください
      //- template(v-if="mode === 'to'") 正解手順の最後の局面まで進めてください
      template(v-if="mode === 'from'") 初期配置の局面
      template(v-if="mode === 'to'") 正解手順の局面
  section.modal-card-body
    CustomShogiPlayer(
      sp_mobile_vertical="is_mobile_vertical_off"
      sp_run_mode="view_mode"
      :sp_body="sp_body"
      :sp_turn="sp_turn"
      :sp_viewpoint.sync="sp_viewpoint"
      :sp_sound_body_changed="false"
      :sp_board_cell_left_click_user_handle="() => true"
      sp_summary="is_summary_off"
      sp_slider="is_slider_on"
      sp_controller="is_controller_on"
      @update:mediator_snapshot_sfen="v => snapshot_sfen = v"
      @update:turn_offset="v => turn_offset = v"
      )
  footer.modal-card-foot
    .mx-4(v-if="development_p")
      | sp_turn:{{sp_turn}}
      | turn_offset:{{turn_offset}}
      | snapshot_sfen:{{snapshot_sfen}}
      | moves:{{moves}}
    //- b-button(@click="from_handle" type="is-primary" v-if="mode === 'from'") この局面を初期配置とする
    //- b-button(@click="to_handle" type="is-primary" v-if="mode === 'to'") ここまでの手順を正解とする
    b-button(@click="from_handle" type="is-primary" v-if="mode === 'from'") 決定
    b-button(@click="to_handle" type="is-primary" v-if="mode === 'to'") 決定
</template>

<script>
export default {
  name: "FixedSfenConfirmModal",
  props: {
    default_sp_body:      { type: String, required: true, },
    default_sp_turn:      { type: Number, required: true, },
    default_sp_viewpoint: { type: String, required: true, },
  },
  data() {
    return {
      mode: "from", // 現在の状態 from or to

      // ShogiPlayerのパラメータ
      sp_body:      this.default_sp_body,
      sp_turn:      this.default_sp_turn,
      sp_viewpoint: this.default_sp_viewpoint,

      // ShogiPlayerの状態を受けとる用
      snapshot_sfen: null,
      turn_offset:   null,

      // 戻値用
      from_sfen: null, // movesがないsfen
      moves:     null, // 指し手
    }
  },
  mounted() {
    this.talk("初期配置とする局面を決めてください")
  },
  methods: {
    // ここから
    // this.sp_body        // 全体の FULL SFEN
    // this.turn_offset: 2 // 手目まで進めたと仮定
    // [a, b, c, d, e] の棋譜があって2からとした場合、b から始める棋譜 + c, d, e を作る
    from_handle() {
      // this.sound_play("click")

      const info = this.sfen_parse(this.sp_body)
      const moves = _.drop(info.moves, this.turn_offset)    // [a, b, c, d, e].drop(2) => [c, d, e]
      this.snapshot_sfen = this.sfen_normalize(this.snapshot_sfen) // bから始まる棋譜の最後の手番を1にしたもの
      this.from_sfen = this.snapshot_sfen                    // 初期配置確定
      this.mode = "to"                                      // 「ここまで」モードに変更
      this.talk("正解手順の最後の局面まで進めてください")

      // ShogiPlayer用にその手番から始まる棋譜にする
      if (true) {
        if (moves.length >= 1) {
          this.sp_body = [this.snapshot_sfen, "moves", ...moves].join(" ") // c, d, e をくっつける
        } else {
          this.sp_body = this.snapshot_sfen
        }
        this.sp_turn = 0 // b のところを初手とする
      }

    },

    // ここまで
    to_handle() {
      this.sound_play("click")

      const info = this.sfen_parse(this.sp_body)
      const moves = _.take(info.moves, this.turn_offset) // [c, d, e].drop(2) => [c, d]
      this.moves = moves        // 指し手を確定 [c, d]

      const params = {
        from_sfen: this.from_sfen,
        moves:     this.moves,
        viewpoint: this.sp_viewpoint,
      }
      this.clog(params)
      this.$emit("update:submit", params)
    },

    // 1から始めるSFENに変換
    sfen_normalize(sfen) {
      return this.sfen_parse(sfen).init_sfen_from_one
    },
  },
}
</script>

<style lang="sass">
.FixedSfenConfirmModal
  .modal-card-body
    +mobile
      padding: 0
      padding-top: 1.5rem
      padding-bottom: 1rem
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
