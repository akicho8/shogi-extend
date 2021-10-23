<template lang="pug">
.TsMasterApp(:class="[mode, {is_mode_idol, is_mode_active}]" :style="component_style")
  b-sidebar.TsMasterApp-Sidebar.is-unselectable(fullheight right overlay v-model="sidebar_p")
    .mx-4.my-4
      .is-flex.is-justify-content-start.is-align-items-center
        b-button(@click="sidebar_toggle" icon-left="menu")
      b-menu(v-if="question_exist_p && mode === 'is_mode_run'")
        b-menu-list(label="検討")
          b-menu-item.is_active_unset(target="_blank" tag="a" :href="piyo_shogi_app_with_params_url"  label="ぴよ将棋"     @click="sidebar_toggle")
          b-menu-item.is_active_unset(target="_blank" tag="a" :href="kento_app_with_params_url"       label="KENTO"        @click="sidebar_toggle")
          b-menu-item.is_active_unset(                                                                label="コピー"       @click="kifu_copy_handle")
          b-menu-item.is_active_unset(target="_blank" tag="a" :href="share_board_app_with_params_url" label="共有将棋盤"   @click="sidebar_toggle")

  MainNavbar(v-if="is_mode_idol")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'practical-checkmate'}") 実戦詰将棋『一期一会』
    template(slot="end")
      b-navbar-dropdown(hoverable arrowless right label="デバッグ" v-if="development_p")
        b-navbar-item(@click="ls_reset") ブラウザに記憶した情報の削除
        b-navbar-item(@click="var_init") 保存可能な変数のリセット
        b-navbar-item ランキングタブの各表示ページ:{{current_pages}}

      NavbarItemLogin
      NavbarItemProfileLink

  MainNavbar(v-if="is_mode_active")
    template(slot="brand")
      b-navbar-item(@click="stop_handle")
        b-icon(icon="chevron-left")
    template(slot="start")
      b-navbar-item.has-text-weight-bold(tag="div")
        span.mx-1 {{current_rule.mate}}手詰
        span.mx-1.is-family-monospace {{o_count}}/{{current_rule.o_count_max}}
        span.mx-1.is-family-monospace {{time_format}}
        span.mx-1.is-family-monospace \#{{turn_offset}}
    template(slot="end" v-if="mode === 'is_mode_run'")
      b-navbar-item.has-text-weight-bold.px-4(@click="next_button")
        | NEXT
      b-navbar-item(@click="sidebar_toggle")
        b-icon(icon="menu")

  b-navbar(type="is-dark" fixed-bottom v-if="development_p")
    template(slot="start")
      b-navbar-item(@click="reset_all_handle") リセット
      b-navbar-item(@click="goal_handle") ゴール
      b-navbar-item(@click="rebuild_handle") リビルド

  MainSection
    .container
      .columns
        .column
          .buttons.is-centered.mb-0(v-if="is_mode_idol")
            b-button.has-text-weight-bold(@click="start_handle" type="is-primary") START

            b-dropdown.is-pulled-left(v-model="rule_key" @click.native="sound_play('click')")
              button.button(slot="trigger")
                span {{current_rule.name}} × {{current_rule.o_count_max}}問
                b-icon(icon="menu-down")
              template(v-for="e in RuleInfo.values")
                b-dropdown-item(:value="e.key") {{e.name}} × {{e.o_count_max}}問

            b-button(@click="rule_dialog_show" icon-right="help")

          .CustomShogiPlayerWrap
            TsMasterCountdown(:base="base")
            CustomShogiPlayer.is_mobile_vertical_good_style(
              ref="main_sp"
              :sp_body="sp_body"
              :sp_viewpoint="sp_viewpoint"
              sp_mobile_vertical="is_mobile_vertical_on"
              sp_run_mode="play_mode"
              sp_summary="is_summary_off"
              sp_slider="is_slider_off"
              @update:turn_offset="e => turn_offset = e"
              :sp_sound_body_changed="false"
              :sp_turn="0"
              :sp_controller="mode === 'is_mode_run' ? 'is_controller_on' : 'is_controller_off'"
            )

          .box.tweet_box_container.has-text-centered(v-if="mode === 'is_mode_goal'")
            | {{summary}}
            TweetButton.mt-2(:body="tweet_body" @after_click="sound_play('click')")

        TsMasterRanking(:base="base")
      TsMasterChart(:base="base" ref="TsMasterChart")
  DebugPre(v-if="development_p") {{$data}}
  DebugPre(v-if="development_p") {{config}}
</template>

<script>
import _ from "lodash"
import dayjs from "dayjs"

import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"
import { Soldier } from "shogi-player/components/models/soldier.js"
import { Place } from "shogi-player/components/models/place.js"

import { isMobile        } from "@/components/models/is_mobile.js"
import { IntervalCounter } from '@/components/models/interval_counter.js'
import { IntervalFrame   } from '@/components/models/interval_frame.js'

import { support_parent } from "./support_parent.js"

import { app_chart       } from "./app_chart.js"
import { app_keyboard    } from "./app_keyboard.js"
import { app_debug       } from "./app_debug.js"
import { app_rule_dialog } from "./app_rule_dialog.js"
import { app_external_apps } from "./app_external_apps.js"

import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

class RuleInfo extends ApplicationMemoryRecord {
}

class ScopeInfo extends ApplicationMemoryRecord {
}

class ChartScopeInfo extends ApplicationMemoryRecord {
}

const COUNTDOWN_INTERVAL = 0.5  // カウントダウンはN秒毎に進む
const COUNTDOWN_MAX      = 3    // カウントダウンはNから開始する
const DIMENSION          = 9    // 盤面の辺サイズ
const CONGRATS_LTEQ      = 10   // N位以内ならおめでとう

export default {
  name: "TsMasterApp",
  mixins: [
    support_parent,
    ls_support_mixin,
    app_keyboard,
    app_debug,
    app_rule_dialog,
    app_external_apps,
    app_chart,
  ],
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      questions: null,
      mode: "is_mode_stop",
      countdown_counter:  null, // カウントダウン用カウンター
      sp_body:            null, // 今のセル
      sp_viewpoint:       null, // 視点
      o_count:            null, // 正解数
      x_count:            null, // 不正解数
      key_queue:          null, // PCモードでの押したキー
      micro_seconds:      null, // 経過時間
      entry_name_uniq_p: false, // プレイヤー別順位ON/OFF
      rule_key:           null, // ../../../app/models/rule_info.rb のキー
      scope_key:          null, // ../../../app/models/scope_info.rb のキー
      entry_name:         null, // ランキングでの名前を保持しておく
      current_rule_index: null, // b-tabs 連動用
      time_records_hash:  null, // 複数のルールでそれぞれにランキング情報も入っている
      time_record:        null, // ゲームが終わたっときにランクなどが入っている
      current_pages:      null, // b-table のページ
      latest_rule:        null, // 最後に挑戦した最新のルール
      interval_counter: new IntervalCounter(this.countdown_func, {early: true, interval: COUNTDOWN_INTERVAL}),
      interval_frame:   new IntervalCounter(this.time_add_func, {early: true}),
      sidebar_p: false,
      turn_offset: null,
    }
  },

  created() {
    RuleInfo.memory_record_reset(this.config.rule_info)
    ScopeInfo.memory_record_reset(this.config.scope_info)
    ChartScopeInfo.memory_record_reset(this.config.chart_scope_info)

    this.ls_setup()
    this.init_other_variables()
  },

  mounted() {
    this.ga_click("実戦詰将棋")
  },

  beforeDestroy() {
    this.interval_counter.stop()
    this.interval_frame.stop()
    this.scroll_set(true)
  },

  watch: {
    scope_key() {
      this.time_records_hash_update()
    },

    entry_name_uniq_p() {
      this.time_records_hash_update()
    },

    rule_key(v) {
      this.current_rule_index = this.current_rule.code
    },

    current_rule_index(v) {
      // このタブを始めて開いたときランキングの1ページ目に合わせる
      // this.current_pages[v] ||= 1 相当
      if (!this.current_pages[v]) {
        this.$set(this.current_pages, v, 1)
      }

      // タブインデックスからルールのキーを求めてプルダウンの方にも反映する
      this.rule_key = RuleInfo.fetch(v).key
    },

    spent_sec() {
      if (this.time_over_p) {
        this.stop_handle()
        this.toast_ok("時間切れ")
      }
    },
  },

  methods: {
    sidebar_toggle() {
      this.sound_play("click")
      this.sidebar_p = !this.sidebar_p
    },

    next_button() {
      this.sound_play("o")
      this.o_count++
      this.goal_check()
      if (this.mode === "is_mode_run") {
        this.place_next_set()
      }
    },

    time_records_hash_update() {
      if (this.scope_key) {
        const params = {
          time_records_hash_fetch: true,
          scope_key: this.scope_key,
          entry_name_uniq_p: this.entry_name_uniq_p,
        }
        return this.$axios.$get("/api/ts_master/time_records.json", {params: params}).then(e => {
          this.time_records_hash = e
        })
      }
    },

    var_init() {
      this.scope_key         = null
      this.rule_key          = null
      this.chart_rule_key    = null
      this.entry_name        = null
      this.current_pages     = null
    },

    init_other_variables() {
      this.countdown_counter = 0
      this.micro_seconds = 0
      this.o_count = 0
      this.x_count = 0
      this.key_queue = []
      this.time_record = null

      this.sp_body_reset()
    },

    start_handle() {
      this.sp_body_reset()

      const params = {
        questions_fetch: true,
        rule_key: this.current_rule.key,
      }
      this.$axios.$get("/api/ts_master/time_records.json", {params: params}).then(e => {
        this.questions = e.questions

        this.sound_play("click")
        this.mode = "is_mode_ready"
        this.init_other_variables()
        this.latest_rule = this.current_rule
        this.sound_stop_all()
        this.interval_counter.start()
        this.scroll_set(false)
      })
    },

    countdown_func(counter) {
      this.countdown_counter = counter
      if (this.countdown === 0) {
        this.interval_counter.stop()
        this.go_handle()
      }
    },

    time_add_func(v) {
      this.micro_seconds = v * 1000
    },

    go_handle() {
      this.mode = "is_mode_run"
      this.interval_frame.start()
      this.place_next_set()
      this.sound_play("start")
      this.goal_check()
    },

    stop_handle() {
      this.sound_play("click")
      this.mode = "is_mode_stop"
      this.timer_stop()
      this.interval_counter.stop()
      this.sp_body_reset()
      this.scroll_set(true)
    },

    restart_handle() {
      this.stop_handle()
      this.start_handle()
    },

    goal_handle() {
      this.mode = "is_mode_goal"
      this.timer_stop()
      this.sp_body_reset()
      this.scroll_set(true)
      this.talk("おわりました")

      if (this.current_entry_name) {
        this.entry_name = this.current_entry_name
        this.record_post()
      } else {
        this.$buefy.dialog.prompt({
          message: `名前を入力してください`,
          confirmText: "保存",
          cancelText: "キャンセル",
          inputAttrs: { type: "text", value: this.entry_name, placeholder: "名前", },
          canCancel: false,
          onConfirm: value => {
            this.entry_name = _.trim(value)
            if (this.entry_name !== "") {
              this.record_post()
            }
          },
        })
      }
    },

    sp_body_reset() {
      // this.sp_body = "position sfen l6n+B/2n6/p1p+R2s1p/+b3pk1p1/2GN1pp2/3P3s1/PP1l1P2P/3S1G3/+r1PK4L b 2GSNPl4p 95"
      this.sp_body = ""
      this.sp_viewpoint = "black"
    },

    // 名前を確定してからサーバーに保存する
    async record_post() {
      const params = {
        scope_key: this.scope_key,
        time_record:    this.post_params,
      }
      const data = await this.$axios.$post("/api/ts_master/time_records", params)

      this.entry_name_uniq_p = false // 「プレイヤー別順位」の解除
      this.data_update(data)         // ランキングに反映

      // ランク内ならランキングのページをそのページに移動する
      if (this.current_rank <= this.config.rank_max) {
        this.$set(this.current_pages, this.current_rule_index, this.time_record.rank_info[this.scope_key].page)
      }

      // おめでとう
      this.congrats_talk()

      // チャートの表示状態をゲームのルールに合わせて「最近」にして更新しておく
      this.chart_rule_key = this.rule_key
      this.chart_scope_key = "chart_scope_recently"
      this.chart_data_get_and_show()
    },

    data_update(params) {
      const rule_info = RuleInfo.fetch(params.time_record.rule_key)
      this.$set(this.time_records_hash, rule_info.key, params.time_records)
      this.time_record = params.time_record
    },

    congrats_talk() {
      let message = ""
      if (this.entry_name) {
        message += `${this.entry_name}さん`
        if (this.time_record.rank_info.scope_today.rank <= CONGRATS_LTEQ) {
          message += `おめでとうございます。`
        }
        if (this.time_record.best_update_info) {
          message += `自己ベストを${this.time_record.best_update_info.updated_spent_sec}秒更新しました。`
        }
        const t_r = this.time_record.rank_info.scope_today.rank
        const a_r = this.time_record.rank_info.scope_all.rank
        message += `本日${t_r}位です。`
        message += `全体で`
        if (t_r === a_r) {
          message += `も`
        } else {
          message += `は`
        }
        message += `${a_r}位です。`
        // if (this.current_rank > this.config.rank_max) {
        //   message += `ランキング外です。`
        // }
        this.talk(message)
      }
    },

    timer_stop() {
      this.interval_frame.stop()
    },

    goal_check() {
      if (this.count_rest <= 0) {
        this.goal_handle()
        return
      }
    },

    place_next_set() {
      this.sp_body      = this.current_question_sfen
      this.sp_viewpoint = this.current_question_location_key
    },

    time_format_from_msec(v) {
      return dayjs.unix(v).format("m:ss")
    },

    time_default_format(v) {
      return dayjs(v).format("YYYY-MM-DD")
    },

    magic_number() {
      return dayjs().format("YYMMDDHHmm")
    },
  },

  computed: {
    base()           { return this           },
    ScopeInfo()      { return ScopeInfo      },
    ChartScopeInfo() { return ChartScopeInfo },
    RuleInfo()       { return RuleInfo       },

    component_style() {
      return {
      }
    },

    is_mode_idol() {
      return this.mode === "is_mode_stop" || this.mode === "is_mode_goal"
    },

    is_mode_active() {
      return this.mode === "is_mode_run" || this.mode === "is_mode_ready"
    },

    countdown() {
      return COUNTDOWN_MAX - this.countdown_counter
    },

    summary() {
      let out = ""
      if (this.latest_rule) {
        out += `ルール: ${this.latest_rule.mate}手詰x${this.latest_rule.o_count_max}問\n`
      }
      if (this.time_record) {
        out += `本日: ${this.time_record.rank_info.scope_today.rank}位\n`
        out += `全体: ${this.time_record.rank_info.scope_all.rank}位\n`
      }
      out += `タイム: ${this.time_format}`
      if (this.time_record) {
        if (this.time_record.best_update_info) {
          out += ` (${this.time_record.best_update_info.updated_spent_sec}秒更新)`
        }
      }
      out += `\n`
      if (this.time_avg) {
        out += `平均: ${this.time_avg}\n`
      }
      if (false) {
        out += `不正解: ${this.x_count}\n`
        out += `正解率: ${this.rate_per}%\n`
      }
      return out
    },

    post_params() {
      return [
        "rule_key",
        "spent_sec",
        "entry_name",
        "x_count",              // なくてもよい
        "summary",              // なくてもよい
      ].reduce((a, e) => ({...a, [e]: this[e]}), {})
    },

    o_count_max() {
      return this.latest_rule.o_count_max
    },

    time_over_p() {
      const v = this.current_rule.time_limit
      if (v) {
        return this.spent_sec >= v
      }
    },

    tweet_url() {
      return this.tweet_url_build_from_text(this.tweet_body)
    },

    tweet_body() {
      let out = ""
      out += this.summary
      out += "#実戦詰将棋一期一会\n"
      out += this.location_url_without_search_and_hash() + "?" + this.magic_number()
      return out
    },

    rate_per() {
      return this.float_to_perc(this.rate)
    },

    rate() {
      if (this.total_count === 0) {
        return 0
      }
      return this.o_count / this.total_count
    },

    total_count() {
      return this.o_count + this.x_count
    },

    count_rest() {
      return this.o_count_max - this.o_count
    },

    time_format() {
      return this.time_format_from_msec(this.spent_sec)
    },

    time_avg() {
      if (this.o_count >= 1) {
        return this.time_format_from_msec(this.spent_sec / this.o_count)
      }
    },

    spent_sec() {
      return this.micro_seconds / 1000
    },

    // ログインしているとユーザー名がわかる
    current_entry_name() {
      if (this.g_current_user) {
        return this.g_current_user.name
      }
    },

    curent_scope() {
      return ScopeInfo.fetch(this.scope_key)
    },

    current_rule() {
      return RuleInfo.fetch(this.rule_key)
    },

    ////////////////////////////////////////////////////////////////////////////////

    default_rule_key() {
      return "rule_mate3_type1"
    },

    current_rank() {
      return this.time_record.rank_info[this.scope_key].rank
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin
    ls_storage_key() {
      return "ts_master"
    },
    ls_default() {
      return {
        rule_key:        this.default_rule_key,
        chart_rule_key:  this.default_rule_key,
        scope_key:       "scope_today",
        chart_scope_key: "chart_scope_recently",
        entry_name:         this.current_entry_name,
        current_pages:      {},
      }
    },
    ////////////////////////////////////////////////////////////////////////////////
    question_exist_p() {
      if (this.questions) {
        return this.questions[this.o_count]
      }
    },
    current_question_sfen() {
      return `position sfen ${this.current_question.sfen}`
    },
    current_question() {
      return this.questions[this.o_count]
    },
    current_question_location_key() {
      return this.sfen_parse(this.current_question_sfen).base_location.key
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .TsMasterApp
    .column, .buttons, .CustomShogiPlayerWrap, .time_container, .vector_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.TsMasterApp-Sidebar
  .menu-label
    margin-top: 2em

.TsMasterApp
  touch-action: manipulation

  +bulma_buttons_button_bottom_marginless

  .CustomShogiPlayerWrap
    width: 100%

    position: relative          // カウントダウン領域の基点にするため

    display: flex
    justify-content: center
    align-items: center
    flex-direction: column

    .CustomShogiPlayer
      +touch
        width: 100%
      +desktop
        width: calc(100vmin * 0.66)

  .next_button
    margin-top: 3rem

  .tweet_box_container
    margin-top: 0.75rem
    white-space: pre-wrap

  ////////////////////////////////////////////////////////////////////////////////
  &.is_mode_idol
    .MainSection.section
      padding: $ts_master_common_gap 0 0
    .CustomShogiPlayerWrap
      margin-top: $ts_master_common_gap
      +mobile
        margin-top: 0
  &.is_mode_active
    .MainSection.section
      +mobile
        padding: 0.75rem 0 0
</style>
