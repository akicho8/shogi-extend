<template lang="pug">
.XyMasterApp(:class="mode" :style="component_style")
  MainNavbar(v-if="is_mode_idol")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'xy'}") 符号の鬼
    template(slot="end")
      b-navbar-dropdown(hoverable arrowless right label="デバッグ" v-if="development_p")
        b-navbar-item(@click="ls_reset") ブラウザに記憶した情報の削除
        b-navbar-item(@click="var_init") 保存可能な変数のリセット
        b-navbar-item ランキングタブの各表示ページ:{{current_pages}}

      NavbarItemLogin
      NavbarItemProfileLink

  b-navbar(type="is-dark" fixed-bottom v-if="development_p")
    template(slot="start")
      b-navbar-item(@click="reset_all_handle") リセット
      b-navbar-item(@click="goal_handle") ゴール
      b-navbar-item(@click="rebuild_handle") リビルド

  MainSection
    PageCloseButton(@click="stop_handle" position="is_absolute" v-if="is_mode_active")
    XyMasterRestart(:base="base" v-if="is_mode_active")
    .container
      .columns
        .column
          .buttons.is-centered.mb-0(v-if="is_mode_idol")
            b-button.has-text-weight-bold(@click="start_handle" type="is-primary") START

            b-dropdown.is-pulled-left(v-model="rule_key" @click.native="sound_play('click')")
              button.button(slot="trigger")
                span {{current_rule.name}}
                b-icon(icon="menu-down")
              template(v-for="e in RuleInfo.values")
                b-dropdown-item(:value="e.key") {{e.name}}

            b-button(@click="rule_dialog_show" icon-right="help")

          .DigitBoardTime.is-unselectable
            .vector_container.has-text-weight-bold.is-inline-block(v-if="tap_method_p && is_mode_active")
              template(v-if="mode === 'is_mode_ready'")
                | ？？
              template(v-if="mode === 'is_mode_run'")
                | {{kanji_human}}

            .CustomShogiPlayerWrap
              XyMasterCountdown(:base="base")
              //- 「持ちあげる処理」を無効にするために sp_board_cell_left_click_user_handle で true を返している
              CustomShogiPlayer(
                ref="main_sp"
                sp_body="position sfen 9/9/9/9/9/9/9/9/9 b - 1"
                sp_summary="is_summary_off"
                sp_pi_variant="is_pi_variant_b"
                :sp_hidden_if_piece_stand_blank="true"
                :sp_viewpoint="current_rule.viewpoint"
                :sp_board_piece_back_user_class="sp_board_piece_back_user_class"
                :sp_board_cell_pointerdown_user_handle="sp_board_cell_pointerdown_user_handle"
                :sp_board_cell_left_click_user_handle="() => true"
              )

            .time_container.fixed_font.is-size-3
              | {{time_format}}

          XyMasterSlider(:base="base")

          .box.tweet_box_container.has-text-centered(v-if="mode === 'is_mode_goal'")
            | {{summary}}
            TweetButton.mt-2(:body="tweet_body")

        XyMasterRanking(:base="base")

      XyMasterChart(:base="base" ref="XyMasterChart")
  DebugPre {{$data}}
</template>

<script>
import _ from "lodash"
import dayjs from "dayjs"

import MemoryRecord from 'js-memory-record'
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

import ls_support_mixin from "@/components/models/ls_support_mixin.js"

class RuleInfo extends MemoryRecord {
}

class ScopeInfo extends MemoryRecord {
}

class ChartScopeInfo extends MemoryRecord {
}

const COUNTDOWN_INTERVAL = 0.5  // カウントダウンはN秒毎に進む
const COUNTDOWN_MAX      = 3    // カウントダウンはNから開始する
const DIMENSION          = 9    // 盤面の辺サイズ
const CONGRATS_LTEQ      = 10   // N位以内ならおめでとう

export default {
  name: "XyMasterApp",
  mixins: [
    support_parent,
    ls_support_mixin,
    app_keyboard,
    app_debug,
    app_rule_dialog,
    app_chart,
  ],
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      mode: "is_mode_stop",
      countdown_counter:  null, // カウントダウン用カウンター
      before_place:       null, // 前のセル
      current_place:      null, // 今のセル
      o_count:            null, // 正解数
      x_count:            null, // 不正解数
      key_queue:          null, // PCモードでの押したキー
      micro_seconds:      null, // 経過時間
      entry_name_uniq_p: false, // プレイヤー別順位ON/OFF
      rule_key:        null, // ../../../app/models/rule_info.rb のキー
      scope_key:       null, // ../../../app/models/scope_info.rb のキー
      entry_name:         null, // ランキングでの名前を保持しておく
      current_rule_index: null, // b-tabs 連動用
      time_records_hash:    null, // 複数のルールでそれぞれにランキング情報も入っている
      time_record:          null, // ゲームが終わたっときにランクなどが入っている
      current_pages:      null, // b-table のページ
      latest_rule:        null, // 最後に挑戦した最新のルール
      interval_counter: new IntervalCounter(this.countdown_func, {early: true, interval: COUNTDOWN_INTERVAL}),
      interval_frame:   new IntervalFrame(this.time_add_func),
      touch_board_width: null, // touchデバイスでの将棋盤の幅(%)
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
    this.ga_click("符号の鬼")
    this.sp_object().api_board_clear()
  },

  beforeDestroy() {
    this.interval_counter.stop()
    this.interval_frame.stop()
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
    place_talk(place) {
      const x = DIMENSION - place.x
      const y = place.y + 1
      this.talk(`${x} ${y}`, {rate: 2.0})
    },

    // こっちは prevent.stop されてないので自分で呼ぶ
    sp_board_cell_pointerdown_user_handle(place, event) {
      if (this.mode === "is_mode_run") {
        if (this.tap_method_p) {
          this.input_valid(place)
        } else {
          this.place_talk(place)
        }
      } else {
        this.place_talk(place)
      }
      // ダブルタップによる拡大禁止の意味でこれを入れたが効果はなかったけど一応そのまま入れとこう
      event.preventDefault()
      event.stopPropagation()
      return true
    },

    // 最後に押したところに色をつける
    sp_board_piece_back_user_class(place) {
      if (this.tap_method_p) {
        if (this.mode === "is_mode_run") {
          if (this.before_place) {
            if (this.xy_equal_p(this.before_place, place)) {
              return "has-background-primary-light"
            }
          }
        }
      }
    },

    time_records_hash_update() {
      if (this.scope_key) {
        const params = {
          time_records_hash_fetch: true,
          scope_key: this.scope_key,
          entry_name_uniq_p: this.entry_name_uniq_p,
        }
        return this.$axios.$get("/api/xy_master/time_records.json", {params: params}).then(e => {
          this.time_records_hash = e
        })
      }
    },

    var_init() {
      this.scope_key      = null
      this.rule_key       = null
      this.chart_rule_key = null
      this.entry_name        = null
      this.current_pages     = null
      this.touch_board_width = null
    },

    init_other_variables() {
      this.countdown_counter = 0
      this.micro_seconds = 0
      this.before_place = null
      this.current_place = null
      this.o_count = 0
      this.x_count = 0
      this.key_queue = []
      this.time_record = null
    },

    start_handle() {
      this.sound_play("click")
      this.mode = "is_mode_ready"
      this.init_other_variables()
      this.latest_rule = this.current_rule
      this.talk_stop()
      this.sp_object().api_viewpoint_set(this.current_rule.viewpoint)
      this.interval_counter.start()
      this.scroll_set(false)
    },

    countdown_func(counter) {
      this.countdown_counter = counter
      if (this.countdown === 0) {
        this.interval_counter.stop()
        this.go_handle()
      }
    },

    time_add_func(v) {
      this.micro_seconds += v
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
      this.scroll_set(true)
    },

    restart_handle() {
      this.stop_handle()
      this.start_handle()
    },

    goal_handle() {
      this.mode = "is_mode_goal"
      this.timer_stop()
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

    // 名前を確定してからサーバーに保存する
    async record_post() {
      const params = {
        scope_key: this.scope_key,
        time_record:    this.post_params,
      }
      const data = await this.$axios.$post("/api/xy_master/time_records", params)

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
      this.sp_object().api_board_clear()
    },

    keydown_handle_core(e) {
      if (this.mode != "is_mode_run") {
        return
      }
      if (this.tap_method_p) {
        if (!this.development_p) {
          return
        }
      }

      if (e.key === "Escape") {
        this.key_queue = []
        e.preventDefault()
        return
      }
      if (e.key.match(/^\d/)) {
        this.key_queue.push(e.key)
        if (this.key_queue.length >= 2) {
          const x = DIMENSION - parseInt(this.key_queue.shift())
          const y = parseInt(this.key_queue.shift()) - 1
          this.input_valid({x, y})
        }
        e.preventDefault()
        return
      }
    },

    input_valid(xy) {
      if (this.active_p(xy)) {
        this.sound_play("o")
        this.o_count++
        this.goal_check()
        if (this.mode === "is_mode_run") {
          this.place_next_set()
        }
      } else {
        this.x_count++
        this.sound_play("x")
      }
    },

    goal_check() {
      if (this.count_rest <= 0) {
        this.goal_handle()
        return
      }
    },

    place_next_set() {
      this.before_place = this.current_place

      let p = null
      if (true) {
        while (true) {
          p = {x: this.place_random(), y: this.place_random()}
          if ((this.o_count === 0 && (DIMENSION - 1 - p.x) === p.y)) {
            continue
          }
          if (this.before_place) {
            if (_.isEqual(this.before_place, p)) {
              continue
            }
          }
          break
        }
      }
      if (false) {
        p = {x: this.place_random(), y: _.sample([5,6])}
      }

      if (!this.tap_method_p) {
        const soldier = Soldier.random()
        soldier.place = Place.fetch([p.x, p.y])
        this.sp_object().api_board_clear()
        this.sp_object().api_place_on(soldier)
      }

      this.current_place = p
    },

    active_p(xy) {
      if (this.current_place) {
        return this.xy_equal_p(this.current_place, xy)
      }
    },

    xy_equal_p(a, b) {
      return a.x === b.x && a.y === b.y
    },

    place_random() {
      return _.random(0, DIMENSION - 1)
    },

    time_format_from_msec(v) {
      return dayjs.unix(v).format("m:ss.SSS")
    },

    time_default_format(v) {
      return dayjs(v).format("YYYY-MM-DD")
    },

    magic_number() {
      return dayjs().format("YYMMDDHHmm")
    },

    // computed 側にすると動かなくなるので注意
    sp_object() {
      return this.$refs.main_sp.sp_object()
    },
  },

  computed: {
    base()             { return this                             },
    ScopeInfo()      { return ScopeInfo                      },
    ChartScopeInfo() { return ChartScopeInfo                 },
    RuleInfo()       { return RuleInfo                       },

    component_style() {
      return {
        "--touch_board_width": this.touch_board_width,
      }
    },

    is_mode_idol() {
      return this.mode === 'is_mode_stop' || this.mode === 'is_mode_goal'
    },

    is_mode_active() {
      return this.mode === 'is_mode_run' || this.mode === 'is_mode_ready'
    },

    countdown() {
      return COUNTDOWN_MAX - this.countdown_counter
    },

    summary() {
      let out = ""
      if (this.latest_rule) {
        out += `ルール: ${this.latest_rule.name}\n`
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
      out += `不正解: ${this.x_count}\n`
      out += `正解率: ${this.rate_per}%\n`
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
      return this.spent_sec >= this.current_rule.time_limit
    },

    tweet_url() {
      return this.tweet_url_build_from_text(this.tweet_body)
    },

    tweet_body() {
      let out = ""
      out += this.summary
      out += "#符号の鬼\n"
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

    tap_method_p() {
      return this.current_rule.input_mode === "tap"
    },

    keyboard_method_p() {
      return this.current_rule.input_mode === "keyboard"
    },

    ////////////////////////////////////////////////////////////////////////////////

    kanji_human() {
      if (this.current_place_info) {
        return this.current_place_info.kanji_human
      }
    },

    current_place_info() {
      if (this.current_place_xy) {
        return Place.fetch(this.current_place_xy)
      }
    },

    current_place_xy() {
      if (this.current_place) {
        const { x, y } = this.current_place
        return [x, y]
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    default_rule_key() {
      if (isMobile.any()) {
        return "rule100t"
      } else {
        return "rule100"
      }
    },

    current_rank() {
      return this.time_record.rank_info[this.scope_key].rank
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin
    // |------------------+----------------------------------------|
    // | "xy_master"      | stopwatch のライブラリを使っていたころ |
    // | "new_xy_master"  | xy プレフィクスついていたころ          |
    // | "new_xy_master2" | xy プレフィクスついてない現状          |
    // |------------------+----------------------------------------|
    ls_storage_key() {
      return "new_xy_master2"
    },
    ls_default() {
      return {
        rule_key:        this.default_rule_key,
        chart_rule_key:  this.default_rule_key,
        scope_key:       "scope_today",
        chart_scope_key: "chart_scope_recently",
        entry_name:         this.current_entry_name,
        current_pages:      {},
        touch_board_width:  0.9,
      }
    },
    ////////////////////////////////////////////////////////////////////////////////
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .XyMasterApp
    .column, .buttons, .CustomShogiPlayerWrap, .time_container, .vector_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.XyMasterApp
  touch-action: manipulation

  +bulma_buttons_button_bottom_marginless

  .MainSection.section
    +mobile
      padding: $xy_master_common_gap 0 0

  .DigitBoardTime
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    margin-top: $xy_master_common_gap

    .vector_container
      margin-bottom: $xy_master_board_top_bottom_gap
      font-size: 2rem

    .time_container
      line-height: 100%
      margin-top: $xy_master_board_top_bottom_gap

  .CustomShogiPlayerWrap
    width: 100%

    position: relative          // カウントダウン領域の基点にするため

    display: flex
    justify-content: center
    align-items: center
    flex-direction: column

    .CustomShogiPlayer
      +touch
        width: calc(var(--touch_board_width) * 100%)
      +desktop
        width: calc(100vmin * 0.50)

    .CustomShogiPlayer
      --sp_board_padding: 0                  // 盤の隙間なし
      --sp_board_color: hsla(0, 0%, 0%, 0)   // 盤の色
      --sp_grid_outer_stroke: 2              // 外枠の太さ
      --sp_grid_stroke: 1                    // グリッド太さ
      --sp_grid_outer_color: hsl(0, 0%, 64%) // グリッド外枠色
      --sp_grid_color:       hsl(0, 0%, 73%) // グリッド色
      --sp_board_aspect_ratio: 1.0           // 盤を正方形化
      --sp_grid_star_size: 16%               // 星の大きさ
      --sp_grid_star_color: hsl(0, 0%, 50%)  // 星の色
      --sp_shadow_offset: 0                  // 影なし
      --sp_shadow_blur: 0                    // 影なし

  .tweet_box_container
    margin-top: 0.75rem
    white-space: pre-wrap
</style>
