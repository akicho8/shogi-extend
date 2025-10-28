<template lang="pug">
client-only
  .SwarsBattleShowApp
    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    .MainContainer(v-if="record")
      SwarsBattleShowSidebar(:base="base")
      SwarsBattleShowNavbar(:base="base")

      .FirstView.is-unselectable
        .CustomShogiPlayerWrap
          CustomShogiPlayer(
            sp_layout="horizontal"
            :sp_mode.sync="sp_mode"
            :sp_turn="sp_turn"
            :sp_body="record.sfen_body"
            sp_key_event_capture
            sp_slider
            sp_mounted_focus_to_slider
            sp_controller
            :sp_viewpoint.sync="viewpoint"
            :sp_player_info="player_info"
            @update:sp_turn="real_turn_set"
            @ev_short_sfen_change="v => short_sfen = v"
            ref="main_sp"
          )

      SwarsBattleShowTimeChart(
        v-if="time_chart_params"
        @update:turn="turn_set_from_chart"
        :chart_turn="current_turn"
        ref="SwarsBattleShowTimeChart"
      )

      .app_buttons_container
        .buttons.is-centered
          PiyoShogiButton(:href="current_kifu_vo.piyo_url" @click="sfx_click()")
          KentoButton(tag="a" :href="current_kifu_vo.kento_url" @click="sfx_click()")
          KifCopyButton(@click="kifu_copy_button_handle")
        .buttons.is-centered(v-if="false")
          b-button(@click="back_handle" icon-left="chevron-left" size="is-small")
          TweetButton(:body="permalink_url" @after_click="sfx_click()")
          b-button(icon-left="menu" @click="sidebar_toggle" size="is-small")

      .battle_title_container.has-background-grey-lighter.py-6.battle_title.has-text-grey-dark.is-size-7-mobile
        p
          | {{record.piyo_shogi_base_params.game_name}}
          span.mx-1(v-if="record.preset_info.name !== '平手'") {{record.preset_info.name}}
        p
          SwarsBattleShowUserLink(:membership="record.memberships[0]" :with_location="true" :with_judge="true")
          span.mx-1 vs
          SwarsBattleShowUserLink(:membership="record.memberships[1]" :with_location="true" :with_judge="true")
        p {{record.description}}
        p {{record.turn_max}}手まで (最後は{{record.final_info.name}})
        p(v-if="record.memberships[0].ek_score_without_cond != null && record.memberships[1].ek_score_without_cond != null")
          a(href="https://shogiwars.heroz.jp/topics/54293aca7aa25c6e6b000042" target="_blank" @click="sfx_click()") 入玉宣言法
          template(v-if="record.final_info.key === 'ENTERINGKING'")
            | による点数
          template(v-else)
            | を仮定した点数
          span.mr-1 :
          SwarsBattleShowUserScore(:membership="record.memberships[0]")
          span.mx-1 vs
          SwarsBattleShowUserScore(:membership="record.memberships[1]")

      //-   DebugPre(v-if="development_p")
      //-     | start_turn: {{start_turn}}
      //-     | current_turn: {{current_turn}}
      //-     | record.turn: {{record.turn}}
      //-     | record.display_turn: {{record.display_turn}}
      //-     | record.critical_turn: {{record.critical_turn}}
      //-     | record.outbreak_turn: {{record.outbreak_turn}}
      //-     | record.turn_max: {{record.turn_max}}
      //-     | record.turn: {{record.turn}}
      //-     | viewpoint: {{viewpoint}}
      DebugPre(v-if="development_p") {{record}}
</template>

<script>
import { support_parent  } from "./support_parent.js"
import { mod_chore       } from "./mod_chore.js"
import { mod_chart       } from "./mod_chart.js"
import { mod_export      } from "./mod_export.js"
import { mod_sidebar     } from "./mod_sidebar.js"
import { mod_storage     } from "./mod_storage.js"

import { SceneInfo } from "../models/scene_info.js"
import { KifuVo } from "@/components/models/kifu_vo.js"
import { FormatTypeInfo } from "@/components/models/format_type_info.js"
import { SafeSfen } from "@/components/models/safe_sfen.js"
import QueryString from "query-string"

export default {
  name: "SwarsBattleShowApp",
  mixins: [
    support_parent,
    mod_chore,
    mod_chart,
    mod_export,
    mod_sidebar,
    mod_storage,
  ],
  data() {
    return {
      record: null,            // 属性がたくさん入ってる

      sp_mode: null,       // shogi-player の現在のモード。再生モード(view)と継盤モード(play)を切り替える用
      current_turn: null,      // KENTOに渡すための手番
      viewpoint: null,     // 視点
      short_sfen: null,          // BOD タイプの sfen

      time_chart_p: false,     // 時間チャートを表示する？
      time_chart_params: null, // 時間チャートのデータ
    }
  },
  provide() {
    return {
      TheShow: this,
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
    // http://localhost:3000/w.json?query=DevUser1&format_type=user
    // http://localhost:4000/swars/users/DevUser1

    // http://localhost:3000/w/DevUser1-YamadaTaro-20200101_123401.json?basic_fetch=1
    // http://localhost:4000/swars/battles/DevUser1-YamadaTaro-20200101_123401
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
    this.app_log("バトル詳細")
  },

  // watch: {
  //   current_turn() { this.url_replace() },
  //   viewpoint() { this.url_replace() },
  // },

  methods: {
    tweet_handle() {
      this.sfx_click()
      this.tweet_window_popup({text: this.permalink_url})
    },

    current_url_copy() {
      this.sidebar_close()
      this.clipboard_copy(this.permalink_url)
    },

    short_url_copy(method) {
      this.sidebar_close()
      this.clipboard_copy(this.short_url(method))
    },

    short_url(method) {
      return this.$config.MY_NUXT_URL + `/swars/battles/${this.record.key}/${method}`
    },

    url_replace() {
      // FIXME: queryだけ変更するとエラーになる
      this.$router.replace({query: {
        ...this.$route.query,
        turn: this.current_turn,
        viewpoint: this.viewpoint,
      }}, () => {}, () => {})
    },

    kifu_copy_button_handle() {
      this.kifu_copy_handle(this.FormatTypeInfo.fetch('kif_utf8'))
    },

    sidebar_toggle() {
      this.sfx_click()
      this.sidebar_p = !this.sidebar_p
    },

    back_handle() {
      this.sfx_click()
      this.back_to_or({name: "swars-search"})
    },

    // delete_click_handle() {
    //   // this.$router.go(-1)
    // },

    // バトル情報がセットされたタイミングまたは変更されたタイミング
    record_setup() {
      // 開始手数を保存 (KENTOに渡すためでもある)
      this.current_turn = this.sp_turn

      // 継盤解除
      this.sp_mode = "view"

      // 最初の上下反転状態
      this.viewpoint = this.default_viewpoint

      // 指し手がない棋譜の場合は再生モード(view)に意味がないため継盤モード(play)で開始する
      // これは勝手にやらない方がいい？
      if (true) {
        if (this.record.turn_max === 0) {
          this.sp_mode = "play"
        }
      }

      this.short_sfen = this.record.sfen_body

      // PCの場合はキーボードの左右ですぐ操作できるようスライダーにフォーカスしておく
      // this.$nextTick(() => this.slider_focus())
      // ここではなく sp_mounted_focus_to_slider を有効にする
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
    sp_turn_of(record) {
      this.$GX.assert(record, "record")

      const turn = this.$route.query.turn
      if (turn != null) {
        return Number(turn)
      }
      if (this.scene_info) {
        return this.scene_info.sp_turn_of(record)
      }
      return record.display_turn
    },

    // SwarsBattleShowTimeChart でチャートをクリックしたときに変更する
    turn_set_from_chart(v) {
      this.$refs.main_sp.sp_object().api_board_turn_set(v) // 直接 shogi-player に設定
      this.current_turn = v                                    // KENTO用に設定 (shogi-playerからイベントが来ないため)
      this.slider_focus()                             // チャートを動かした直後も左右キーが使えるようにする
    },

    // shogi-player の局面が変化したときの手数を取り出す
    real_turn_set(v) {
      this.current_turn = v
    },

    // this.$nextTick(() => this.slider_focus()) の方法だと失敗する
    slider_focus() {
      if (this.$refs.main_sp) {
        this.$refs.main_sp.sp_object().api_turn_slider_focus()
      }
    },

    other_app_click_handle(app_name) {
      this.sidebar_p = false
      this.sfx_click()
      this.app_log(app_name)
      this.app_log({emoji: ":外部アプリ:", subject: "将棋ウォーズ棋譜検索→詳細→サイドバー", body: app_name})
    },
  },

  computed: {
    base() { return this },
    FormatTypeInfo() { return FormatTypeInfo },

    SceneInfo()  { return SceneInfo                             },
    scene_info() { return this.SceneInfo.lookup(this.scene_key) },
    scene_key()  { return this.$route.query.scene_key           },

    meta() {
      // ページ遷移で来たとき head は fetch より前にいきなり呼ばれているためガードが必要
      if (!this.record) {
        return
      }
      return {
        title: [this.og_title, "将棋ウォーズ"],
        og_title: this.og_title,
        og_image_path: this.og_image_path,
        description: this.record.description,
      }
    },

    default_viewpoint() { return this.param_to_s("viewpoint", "black")                       },
    color_theme_key()   { return this.param_to_s("color_theme_key", "is_color_theme_modern") },

    og_image_path() {
      return QueryString.stringifyUrl({
        url: `${this.record.show_path}.png`,
        query: {
          turn: this.current_turn,
          viewpoint: this.viewpoint,
          color_theme_key: this.color_theme_key,
        },
      })
    },

    og_title() {
      return `${this.record.title} ${this.current_turn}手目`
    },

    sp_turn() {
      return this.sp_turn_of(this.record)
    },

    player_info() {
      return null
      return this.record.player_info
    },

    permalink_url() {
      return QueryString.stringifyUrl({
        url: `${this.$config.MY_SITE_URL}/swars/battles/${this.record.key}`,
        query: { turn: this.current_turn, viewpoint: this.viewpoint },
      })
    },

    current_kifu_vo() {
      return this.$KifuVo.create({
        kif_url: `${this.$config.MY_SITE_URL}${this.record.show_path}.kif`,
        sfen:      this.record.sfen_body,
        turn:      this.current_turn,
        viewpoint: this.viewpoint,
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
        xbody:  SafeSfen.encode(this.record.sfen_body),
        turn:  this.current_turn,
        viewpoint: this.viewpoint,
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // { black: "alice", white: "bob" }
    player_info_hash() {
      return this.record.memberships.reduce((a, m) => {
        return {
          ...a,
          [m.location_key]: `${m.user.key} ${m.grade_info.name}`,
        }
      }, {})
    },

    style_editor_query() {
      return {
        body: this.record.sfen_body,
        turn: this.current_turn,
        viewpoint: this.viewpoint,
        ...this.player_info_hash,
      }
    }
  },
}
</script>

<style lang="sass">
.SwarsBattleShowApp
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
