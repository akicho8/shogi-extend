<template lang="pug">
  b-modal.sp_modal(:active.sync="new_modal_p" trap-focus animation="zoom-in" :full-screen="true" :can-cancel="['escape', 'outside']" :has-modal-card="true" v-if="record")
    .modal-card.is-shogi-player-modal-card
      .modal-card-body
        // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
        .delete.is-medium(aria-label="close" @click="new_modal_p = false" v-if="true")

        template(v-if="record.title")
          .is-size-7.has-text-centered
            //- template(v-if="record.saturn_key === 'private'")
            //-   b-icon.has-text-grey-light(icon="lock" size="is-small")
            //-   | &nbsp;
            span(:style="{visibility: name_show_p ? 'visible' : 'hidden'}")
              | {{record.title}}
        template(v-if="record.description && false")
          .sp_modal_desc.has-text-centered.is-size-7.has-text-grey
            | {{record.description}}

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
          b-switch(v-model="name_show_p" :true-value="false" :false-value="true" size="is-small")
            b-icon(icon="eye-off" size="is-small")
          // 時間
          b-switch(v-model="time_chart_p" size="is-small")
            b-icon(icon="chart-timeline-variant" size="is-small")

        sp_modal_time_chart(:record="record" :show_p="time_chart_p" ref="sp_modal_time_chart" @update:turn="turn_set_from_chart" refs="sp_modal_time_chart")

        pre(v-if="development_p")
          | start_turn: {{start_turn}}
          | turn_offset: {{turn_offset}}
          | record.turn: {{record.turn}}
          | record.display_turn: {{record.display_turn}}
          | record.critical_turn: {{record.critical_turn}}
          | record.outbreak_turn: {{record.outbreak_turn}}
          | record.turn_max: {{record.turn_max}}

      footer.modal-card-foot
        piyo_shogi_button(@click.stop="" type="button" :href="record.piyo_shogi_app_url")
        kento_button(tag="a" size="is-small" @click.stop="" :href="`${record.kento_app_url}#${turn_offset}`" :turn="turn_offset")
        kif_copy_button(@click="kif_clipboard_copy(record.kifu_copy_params)" v-if="record.kifu_copy_params")
        tweet_button(tag="a" :href="tweet_url")

        pulldown_menu(:record="record" :in_modal_p="true" :permalink_url="permalink_url" v-if="pulldown_menu_p")
        a.button.is-small(@click="new_modal_p = false" v-if="false") 閉じる
</template>

<script>
import sp_modal_time_chart from "./sp_modal_time_chart.vue"

export default {
  name: "sp_modal",
  components: {
    sp_modal_time_chart,
  },

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
      turn_offset: null,               // KENTOに渡すための手番
      name_show_p: true,        // プレイヤーの名前を表示する？
      time_chart_p: false,             // 時間チャートを表示する？
    }
  },

  watch: {
    sp_modal_p(v)  { this.new_modal_p = v }, // 外→内 sp_modal_p --> new_modal_p
    new_modal_p(v) {                         // 外←内 sp_modal_p <-- new_modal_p
      if (v) {
        this.chart_show_auto()
        this.slider_focus_delay()
      } else {
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
      }
    },
  },

  mounted() {
  },

  methods: {
    // 「チャート表示→閉じる→別レコード開く」のときに別レコードの時間チャートを開く
    // 本当は sp_modal_time_chart の中で処理したかった
    chart_show_auto() {
      if (this.time_chart_p) {
        this.$nextTick(() => { this.$refs.sp_modal_time_chart.chart_show() })
      }
    },

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
    // turn start_turn critical_turn の順に見る
    // turn は $options.modal_record にのみ入っている
    start_turn_for(record) {
      if (record) {
        if (this.board_show_type === "last") {
          return record.turn_max
        }

        // modal_record の場合
        if ("turn" in record) {
          return record.turn
        }

        return record.display_turn
      }
    },

    // sp_modal_time_chart でチャートをクリックしたときに変更する
    turn_set_from_chart(v) {
      this.$refs.sp_modal.api_board_turn_set(v) // 直接 shogi-player に設定
      this.turn_offset = v                      // KENTO用に設定 (shogi-playerからイベントが来ないため)
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
      if (this.name_show_p) {
        return this.record.player_info
      }
    },

    permalink_url() {
      if (this.record) {
        const url = new URL(this.record.modal_on_index_url)
        if (this.turn_offset != null) {
          url.searchParams.set("turn", this.turn_offset)
        }
        return url.toString()
      }
    },

    tweet_url() {
      return this.tweet_url_for(this.permalink_url)
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
    z-index: 2                  // shogi-player の「○手目」のdivより下にあって押せない場合があるため指定する必要がある

  // 上のスペース
  .modal-card-body
    padding: 0
    padding-top: 0.5rem

  // 継盤
  .sp_modal_switches
    margin-top: 0.5rem
    .switch
      margin: 0 1rem

  // 説明分
  .sp_modal_desc
    // margin-top: 0.8rem

  //////////////////////////////////////////////////////////////////////////////// フッターの色を取る場合
  .modal-card-foot
    border: none
    background-color: $scheme-main

  // .title
  //   border: 1px solid blue
  //   margin-top: 0px

  //////////////////////////////////////////////////////////////////////////////// フッターのボタンの配置(is-shogi-player-modal-card の方で指定あり)
  // .modal-card-foot
  //   justify-content: space-around

  ////////////////////////////////////////////////////////////////////////////// _sp_modal
  // .modal_loading_content
  //   width: 40vmin
  //   height: 40vmin
</style>
