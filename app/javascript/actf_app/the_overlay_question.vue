<template lang="pug">
.the_overlay_question.main_content
  .primary_header
    b-icon.back_link_icon.is_clickable(icon="arrow-left" @click.native="app.board_close")
    .center_title_block.has-text-weight-bold.has-text-centered
      | {{app.overlay_question.title}}
  .secondary_header
    b-tabs.main_tabs(v-model="tab_index" expanded @change="tab_change_handle")
      b-tab-item(label="初期配置")
      template(v-for="(e, i) in app.overlay_question.moves_answers")
        b-tab-item(:label="`${i === 0 ? '解' : ''}${i + 1}`")

  .sp_container
    shogi_player(
      :run_mode="'play_mode'"
      :kifu_body="selected_sfen"
      :start_turn="-1"
      :key_event_capture="false"
      :slider_show="true"
      :controller_show="true"
      :setting_button_show="development_p"
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
  data() {
    return {
      tab_index: 0,
    }
  },
  methods: {
    tab_change_handle() {
    },

    play_mode_advanced_moves_set(moves) {
      if (this.app.overlay_question.moves_answers.some(e => e.moves_str === moves.join(" "))) {
        this.sound_play("o")
        this.ok_notice("正解")
      }
    },

    answer_sfen_for(index) {
      return [this.init_sfen, "moves", this.app.overlay_question.moves_answers[index].moves_str].join(" ")
    },
  },
  computed: {
    init_sfen() {
      return ["position", "sfen", this.app.overlay_question.init_sfen].join(" ")
    },
    selected_sfen() {
      if (this.tab_index === 0) {
        return this.init_sfen
      } else {
        return this.answer_sfen_for(this.tab_index - 1)
      }
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_overlay_question.main_content
  @extend %padding_top2
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

  .secondary_header
    .main_tabs
      a
        height: $actf_primary_header_height
        padding: 0
      .tab-content
        padding: 0
        padding-top: 0
  .sp_container
    margin-top: 1rem
</style>
