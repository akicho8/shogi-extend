<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | トリム
      span.mx-1
        template(v-if="mode === 'from'")
          | {{index}}..{{offset}}
        template(v-if="mode === 'to'")
          | {{index}}..{{index}}+{{offset}}
    b-field.sp_turn_input
      b-numberinput(size="is-small" v-model="sp_turn" :min="0" :controls="false")
  .modal-card-body
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
      @update:turn_offset="turn_offset_set"
      )
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.reset_handle(@click="reset_handle" icon-left="undo") 元に戻す
    b-button.submit_handle(@click="from_handle" type="is-primary" v-if="mode === 'from'") {{index}}手目から
    b-button.submit_handle(@click="to_handle" type="is-primary" v-if="mode === 'to'") {{index}}+{{offset}}手目まで
</template>

<script>
export default {
  name: "SfenTrimModal",
  props: {
    default_sp_body:      { type: String, required: false, default: "",      },
    default_sp_turn:      { type: Number, required: false, default: 0,       },
    default_sp_viewpoint: { type: String, required: false, default: "black", },
    next_jump_to:         { type: String, required: false, default: "first", }, // first or last。from選択後にtoはどこから始めるか
  },
  data() {
    return {
      mode:      null, // 現在の状態 from or to
      index:     null, // 開始
      offset:    null, // 終了 (人間的には index + offset)
      base_sfen: null, // 確定した開始局面

      // ShogiPlayerのパラメータ
      sp_body:       null,
      sp_turn:       null,
      sp_viewpoint:  null,

      // ShogiPlayerの状態を受けとる用
      snapshot_sfen: null,
      turn_offset:   null,

    }
  },
  created() {
    this.reset_handle()
  },
  mounted() {
    this.talk("開始位置を決めてください")
  },
  methods: {
    turn_offset_set(v) {
      this.turn_offset = v
      this.sp_turn = v          // スライダーを動かしたときに右上の値も変化させるため
      if (this.mode === "from") {
        this.index = v
      }
      if (this.mode === "to") {
        this.offset = v
      }
    },

    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },

    reset_handle() {
      this.sp_body      = this.default_sp_body
      this.sp_turn      = this.default_sp_turn
      this.sp_viewpoint = this.default_sp_viewpoint

      this.mode = "from"
      this.index = this.sp_turn
      this.offset = this.sfen_parse(this.sp_body).moves.length
    },

    // ここから
    // this.sp_body        // 全体の FULL SFEN
    // this.turn_offset: 2 // 手目まで進めたと仮定
    // [a, b, c, d, e] の棋譜があって2からとした場合、b から始める棋譜 + c, d, e を作る
    from_handle() {
      // this.sound_play("click")
      const info = this.sfen_parse(this.sp_body)
      const moves = _.drop(info.moves, this.turn_offset)            // [a, b, c, d, e].drop(2) => [c, d, e]
      this.base_sfen = this.sfen_normalize(this.snapshot_sfen)      // bから始まる棋譜の最後の手番を1にしたもの
      this.mode = "to"                                              // 「ここまで」モードに変更
      this.sp_body = this.sfen_add_moves(this.base_sfen, moves)     // ShogiPlayer用にその手番から始まる棋譜にする
      if (this.next_jump_to === "last") {
        this.sp_turn = moves.length                                 // 最後から表示
      } else {
        this.sp_turn = 0                                            // b のところを初手とする
      }
      this.talk("終了位置を決めてください")
    },

    // ここまで
    to_handle() {
      // this.sound_play("click")

      const info = this.sfen_parse(this.sp_body)
      const moves = _.take(info.moves, this.turn_offset) // [c, d, e].drop(2) => [c, d]
      this.sp_body = this.sfen_add_moves(this.base_sfen, moves)     // ShogiPlayer用にその手番から始まる棋譜にする

      const params = {
        base_sfen: this.base_sfen,    // 開始局面
        moves:     moves,             // 範囲の moves
        viewpoint: this.sp_viewpoint, // 視点
        full_sfen: this.sp_body,      // moves を含む sfen
      }
      this.clog(params)
      this.$emit("update:submit", params)
    },

    // 1から始めるSFENに変換
    sfen_normalize(sfen) {
      return this.sfen_parse(sfen).init_sfen_from_one
    },

    // sfen に moves をくっつける
    sfen_add_moves(sfen, moves) {
      if (moves.length >= 1) {
        sfen = [sfen, "moves", ...moves].join(" ")
      }
      return sfen
    },
  },
}
</script>

<style lang="sass">
.SfenTrimModal
  +modal_width(calc(640px - 128px))

  .sp_turn_input
    max-width: 4rem

  .submit_handle
    min-width: 9rem ! important
</style>
