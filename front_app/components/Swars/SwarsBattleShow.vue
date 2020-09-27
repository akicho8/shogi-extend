<template lang="pug">
.SwarsBattleShow(v-if="!$fetchState.pending")
  .delete.is-large(@click="delete_click_handle")

  b-navbar(type="is-primary")
    template(slot="brand")
      b-navbar-item.has-text-weight-bold(tag="div") {{record.title}}
    template(slot="end")
      //- b-navbar-item
      //-   PiyoShogiButton(:href="piyo_shogi_app_with_params_url")
      //- b-navbar-item
      //-   KentoButton(tag="a" size="is-small" @click.stop="" :href="kento_app_with_params_url")
      //- b-navbar-item
      //-   KifCopyButton(@click="kif_clipboard_copy({kc_path: record.show_path})")
      //- b-navbar-item
      //-   TweetButton(tag="a" :href="tweet_url" :turn="turn_offset" v-if="false")
      b-navbar-item(tag="a" href="/") TOP

  .columns
    .column
      MyShogiPlayer.mt-5(
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
        :setting_button_show="false"
        :flip.sync="new_flip"
        :player_info="player_info"
        @update:start_turn="real_turn_set"
        ref="main_sp"
      )

      .has-text-centered.mt-4
        b-switch(v-model="run_mode" true-value="play_mode" false-value="view_mode" @input="run_mode_change_handle")
          b-icon(icon="source-branch")

      .buttons.is-centered.mt-5
        PiyoShogiButton(:href="piyo_shogi_app_with_params_url")
        KentoButton(tag="a" size="is-small" @click.stop="" :href="kento_app_with_params_url")
        KifCopyButton(@click="kif_clipboard_copy({kc_path: record.show_path})")
        TweetButton(tag="a" :href="tweet_url" :turn="turn_offset" v-if="false")
        PngDlButton(tag="a" :href="png_dl_url" :turn="turn_offset")
        PulldownMenu(:record="record" :in_modal_p="true" :permalink_url="permalink_url" :turn_offset="turn_offset" :flip="new_flip" v-if="pulldown_menu_p")

    .column
      SwarsBattleShowTimeChart(
        v-if="record && time_chart_params"
        :record="record"
        :time_chart_params="time_chart_params"
        @update:turn="turn_set_from_chart"
        :chart_turn="turn_offset"
        :flip="new_flip"
        ref="SwarsBattleShowTimeChart"
      )

  //-   pre(v-if="development_p")
  //-     | start_turn: {{start_turn}}
  //-     | turn_offset: {{turn_offset}}
  //-     | record.turn: {{record.turn}}
  //-     | record.display_turn: {{record.display_turn}}
  //-     | record.critical_turn: {{record.critical_turn}}
  //-     | record.outbreak_turn: {{record.outbreak_turn}}
  //-     | record.turn_max: {{record.turn_max}}
  //-     | record.turn: {{record.turn}}
  //-     | new_flip: {{new_flip}}
</template>

<script>
export default {
  name: "SwarsBattleShow",
  props: {
    user_key:        { type: String, required: true, },
    pulldown_menu_p: { default: true,                }, // 右のプルダウンを表示する？
    board_show_type: { default: "none",              }, // どの局面から開始するか
  },
  data() {
    return {
      record: null,            // 属性がたくさん入ってる

      run_mode: null,          // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      turn_offset: null,       // KENTOに渡すための手番
      new_flip: null,          // 上下反転している？

      time_chart_p: false,     // 時間チャートを表示する？
      time_chart_params: null, // 時間チャートのデータ
    }
  },
  fetch() {
    // alert("fetch")
    // alert(this.user_key)
    // console.log(this)

    // console.log(this.$route.query)
    // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
    // http://0.0.0.0:4000/swars/users/devuser1

    // http://0.0.0.0:3000/w/devuser1-Yamada_Taro-20200101_123401.json?basic_fetch=1
    // http://0.0.0.0:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401
    // const record = await $axios.$get(`/w/${params.key}.json`, {params: {ogp_only: true, basic_fetch: true, ...query}})

    // 待たないデータ
    this.$axios.$get(`/w/${this.user_key}.json`, {params: {time_chart_fetch: true}}).then(e => {
      this.time_chart_params = e.time_chart_params
    })

    // 重要なのはこっちなので待つ
    return this.$axios.$get(`/w/${this.user_key}.json`, {params: {basic_fetch: true}}).then(e => {
      this.record = e
      this.record_setup()
      this.slider_focus_delay()
    })
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
    // 本当は SwarsBattleShowTimeChart の中で処理したかった
    chart_show_auto() {
      if (this.time_chart_p) {
        this.$nextTick(() => { this.$refs.SwarsBattleShowTimeChart.chart_show() })
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

    // SwarsBattleShowTimeChart でチャートをクリックしたときに変更する
    turn_set_from_chart(v) {
      this.$refs.main_sp.$refs.pure_sp.api_board_turn_set(v) // 直接 shogi-player に設定
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
      return this.record.player_info
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
.SwarsBattleShow
  .delete
    position: absolute
    top: 3.9rem
    left: 0.6rem
    z-index: 2 // shogi-player の「○手目」のdivより下にあって押せない場合があるため指定する必要がある
  .SwarsBattleShowTimeChart
    margin: 2.75rem 2rem
    +mobile
      margin: 0
</style>
