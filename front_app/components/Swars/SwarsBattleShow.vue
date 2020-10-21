<template lang="pug">
.SwarsBattleShow
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    client-only
      b-sidebar.is-unselectable(type="is-light" fullheight right v-model="sidebar_p")
        .mx-4.my-4
          b-menu
            b-menu-list(label="Action")
              b-menu-item(label="共有将棋盤で開く" tag="nuxt-link" :to="{name: 'share-board', query: share_board_query}" @click.native="sound_play('click')")

            b-menu-list(label="export")
              b-menu-item(label="棋譜用紙 (PDF)"   tag="nuxt-link" :to="{name: 'swars-battles-key-formal-sheet', params: {key: record.key}}" @click.native="sound_play('click')")
              b-menu-item(@click="sound_play('click')")
                template(slot="label" slot-scope="props")
                  span.ml-1 表示
                  b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
                b-menu-item(label="KIF"  @click.native="sound_play('click')" :target="target_default" :href="`${$config.MY_SITE_URL}${record.show_path}.kif`")
                b-menu-item(label="KI2"  @click.native="sound_play('click')" :target="target_default" :href="`${$config.MY_SITE_URL}${record.show_path}.ki2`")
                b-menu-item(label="CSA"  @click.native="sound_play('click')" :target="target_default" :href="`${$config.MY_SITE_URL}${record.show_path}.csa`")
                b-menu-item(label="SFEN" @click.native="sound_play('click')" :target="target_default" :href="`${$config.MY_SITE_URL}${record.show_path}.sfen`")
                b-menu-item(label="BOD"  @click.native="sound_play('click')" :target="target_default" :href="`${$config.MY_SITE_URL}${record.show_path}.bod?turn=${new_turn}`")
                b-menu-item(label="PNG"  @click.native="sound_play('click')" :target="target_default" :href="`${$config.MY_SITE_URL}${record.show_path}.png?turn=${new_turn}&flip=${new_flip}&width=`")
              b-menu-item(@click="sound_play('click')")
                template(slot="label" slot-scope="props")
                  span.ml-1 ダウンロード
                  b-icon.is-pulled-right(:icon="props.expanded ? 'menu-up' : 'menu-down'")
                b-menu-item(label="KIF"  @click.native="sound_play('click')" :href="`${$config.MY_SITE_URL}${record.show_path}.kif?attachment=true`")
                b-menu-item(label="KI2"  @click.native="sound_play('click')" :href="`${$config.MY_SITE_URL}${record.show_path}.ki2?attachment=true`")
                b-menu-item(label="CSA"  @click.native="sound_play('click')" :href="`${$config.MY_SITE_URL}${record.show_path}.csa?attachment=true`")
                b-menu-item(label="SFEN" @click.native="sound_play('click')" :href="`${$config.MY_SITE_URL}${record.show_path}.sfen?attachment=true`")
                b-menu-item(label="BOD"  @click.native="sound_play('click')" :href="`${$config.MY_SITE_URL}${record.show_path}.bod?attachment=true&turn=${new_turn}`")
                b-menu-item(label="PNG"  @click.native="sound_play('click')" :href="`${$config.MY_SITE_URL}${record.show_path}.png?attachment=true&turn=${new_turn}&flip=${new_flip}&width=`")

      MainNavbar
        template(slot="brand")
          b-navbar-item(@click="back_handle")
            b-icon(icon="chevron-left")
          b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-battles-key', params: {key: $route.params.key}, query: {turn: new_turn, flip: new_flip}}") {{record.title}}
        template(slot="end")
          b-navbar-item(@click="sidebar_toggle")
            b-icon(icon="menu")

      MainSection
        .container
          .columns
            .column
              MyShogiPlayer(
                :run_mode.sync="run_mode"
                :debug_mode="false"
                :start_turn="start_turn"
                :kifu_body="record.sfen_body"
                :key_event_capture="true"
                :slider_show="true"
                :sfen_show="false"
                :controller_show="true"
                :theme="'real'"
                :size="'medium'"
                :setting_button_show="false"
                :flip.sync="new_flip"
                :player_info="player_info"
                @update:start_turn="real_turn_set"
                ref="main_sp"
              )

              .has-text-centered.mt-4(v-if="false")
                b-switch(v-model="run_mode" true-value="play_mode" false-value="view_mode" @input="run_mode_change_handle")
                  b-icon(icon="source-branch")

              .buttons.is-centered.mt-5
                PiyoShogiButton(:href="piyo_shogi_app_with_params_url")
                KentoButton(tag="a" size="is-small" @click.stop="" :href="kento_app_with_params_url")
                KifCopyButton(@click="kifu_copy_handle")
                TweetButton(@click="tweet_share_open({url: permalink_url})")
                //- PngDlButton(tag="a" :href="png_dl_url" :turn="new_turn")

            .column
              SwarsBattleShowTimeChart(
                v-if="record && time_chart_params"
                :record="record"
                :time_chart_params="time_chart_params"
                @update:turn="turn_set_from_chart"
                :chart_turn="new_turn"
                :flip="new_flip"
                ref="SwarsBattleShowTimeChart"
              )

          //-   DebugPre
          //-     | start_turn: {{start_turn}}
          //-     | new_turn: {{new_turn}}
          //-     | record.turn: {{record.turn}}
          //-     | record.display_turn: {{record.display_turn}}
          //-     | record.critical_turn: {{record.critical_turn}}
          //-     | record.outbreak_turn: {{record.outbreak_turn}}
          //-     | record.turn_max: {{record.turn_max}}
          //-     | record.turn: {{record.turn}}
          //-     | new_flip: {{new_flip}}
  DebugPre {{record}}
</template>

<script>
export default {
  name: "SwarsBattleShow",
  props: {
    // turn_key:     { default: "default",           }, // どの局面から開始するか (一覧のturn_keyとは若干型が違う)
  },
  data() {
    return {
      record: null,            // 属性がたくさん入ってる

      run_mode: null,          // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      new_turn: null,       // KENTOに渡すための手番
      new_flip: null,          // 上下反転している？

      time_chart_p: false,     // 時間チャートを表示する？
      time_chart_params: null, // 時間チャートのデータ

      sidebar_p: false,
    }
  },

  // https://router.vuejs.org/ja/guide/advanced/navigation-guards.html#%E3%83%AB%E3%83%BC%E3%83%88%E5%8D%98%E4%BD%8D%E3%82%AC%E3%83%BC%E3%83%89
  // beforeRouteEnter (to, from, next) {
  //   debugger
  //   // このコンポーネントを描画するルートが確立する前に呼ばれます。
  //   // `this` でのこのコンポーネントへのアクセスはできません。
  //   // なぜならばこのガードが呼び出される時にまだ作られていないからです!
  // },

  fetch() {
    // alert("fetch")
    // alert(this.$route.params.key)
    // console.log(this)

    // console.log(this.$route.query)
    // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
    // http://0.0.0.0:4000/swars/users/devuser1

    // http://0.0.0.0:3000/w/devuser1-Yamada_Taro-20200101_123401.json?basic_fetch=1
    // http://0.0.0.0:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401
    // const record = await $axios.$get(`/w/${params.key}.json`, {params: {ogp_only: true, basic_fetch: true, ...query}})

    // 重要なのはこっちなので待つ
    return Promise.all([
      this.$axios.$get(`/w/${this.$route.params.key}.json`, {params: {basic_fetch: true}}).then(e => {
        this.record = e
        this.record_setup()
        this.lazy_slider_focus()
      }),
      this.$axios.$get(`/w/${this.$route.params.key}.json`, {params: {time_chart_fetch: true}}).then(e => {
        this.time_chart_params = e.time_chart_params
      }),
    ])
  },

  head() {
    // ページ遷移で来たとき head は fetch より前にいきなり呼ばれているためガードが必要
    if (!this.record) {
      return
    }

    return {
      title: `${this.og_title} | 将棋ウォーズ`,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.og_title,           },
        { hid: "og:image",       property: "og:image",       content: this.og_image,           },
        { hid: "og:description", property: "og:description", content: this.record.description, },
        { hid: "description",    property: "description",    content: this.record.description, },
      ],
    }
  },

  watch: {
    sidebar_p() {
      this.sound_play('click')
    },
    new_turn() { this.url_replace() },
    new_flip()    { this.url_replace() },
  },

  methods: {
    url_replace() {
      // FIXME: queryだけ変更するとエラーになる
      this.$router.replace({query: {
        ...this.$route.query,
        turn: this.new_turn,
        flip: this.new_flip,
      }}, () => {}, () => {})
    },

    kifu_copy_handle() {
      this.sound_play('click')
      this.kif_clipboard_copy({kc_path: this.record.show_path})
    },

    sidebar_toggle() {
      this.sidebar_p = !this.sidebar_p
    },

    back_handle() {
      this.sound_play('click')
      this.back_to({name: "swars-search"})
    },

    // delete_click_handle() {
    //   // this.$router.go(-1)
    // },

    // バトル情報がセットされたタイミングまたは変更されたタイミング
    record_setup() {
      // 開始手数を保存 (KENTOに渡すためでもある)
      this.new_turn = this.start_turn

      // 継盤解除
      this.run_mode = "view_mode"

      // 最初の上下反転状態
      this.new_flip = this.default_flip

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
    // chart_show_auto() {
    //   if (this.time_chart_p) {
    //     this.$nextTick(() => { this.$refs.SwarsBattleShowTimeChart.chart_show() })
    //   }
    // },

    // マウスで操作したときだけ呼べる
    run_mode_change_handle(v) {
      let message = null
      if (v === "play_mode") {
        message = "駒を操作できます"
      } else {
        message = "元に戻しました"
      }
      this.simple_notify(message)
      this.lazy_slider_focus()
    },

    // 開始局面
    // turn start_turn critical_turn の順に見る
    start_turn_for(record) {
      const turn = this.$route.query.turn
      if (turn != null) {
        return Number(turn)
      }

      // Indexのコードと同じだけど共通化はするな
      let v = null
      if (this.turn_key === "critical") {
        v = record.critical_turn
      } else if (this.turn_key === "outbreak") {
        v = record.outbreak_turn
      } else if (this.turn_key === "last") {
        v = record.turn_max
      }
      return v || record.display_turn
    },

    // SwarsBattleShowTimeChart でチャートをクリックしたときに変更する
    turn_set_from_chart(v) {
      this.$refs.main_sp.$refs.pure_sp.api_board_turn_set(v) // 直接 shogi-player に設定
      this.new_turn = v                      // KENTO用に設定 (shogi-playerからイベントが来ないため)
    },

    // shogi-player の局面が変化したときの手数を取り出す
    real_turn_set(v) {
      this.new_turn = v
    },

    // this.$nextTick(() => this.slider_focus()) の方法だと失敗する
    lazy_slider_focus() {
      setTimeout(() => this.slider_focus(), 1)
    },

    // $el は使えるタイミング難しいため普通に document から探す
    slider_focus() {
      if (typeof document !== 'undefined') {
        const dom = document.querySelector(".turn_slider")
        if (dom) {
          dom.focus()
        }
      }
    },
  },

  computed: {
    turn_key() {
      return this.$route.query.turn_key
    },

    default_flip() {
      const v = this.$route.query.flip
      if (v === "true") {
        return true
      }
      return this.record.flip
    },

    og_image() {
      const params = new URLSearchParams()
      params.set("turn", this.new_turn)
      params.set("flip", this.new_flip)
      return this.$config.MY_SITE_URL + `${this.record.show_path}.png?${params}`
    },

    og_title() {
      return `${this.record.title} ${this.new_turn}手目`
    },

    start_turn() {
      return this.start_turn_for(this.record)
    },

    player_info() {
      return this.record.player_info
    },

    permalink_url() {
      let url = null
      // if (this.development_p) {
      //   url = this.$config.MY_NUXT_URL
      // } else {
      url = this.$config.MY_SITE_URL
      // }

      const params = new URLSearchParams()
      params.set("turn", this.new_turn)
      params.set("flip", this.new_flip)

      return `${url}/swars/battles/${this.record.key}?${params}`
    },

    // png_dl_url() {
    //   const params = new URLSearchParams()
    //   params.set("attachment", true)
    //   params.set("turn", this.new_turn)
    //   params.set("flip", this.new_flip)
    //   return `${this.$config.MY_SITE_URL}/w/${this.record.key}.png?${params}`
    // },

    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        path: this.record.show_path,
        sfen: this.record.sfen_body,
        turn: this.new_turn,
        flip: this.new_flip,
        ...this.record.piyo_shogi_base_params,
      })
    },

    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen: this.record.sfen_body,
        turn: this.new_turn,
        flip: this.new_flip,
      })
    },

    tweet_url() {
      return this.tweet_intent_url(this.permalink_url)
    },

    share_board_query() {
      return {
        title: this.record.description, // title:対戦者の名前 description:戦法のみ
        body:  this.record.sfen_body,
        turn:  this.new_turn,
        image_view_point: this.new_flip ? "white" : "black",
      }
    },
  },
}
</script>

<style lang="sass">
// .MySidebarMenuIconWithTitle
//   display: flex
//   justify-content: flex-start
//   align-items: center

.SwarsBattleShow
  +mobile
    .column
      padding: 0

  // .delete
  //   position: absolute
  //   top: 6.0rem
  //   left: 0.6rem
  //   z-index: 2 // shogi-player の「○手目」のdivより下にあって押せない場合があるため指定する必要がある

  .SwarsBattleShowTimeChart
    margin: 1.75rem 2rem
    +mobile
      margin: 0
      margin-top: 1.75rem
</style>
