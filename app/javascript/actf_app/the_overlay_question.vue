<template lang="pug">
.the_overlay_question.main_content
  .primary_header
    b-icon.back_link_icon.is_clickable(icon="arrow-left" @click.native="app.board_close")
    .center_title_block.has-text-weight-bold.has-text-centered
      | {{app.overlay_question.title}}
  shogi_player(
    :run_mode="'play_mode'"
    :kifu_body="`position sfen ${app.overlay_question.init_sfen}`"
    :start_turn="0"
    :key_event_capture="false"
    :slider_show="true"
    :controller_show="true"
    :theme="'simple'"
    :size="'default'"
    :sound_effect="true"
    :volume="0.5"
    @update:play_mode_advanced_moves="play_mode_advanced_moves_set"
    )
</template>

<script>
import support from "./support.js"

export default {
  name: "the_overlay_question",
  mixins: [
    support,
  ],
  methods: {
    play_mode_advanced_moves_set(moves) {
      if (this.app.overlay_question.moves_answers.some(e => e.moves_str === moves.join(" "))) {
        this.sound_play("o")
        this.ok_notice("正解")
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_overlay_question
  @extend %padding_top1
  &.main_content
    .primary_header
      justify-content: space-between

      // 余計なタグで囲まずアイコン自体の高さを100%にすることでタッチ可能エリアを最大にする
      .back_link_icon
        height: 100%
        padding: 0 1.6rem
        z-index: 1

      // topを指定しなければ現在のY座標を保持する
      .center_title_block
        position: fixed
        left: 0%
        right: 0%
        margin: auto
</style>
