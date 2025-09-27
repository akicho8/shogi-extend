<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | トリム
      span.mx-1
        template(v-if="mode === 'begin'")
          | {{index}}..{{offset}}
        template(v-if="mode === 'end'")
          | {{index}}..{{index}}+{{offset}}
    b-field.sp_turn_input
      b-numberinput(size="is-small" v-model="sp_turn" :min="0" :controls="false")
  .modal-card-body
    CustomShogiPlayer(
      :sp_mobile_vertical="false"
      sp_mode="view"
      :sp_body="sp_body"
      :sp_turn="sp_turn"
      :sp_viewpoint.sync="viewpoint"
      :sp_board_cell_left_click_user_handle="() => true"
      sp_slider
      sp_controller
      @ev_short_sfen_change="v => short_sfen = v"
      @ev_turn_offset_change="ev_turn_offset_change"
      )
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left")
    b-button.undo_handle(@click="undo_handle" icon-left="undo")
    b-button.apply_handle(@click="begin_apply" type="is-primary" v-if="mode === 'begin'") {{index}}手目から
    b-button.apply_handle(@click="end_apply" type="is-primary" v-if="mode === 'end'") {{index}}+{{offset}}手目まで
    b-button.apply_handle(@click="apply_handle" type="is-primary" v-if="mode === 'done'") 確定
</template>

<script>
export default {
  name: "SfenTrimModal",
  props: {
    default_sp_body:      { type: String, required: true,  default: "",      },
    default_sp_turn:      { type: Number, required: false, default: 0,       },
    default_sp_viewpoint: { type: String, required: false, default: "black", },
    next_jump_to:         { type: String, required: false, default: "first", }, // first or last。begin選択後にendはどこから始めるか
  },
  data() {
    return {
      mode:          null, // 現在の状態 begin | end | done
      index:         null, // 開始
      offset:        null, // 終了 (人間的には index + offset)
      base_sfen:     null, // 確定した開始局面
      emit_params:   null, // emit で返すパラメータ

      // done から end 確定直前に戻るために保持する
      save_sp_done:      null,
      save_sp_turn:      null,

      // ShogiPlayerのパラメータ
      sp_body:       null,
      sp_turn:       null,
      viewpoint:  null,

      // ShogiPlayerの状態を受けとる用
      short_sfen: null,
      turn_offset:   null,

    }
  },
  beforeMount() {
    this.begin_setup()
  },
  methods: {
    ev_turn_offset_change(v) {
      this.turn_offset = v
      this.sp_turn = v          // スライダーを動かしたときに右上の値も変化させるため
      if (this.mode === "begin") {
        this.index = v
      }
      if (this.mode === "end") {
        this.offset = v
      }
    },

    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },

    undo_handle() {
      this.sfx_click()
      if (this.mode === "begin") {
        this.silent_reset()
        return
      }
      if (this.mode === "end") {
        this.begin_setup()
        return
      }
      if (this.mode === "done") {
        this.sp_body = this.save_sp_done
        this.sp_turn = this.save_sp_turn
        this.end_setup()
        return
      }
    },

    silent_reset() {
      this.sp_body      = this.default_sp_body
      this.sp_turn      = this.default_sp_turn
      this.viewpoint = this.default_sp_viewpoint

      this.index = this.sp_turn
      this.$gs.assert(this.$gs.present_p(this.sp_body), "this.$gs.present_p(this.sp_body)")
      this.offset = this.sfen_parse(this.sp_body).moves.length
      this.emit_params = null
      this.mode = "begin"
    },

    begin_setup() {
      this.silent_reset()
      this.talk("開始位置を決めてください")
    },

    // ここから
    // this.sp_body        // 全体の FULL SFEN
    // this.turn_offset: 2 // 手目まで進めたと仮定
    // [a, b, c, d, e] の棋譜があって2からとした場合、b から始める棋譜 + c, d, e を作る
    begin_apply() {
      this.sfx_click()
      const info = this.sfen_parse(this.sp_body)
      const moves = _.drop(info.moves, this.turn_offset)            // [a, b, c, d, e].drop(2) => [c, d, e]
      this.base_sfen = this.sfen_normalize(this.short_sfen)      // bから始まる棋譜の最後の手番を1にしたもの
      this.sp_body = this.sfen_add_moves(this.base_sfen, moves)     // ShogiPlayer用にその手番から始まる棋譜にする
      if (this.next_jump_to === "last") {
        this.sp_turn = moves.length                                 // 最後から表示
      } else {
        this.sp_turn = 0                                            // b のところを初手とする
      }
      this.end_setup()
    },

    end_setup() {
      this.mode = "end"                                              // 「ここまで」モードに変更
      this.talk("終了位置を決めてください")
    },

    // ここまで
    end_apply() {
      this.sfx_click()

      // done から end する前の状態に戻るために保持
      this.save_sp_done = this.sp_body
      this.save_sp_turn = this.turn_offset

      const info = this.sfen_parse(this.sp_body)
      const moves = _.take(info.moves, this.turn_offset) // [c, d, e].drop(2) => [c, d]

      this.sp_body = this.sfen_add_moves(this.base_sfen, moves)     // ShogiPlayer用にその手番から始まる棋譜にする

      this.emit_params = {
        base_sfen: this.base_sfen,    // 開始局面
        moves:     moves,             // 範囲の moves
        viewpoint: this.viewpoint, // 視点
        full_sfen: this.sp_body,      // moves を含む sfen
      }
      this.clog(this.emit_params)
      this.mode = "done"        // 確定へ
      this.talk("これでよいですか？")
    },

    // 確定
    apply_handle() {
      this.sfx_click()
      this.$emit("update:apply", this.emit_params)
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
  +modal_width(512px)

  .sp_turn_input
    max-width: 4rem

  // .apply_handle
  //   +tablet
  //     min-width: 9rem ! important
</style>
