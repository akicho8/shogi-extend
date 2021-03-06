<template lang="pug">
.SwarsBattleShowApp
  b-loading(:active="$fetchState.pending")
  .MainContainer(v-if="!$fetchState.pending")
    client-only
      SwarsBattleShowSidebar(:base="base")
      SwarsBattleShowNavbar(:base="base")

      .FirstView.is-unselectable
        .CustomShogiPlayerWrap
          CustomShogiPlayer(
            sp_layer="is_layer_off"
            sp_layout="is_horizontal"
            sp_fullheight="is_fullheight_off"
            :sp_run_mode.sync="sp_run_mode"
            :sp_turn="sp_turn"
            :sp_body="record.sfen_body"
            :sp_key_event_capture_enabled="true"
            sp_slider="is_slider_on"
            sp_summary="is_summary_off"
            sp_controller="is_controller_on"
            :sp_viewpoint.sync="new_viewpoint"
            :sp_player_info="player_info"
            @update:sp_turn="real_turn_set"
            ref="main_sp"
          )

      SwarsBattleShowTimeChart(
        v-if="record && time_chart_params"
        :record="record"
        :time_chart_params="time_chart_params"
        @update:turn="turn_set_from_chart"
        :chart_turn="new_turn"
        :sp_viewpoint="new_viewpoint"
        ref="SwarsBattleShowTimeChart"
      )

      .app_buttons_container
        .buttons.is-centered
          PiyoShogiButton(:href="piyo_shogi_app_with_params_url" @click="sound_play('click')")
          KentoButton(tag="a" :href="kento_app_with_params_url" @click="sound_play('click')")
          KifCopyButton(@click="kifu_copy_handle")
        .buttons.is-centered(v-if="false")
          b-button(@click="back_handle" icon-left="chevron-left" size="is-small")
          TweetButton(:body="permalink_url" @after_click="sound_play('click')")
          b-button(icon-left="menu" @click="sidebar_toggle" size="is-small")

      .battle_title_container.has-background-grey-lighter.py-6.battle_title.has-text-grey-dark.is-size-7-mobile
        p
          | {{record.piyo_shogi_base_params.game_name}}
          span.mx-1(v-if="record.preset_info.name !== '平手'") {{record.preset_info.name}}
        p
          SwarsBattleShowUserLink(:membership="record.memberships[0]" :with_mark="true" :with_judge="true")
          span.mx-1 vs
          SwarsBattleShowUserLink(:membership="record.memberships[1]" :with_mark="true" :with_judge="true")
        p {{record.description}}
        p {{record.turn_max}}手まで (最後は{{record.final_info.name}})

      //- .columns
      //-   .column.is-half-desktop.is_buttons_column
      //-     .buttons.is-centered
      //-       //- PngDlButton(tag="a" :href="png_dl_url" :turn="new_turn")

      //-   DebugPre(v-if="development_p")
      //-     | start_turn: {{start_turn}}
      //-     | new_turn: {{new_turn}}
      //-     | record.turn: {{record.turn}}
      //-     | record.display_turn: {{record.display_turn}}
      //-     | record.critical_turn: {{record.critical_turn}}
      //-     | record.outbreak_turn: {{record.outbreak_turn}}
      //-     | record.turn_max: {{record.turn_max}}
      //-     | record.turn: {{record.turn}}
      //-     | new_viewpoint: {{new_viewpoint}}
  DebugPre(v-if="development_p") {{record}}
</template>

<script>
import { support_parent  } from "./support_parent.js"
import { app_chore       } from "./app_chore.js"
import { app_sidebar     } from "./app_sidebar.js"

export default {
  name: "SwarsBattleShowApp",
  mixins: [
    support_parent,
    app_chore,
    app_sidebar,
  ],

  data() {
    return {
      record: null,            // 属性がたくさん入ってる

      sp_run_mode: null,          // shogi-player の現在のモード。再生モード(view_mode)と継盤モード(play_mode)を切り替える用
      new_turn: null,       // KENTOに渡すための手番
      new_viewpoint: null,          // 視点

      time_chart_p: false,     // 時間チャートを表示する？
      time_chart_params: null, // 時間チャートのデータ
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
    // http://localhost:3000/w.json?query=devuser1&format_type=user
    // http://localhost:4000/swars/users/devuser1

    // http://localhost:3000/w/devuser1-Yamada_Taro-20200101_123401.json?basic_fetch=1
    // http://localhost:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401
    // const record = await $axios.$get(`/w/${params.key}.json`, {params: {ogp_only: true, basic_fetch: true, ...query}})

    const params = {
      basic_fetch: true,
      // memberships の順序を [black, white] に固定する
      // これを入れないと viewpoint と対象者が設定されなかったとき処理で、勝った方が左になる
      // この挙動は下の表示で確認できる
      viewpoint: "black",
    }

    // 重要なのはこっちなので待つ
    return Promise.all([
      this.$axios.$get(`/w/${this.$route.params.key}.json`, {params: params}).then(e => {
        this.record = e
        this.record_setup()
      }),
      this.$axios.$get(`/w/${this.$route.params.key}.json`, {params: {time_chart_fetch: true}}).then(e => {
        this.time_chart_params = e.time_chart_params
      }),
    ])
  },

  mounted() {
    this.ga_click("バトル詳細")
  },

  watch: {
    new_turn() { this.url_replace() },
    new_viewpoint() { this.url_replace() },
  },

  methods: {
    tweet_handle() {
      this.sound_play("click")
      this.tweet_window_popup({text: this.permalink_url})
    },

    current_url_copy() {
      this.sidebar_close()
      this.clipboard_copy({text: this.permalink_url})
    },

    short_url_copy(method) {
      this.sidebar_close()
      this.clipboard_copy({text: this.short_url(method)})
    },

    short_url(method) {
      return this.$config.MY_NUXT_URL + `/swars/battles/${this.record.key}/${method}`
    },

    url_replace() {
      // FIXME: queryだけ変更するとエラーになる
      this.$router.replace({query: {
        ...this.$route.query,
        turn: this.new_turn,
        viewpoint: this.new_viewpoint,
      }}, () => {}, () => {})
    },

    kifu_copy_handle() {
      this.sound_play("click")
      this.kif_clipboard_copy({kc_path: this.record.show_path})
    },

    sidebar_toggle() {
      this.sound_play("click")
      this.sidebar_p = !this.sidebar_p
    },

    back_handle() {
      this.sound_play("click")
      this.back_to({name: "swars-search"})
    },

    // delete_click_handle() {
    //   // this.$router.go(-1)
    // },

    // バトル情報がセットされたタイミングまたは変更されたタイミング
    record_setup() {
      // 開始手数を保存 (KENTOに渡すためでもある)
      this.new_turn = this.sp_turn

      // 継盤解除
      this.sp_run_mode = "view_mode"

      // 最初の上下反転状態
      this.new_viewpoint = this.default_viewpoint

      // 指し手がない棋譜の場合は再生モード(view_mode)に意味がないため継盤モード(play_mode)で開始する
      // これは勝手にやらない方がいい？
      if (true) {
        if (this.record.turn_max === 0) {
          this.sp_run_mode = "play_mode"
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

    // 開始局面
    // turn sp_turn critical_turn の順に見る
    sp_turn_for(record) {
      const turn = this.$route.query.turn
      if (turn != null) {
        return Number(turn)
      }

      // Indexのコードと同じだけど共通化はするな
      let v = null
      if (this.scene === "critical") {
        v = record.critical_turn
      } else if (this.scene === "outbreak") {
        v = record.outbreak_turn
      } else if (this.scene === "last") {
        v = record.turn_max
      }
      return v || record.display_turn
    },

    // SwarsBattleShowTimeChart でチャートをクリックしたときに変更する
    turn_set_from_chart(v) {
      this.$refs.main_sp.sp_object().api_board_turn_set(v) // 直接 shogi-player に設定
      this.new_turn = v                                    // KENTO用に設定 (shogi-playerからイベントが来ないため)
      this.slider_focus()                             // チャートを動かした直後も左右キーが使えるようにする
    },

    // shogi-player の局面が変化したときの手数を取り出す
    real_turn_set(v) {
      this.new_turn = v
    },

    // this.$nextTick(() => this.slider_focus()) の方法だと失敗する
    slider_focus() {
      if (this.$refs.main_sp) {
        this.$refs.main_sp.sp_object().api_turn_slider_focus()
      }
    },
  },

  computed: {
    base() { return this },

    meta() {
      // ページ遷移で来たとき head は fetch より前にいきなり呼ばれているためガードが必要
      if (!this.record) {
        return
      }
      return {
        title: [this.og_title, "将棋ウォーズ"],
        og_title: this.og_title,
        og_image: this.og_image,
        description: this.record.description,
      }
    },

    scene() {
      return this.$route.query.scene
    },

    default_viewpoint() {
      return this.$route.query.viewpoint || "black"
    },

    og_image() {
      const params = new URLSearchParams()
      params.set("turn", this.new_turn)
      params.set("viewpoint", this.new_viewpoint)
      return `${this.record.show_path}.png?${params}`
    },

    og_title() {
      return `${this.record.title} ${this.new_turn}手目`
    },

    sp_turn() {
      return this.sp_turn_for(this.record)
    },

    player_info() {
      return null
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
      params.set("viewpoint", this.new_viewpoint)

      return `${url}/swars/battles/${this.record.key}?${params}`
    },

    // png_dl_url() {
    //   const params = new URLSearchParams()
    //   params.set("attachment", true)
    //   params.set("turn", this.new_turn)
    //   params.set("viewpoint", this.new_viewpoint)
    //   return `${this.$config.MY_SITE_URL}/w/${this.record.key}.png?${params}`
    // },

    piyo_shogi_app_with_params_url() {
      return this.piyo_shogi_auto_url({
        path:      this.record.show_path,
        sfen:      this.record.sfen_body,
        turn:      this.new_turn,
        viewpoint: this.new_viewpoint,
        ...this.record.piyo_shogi_base_params,
      })
    },

    kento_app_with_params_url() {
      return this.kento_full_url({
        sfen:      this.record.sfen_body,
        turn:      this.new_turn,
        viewpoint: this.new_viewpoint,
      })
    },

    // tweet_url() {
    //   return this.tweet_url_build_from_text(this.permalink_url)
    // },

    // 共有将棋盤で開くときのパラメータ
    share_board_query() {
      return {
        // 共有将棋盤に転送するときは個人情報をなるべく隠したい意図があるのであえて何も入れない
        //
        // record.title:        対戦者の名前
        // record.description:  戦法のみ
        //
        title: "将棋ウォーズ棋譜",

        body:  this.record.sfen_body,
        turn:  this.new_turn,
        abstract_viewpoint: this.new_viewpoint,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // { black: "alice", white: "bob" }
    player_info_hash() {
      return this.record.memberships.reduce((a, m) => {
        return {
          ...a,
          [m.location.key]: `${m.user.key} ${m.grade_info.name}`,
        }
      }, {})
    },

    style_editor_query() {
      return {
        body: this.record.sfen_body,
        turn: this.new_turn,
        viewpoint: this.new_viewpoint,
        ...this.player_info_hash,
      }
    }
  },
}
</script>

<style lang="sass">
$button_z_index: 2

.SwarsBattleShowApp
  //////////////////////////////////////////////////////////////////////////////// ヘッダー
  .sidebar_toggle_button
    position: absolute
    top: 0
    right: 0
    z-index: $button_z_index

  //////////////////////////////////////////////////////////////////////////////// 1ページ目
  .FirstView
    // background-color: hsl(99.5, 40.6, 80.2)
    +tablet
      padding: 3rem 0 0.75rem
    +mobile
      padding: 0.75rem 0 1.5rem // 画像化するときに切り取りやすいように少しあける

  //////////////////////////////////////////////////////////////////////////////// ShogiPlayer
  .CustomShogiPlayerWrap
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    // height: 100vh               // app_buttons_container を画面外にする

  .CustomShogiPlayer
    +mobile
      --sp_piece_count_gap_bottom: 48%
    +tablet
      max-width: calc(100vmin * 0.65)
    +desktop
      max-width: calc(100vmin * 0.75)

  //////////////////////////////////////////////////////////////////////////////// ShogiPlayer の下のボタンたち
  .app_buttons_container
    background-color: $white-ter
    margin: 0 0 0
    padding: 3rem 0

  ////////////////////////////////////////////////////////////////////////////////
  .battle_title_container
    line-height: 1.8
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column

.STAGE-development
  .SwarsBattleShowApp
    .column, .FirstView
      border: 1px dashed change_color($primary, $alpha: 0.2)
</style>
