<template lang="pug">
  // animation を OFF にするには空にする
  //- https://github.com/buefy/buefy/issues/1332
  .sp_show.modal-card.is-shogi-player-modal-card
    .modal-card-body
      // 自分で閉じるボタン設置。組み込みのはもともとフルスクリーンを考慮しておらず、白地に白いボタンで見えないため。
      .delete.page_delete.is-large(@click="delete_click_handle")

      template(v-if="record.title")
        .is-size-7.has-text-centered
          //- template(v-if="record.saturn_key === 'private'")
          //-   b-icon.has-text-grey-light(icon="lock" size="is-small")
          //-   | &nbsp;
          span(:style="{visibility: name_show_p ? 'visible' : 'hidden'}")
            | {{record.title}}
      template(v-if="record.description && false")
        .sp_show_desc.has-text-centered.is-size-7.has-text-grey
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
        :volume="0.5"
        :setting_button_show="false"
        :flip.sync="new_flip"
        :player_info="player_info"
        @update:start_turn="real_turn_set"
        ref="main_sp"
      )

      .sp_show_switches.has-text-centered
        // 継盤
        b-switch(v-model="run_mode" true-value="play_mode" false-value="view_mode" @input="run_mode_change_handle" size="is-small")
          b-icon(icon="source-branch" size="is-small")

        // 名前非表示
        b-switch(v-model="name_show_p" :true-value="false" :false-value="true" size="is-small")
          b-icon(icon="account-remove" size="is-small")

        // 時間
        b-switch(v-model="time_chart_p" size="is-small")
          b-icon(icon="chart-timeline-variant" size="is-small")

      sp_show_time_chart(
        v-if="time_chart_p && time_chart_params"
        :record="record"
        :time_chart_params="time_chart_params"
        @update:turn="turn_set_from_chart"
        :chart_turn="turn_offset"
        :flip="new_flip"
        ref="sp_show_time_chart"
      )

      pre(v-if="development_p")
        | start_turn: {{start_turn}}
        | turn_offset: {{turn_offset}}
        | record.turn: {{record.turn}}
        | record.display_turn: {{record.display_turn}}
        | record.critical_turn: {{record.critical_turn}}
        | record.outbreak_turn: {{record.outbreak_turn}}
        | record.turn_max: {{record.turn_max}}
        | record.turn: {{record.turn}}
        | new_flip: {{new_flip}}

    footer.modal-card-foot
      piyo_shogi_button(:href="piyo_shogi_app_with_params_url")
      kento_button(tag="a" size="is-small" @click.stop="" :href="kento_app_with_params_url")
      kif_copy_button(@click="kif_clipboard_copy({kc_path: record.show_path})")
      tweet_button(tag="a" :href="tweet_url" :turn="turn_offset" v-if="false")
      png_dl_button(tag="a" :href="png_dl_url" :turn="turn_offset")

      pulldown_menu(:record="record" :in_modal_p="true" :permalink_url="permalink_url" :turn_offset="turn_offset" :flip="new_flip" v-if="pulldown_menu_p")
</template>

<script>
import sp_show_time_chart from "./sp_show_time_chart.vue"

export default {
  name: "sp_show",
  components: {
    sp_show_time_chart,
  },

  props: {
    record:          { required: true   }, // バトル情報
    pulldown_menu_p: { default: true,   }, // 右のプルダウンを表示する？
    board_show_type: { default: "none", }, // どの局面から開始するか
  },

  data() {
    return {
      run_mode: null,      // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      turn_offset: null,   // KENTOに渡すための手番
      name_show_p: true,   // プレイヤーの名前を表示する？
      new_flip: null,      // 上下反転している？

      time_chart_p: false,     // 時間チャートを表示する？
      time_chart_params: null, // 時間チャートのデータ
    }
  },

  beforeCreate() {
    window.history.pushState(this.$options.name, null, this.permalink_url)
  },

  beforeDestroy() {
  },

  created() {
    this.record_setup()
    this.chart_show_auto()
    this.slider_focus_delay()
  },

  mounted() {
    this.$gtag.event("open", {event_category: "盤面"})
  },

  watch: {
    permalink_url() {
      window.history.replaceState("", null, this.permalink_url)
    },
    time_chart_p() {
      if (this.time_chart_p) {
        if (!this.time_chart_params) {
          this.remote_get(this.record.show_path, { time_chart_fetch: true }, data => {
            this.time_chart_params = data.time_chart_params
          })
        }
      }
    }
  },

  methods: {
    delete_click_handle() {
      this.$emit("close")
      window.history.back()
    },

    // バトル情報がセットされたタイミングまたは変更されたタイミング
    record_setup() {
      // 開始手数を保存 (KENTOに渡すためでもある)
      this.turn_offset = this.start_turn

      // 継盤解除
      this.run_mode = "view_mode"

      // 最初の上下反転状態
      this.new_flip = this.record.flip

      // 指し手がない棋譜の場合は再生モード(view_mode)に意味がないため継盤モード(play_mode)で開始する
      // これは勝手にやらない方がいい？
      if (true) {
        if (this.record.turn_max === 0) {
          this.run_mode = "play_mode"
        }
      }
    },

    // 「チャート表示→閉じる→別レコード開く」のときに別レコードの時間チャートを開く
    // 本当は sp_show_time_chart の中で処理したかった
    chart_show_auto() {
      if (this.time_chart_p) {
        this.$nextTick(() => { this.$refs.sp_show_time_chart.chart_show() })
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
      if (this.board_show_type === "last") {
        return record.turn_max
      }
      return record.display_turn
    },

    // sp_show_time_chart でチャートをクリックしたときに変更する
    turn_set_from_chart(v) {
      this.$refs.main_sp.api_board_turn_set(v) // 直接 shogi-player に設定
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
      const url = new URL(this.as_full_url(this.record.modal_on_index_path))
      url.searchParams.set("turn", this.turn_offset)
      url.searchParams.set("flip", this.new_flip)
      return url.toString()
    },

    // これはメソッドにする必要なかったけどまぁいい
    png_dl_url() {
      const params = new URLSearchParams()
      params.set("attachment", true)
      params.set("turn", this.turn_offset)
      params.set("flip", this.new_flip)
      return `${this.record.show_path}.png?${params}`
    },

    piyo_shogi_app_with_params_url() { return this.piyo_shogi_auto_url({path: this.record.show_path, sfen: this.record.sfen_body, turn: this.turn_offset, flip: this.new_flip, ...this.record.piyo_shogi_base_params}) },
    kento_app_with_params_url()      { return this.kento_full_url({sfen: this.record.sfen_body, turn: this.turn_offset, flip: this.new_flip}) },

    tweet_url() {
      return this.tweet_intent_url(this.permalink_url)
    },
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.sp_show
  .is-shogi-player-modal-card
    width: auto

  // 継盤
  .sp_show_switches
    margin-top: 0.5rem
    .switch
      margin: 0 1rem

  // 説明分
  .sp_show_desc
    // margin-top: 0.8rem

  // .title
  //   border: 1px solid blue
  //   margin-top: 0px

  //////////////////////////////////////////////////////////////////////////////// フッターのボタンの配置(is-shogi-player-modal-card の方で指定あり)
  // .modal-card-foot
  //   justify-content: space-around

  ////////////////////////////////////////////////////////////////////////////// _sp_show
  // .modal_loading_content
  //   width: 40vmin
  //   height: 40vmin
</style>
