<template lang="pug">
  b-modal.sp_modal(:active.sync="new_modal_p" trap-focus animation="zoom-in" :full-screen="true" :can-cancel="['escape', 'outside']" :has-modal-card="true" v-if="record")
    .modal-card.is-shogi-player-modal-card
      .modal-card-body
        // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
        .delete.is-medium(aria-label="close" @click="new_modal_p = false" v-if="true")

        template(v-if="record.title")
          .title.is-5.yumincho.has-text-centered
            template(v-if="record.saturn_key === 'private'")
              b-icon.has-text-grey-light(icon="lock" size="is-small")
              | &nbsp;
            span(:style="{visibility: player_info_show_p ? 'visible' : 'hidden'}")
              | {{record.title}}

        shogi_player(
          :run_mode.sync="run_mode"
          :debug_mode="false"
          :start_turn="start_turn"
          :kifu_body="record.sfen_body"
          :key_event_capture="true"
          :slider_show="true"
          :sfen_show="false"
          :controller_show="true"
          :theme="'simple'"
          :size="'medium'"
          :sound_effect="true"
          :volume="0.2"
          :setting_button_show="false"
          :flip="record.fliped"
          :player_info="player_info"
          @update:start_turn="real_turn_set"
          ref="sp_modal"
        )

        .sp_modal_switches.has-text-centered
          // 継盤
          b-switch(v-model="run_mode" true-value="play_mode" false-value="view_mode" @input="run_mode_change_handle" size="is-small")
            b-icon(icon="source-branch" size="is-small")
          // 名前非表示
          b-switch(v-model="player_info_show_p" :true-value="false" :false-value="true" size="is-small")
            b-icon(icon="eye-off" size="is-small")
          // 時間
          b-switch(v-model="time_chart_p" size="is-small")
            b-icon(icon="clock-outline" size="is-small")

        template(v-if="record.description")
          .sp_modal_desc.has-text-centered.is-size-7.has-text-grey
            | {{record.description}}

        .time_chart_container(v-show="time_chart_p")
          canvas#think_canvas(ref="think_canvas")

        pre(v-if="development_p")
          | start_turn: {{start_turn}}
          | turn_offset: {{turn_offset}}
          | record.force_turn: {{record.force_turn}}
          | record.sp_turn: {{record.sp_turn}}
          | record.critical_turn: {{record.critical_turn}}
          | record.outbreak_turn: {{record.outbreak_turn}}
          | record.turn_max: {{record.turn_max}}

      footer.modal-card-foot
        piyo_shogi_button(@click.stop="" type="button" :href="record.piyo_shogi_app_url")
        kento_button(tag="a" size="is-small" @click.stop="" :href="`${record.kento_app_url}#${turn_offset}`" :turn="turn_offset")
        kif_copy_button(@click="kif_clipboard_copy(record.kifu_copy_params)" v-if="record.kifu_copy_params")

        pulldown_menu(:record="record" :in_modal_p="true" :turn_offset="turn_offset" v-if="pulldown_menu_p")
        a.button.is-small(@click="new_modal_p = false" v-if="false") 閉じる
</template>

<script>
import sp_modal_time_chart from "./sp_modal_time_chart.js"

export default {
  name: "sp_modal",
  mixins: [
    sp_modal_time_chart,
  ],

  props: {
    record:          {                  }, // バトル情報
    sp_modal_p:      {                  }, // 表示する？
    pulldown_menu_p: { default: true,   }, // 右のプルダウンを表示する？
    board_show_type: { default: "none", }, // どの局面から開始するか
  },

  data() {
    return {
      new_modal_p: this.sp_modal_p,    // sp_modal_p の内部の値
      run_mode: null,                  // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      turn_offset: null,
      player_info_show_p: true,      // プレイヤーの名前を表示する？
    }
  },

  watch: {
    sp_modal_p(v)  { this.new_modal_p = v }, // 外→内 sp_modal_p --> new_modal_p
    new_modal_p(v) {                         // 外←内 sp_modal_p <-- new_modal_p
      if (v) {
        this.slider_focus_delay()
      }
      this.$emit("update:sp_modal_p", v)
    },

    // バトル情報がセットされたタイミングまたは変更されたタイミング
    record(v) {
      if (v) {
        // 開始手数を保存 (KENTOに渡すためでもある)
        this.turn_offset = this.start_turn

        // 継盤解除
        this.run_mode = "view_mode"

        // 指し手がない棋譜の場合は再生モード(view_mode)に意味がないため継盤モード(play_mode)で開始する
        // これは勝手にやらない方がいい？
        if (true) {
          if (v.turn_max === 0) {
            this.run_mode = "play_mode"
          }
        }

        this.time_chart_fetch_counter = 0
        // this.$nextTick(() => { this.time_handle() })
      }
    },
  },

  methods: {
    // マウスで操作したときだけ呼べる
    run_mode_change_handle(v) {
      let message = null
      if (v === "play_mode") {
        message = "駒を操作できます"
      } else {
        message = "元に戻しました"
      }
      this.simple_notify(message)
      this.slider_focus_delay()
    },

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    start_turn_for(record) {
      if (record) {
        if (this.board_show_type === "last") {
          return record.turn_max
        }

        // modal_record の場合
        if ("force_turn" in record) {
          return record.force_turn
        }

        return record.sp_turn
      }
    },

    // shogi-player の局面が変化したときの手数を取り出す
    real_turn_set(v) {
      this.turn_offset = v
    },

    // this.$nextTick(() => this.slider_focus()) の方法だと失敗する
    slider_focus_delay() {
      setTimeout(() => this.slider_focus(), 1)
    },

    // $el は使えるタイミング難しいため普通に document から探す
    slider_focus() {
      const dom = document.querySelector(".turn_slider")
      if (dom) {
        dom.focus()
      }
    },
  },

  computed: {
    start_turn() {
      return this.start_turn_for(this.record)
    },

    player_info() {
      if (this.player_info_show_p) {
        return this.record.player_info
      }
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.sp_modal
  .is-shogi-player-modal-card
    width: auto

  // 閉じボタン
  .delete
    position: absolute
    top: 0.6rem
    left: 0.6rem

  // 上のスペース
  .modal-card-body
    padding-top: 3em

  // 継盤
  .sp_modal_switches
    margin-top: 0.5rem
    .switch
      margin: 0 1rem

  // 説明分
  .sp_modal_desc
    margin-top: 0.8rem

  //////////////////////////////////////////////////////////////////////////////// フッターの色を取る場合
  .modal-card-foot
    border: none
    background-color: $scheme-main

  //////////////////////////////////////////////////////////////////////////////// フッターのボタンの配置(is-shogi-player-modal-card の方で指定あり)
  // .modal-card-foot
  //   justify-content: space-around

  ////////////////////////////////////////////////////////////////////////////// _sp_modal
  // .modal_loading_content
  //   width: 40vmin
  //   height: 40vmin
  .time_chart_container
    margin-top: 1rem

</style>
