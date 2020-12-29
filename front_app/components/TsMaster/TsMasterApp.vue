<template lang="pug">
.TsMasterApp(:class="mode" :style="component_style")
  MainNavbar(v-if="idol_p")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'checkmate'}") 詰将棋道場
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
    PageCloseButton(@click="stop_handle" position="is_absolute" v-if="playing_p")
    TsMasterRestart(:base="base" v-if="playing_p")
    .container
      .columns
        .column
          .buttons.is-centered.mb-0(v-if="idol_p")
            b-button(@click="start_handle" type="is-primary") START

            b-dropdown.is-pulled-left(v-model="rule_key" @click.native="sound_play('click')")
              button.button(slot="trigger")
                span {{current_rule.name}}
                b-icon(icon="menu-down")
              template(v-for="e in RuleInfo.values")
                b-dropdown-item(:value="e.key") {{e.name}}

            b-button(@click="rule_dialog_show" icon-right="help")

          .DigitBoardTime.is-unselectable
            .vector_container.has-text-weight-bold.is-inline-block(v-if="tap_method_p && false")
              template(v-if="mode === 'is_mode_ready'")
                | ？？
              template(v-if="mode === 'is_mode_run'")
                | {{kanji_human}}

            .CustomShogiPlayerWrap
              TsMasterCountdown(:base="base")
              CustomShogiPlayer(
                ref="main_sp"
                :sp_body="current_sp_body"
                sp_run_mode="play_mode"
                :sp_turn="0"
                sp_summary="is_summary_off"
                :sp_hidden_if_piece_stand_blank="true"
                :sp_viewpoint="current_rule.viewpoint"
                sp_controller="is_controller_on"
              )

            .time_container.fixed_font.is-size-3(v-if="false")
              | {{time_format}}

            .buttons.mt-4
              b-button(@click="next_button" size="is-medium") NEXT

          TsMasterSlider(:base="base")

          .box.tweet_box_container.has-text-centered(v-if="mode === 'is_mode_goal'")
            | {{summary}}
            TweetButton.mt-2(:body="tweet_body")

        TsMasterRanking(:base="base")

      TsMasterChart(:base="base" ref="TsMasterChart")
  DebugPre {{$data}}
</template>

<script>
import _ from "lodash"
import dayjs from "dayjs"

import MemoryRecord from 'js-memory-record'
import { Soldier } from "shogi-player/components/models/soldier.js"
import { Place } from "shogi-player/components/models/place.js"

import { isMobile        } from "@/components/models/isMobile.js"
import { IntervalCounter } from '@/components/models/IntervalCounter.js'
import { IntervalFrame   } from '@/components/models/IntervalFrame.js'

import { support_parent } from "./support_parent.js"

import { app_chart       } from "./app_chart.js"
import { app_keyboard    } from "./app_keyboard.js"
import { app_debug       } from "./app_debug.js"
import { app_rule_dialog } from "./app_rule_dialog.js"

import ls_support from "@/components/models/ls_support.js"

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
  name: "TsMasterApp",
  mixins: [
    support_parent,
    ls_support,
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
      current_sp_body:      null, // 今のセル
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
    this.ga_click("詰将棋道場")
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
    next_button() {
      this.sound_play("o")
      this.o_count++
      this.goal_check()
      if (this.mode === "is_mode_run") {
        this.place_next_set()
      }
      // } else {
      //   this.x_count++
      //   this.sound_play("x")
      // }
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
      this.before_place = null
      this.current_sp_body = null
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
    },

    restart_handle() {
      this.stop_handle()
      this.start_handle()
    },

    goal_handle() {
      this.mode = "is_mode_goal"
      this.timer_stop()
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
      this.sp_object().api_board_clear()
    },

    goal_check() {
      if (this.count_rest <= 0) {
        this.goal_handle()
        return
      }
    },

    place_next_set() {
      this.current_sp_body = "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 8c8d 7g7f 7a6b 5g5f 8d8e 8h7g 5c5d 2h5h 6b5c 7i6h 5a4b 5i4h 3a3b 4h3h 4c4d 5f5e 3b4c 5e5d 4c5d 6h5g 5d6e 5g5f 6e7f 5f5e 7f6g+ P*5d 5c6b 5h5f 6g7g 8i7g B*3d 5f6f P*5b 6i7i 8b8d 5e4d 8d7d P*7h 7d5d S*4c 3d4c 4d4c+ 4b4c B*7f 5b5c 7i6h 4c3b 6h5h P*4c 7f5d 5c5d 8g8f B*7i 8f8e P*8b 6f8f 7i3e+ 8e8d S*7b 8f8i 3e4e P*6g 7c7d 9g9f 4e5f 8i8f 5f5e 9f9e 5e6d 8f8i 7d7e 7g8e 5d5e 8e9c+ 8a9c 9e9d P*9h 9i9h 6d6e 8i8f 6e9h 9d9c+ 9a9c R*9a 9h6e 9a9c+ 5e5f 5h4h L*9b 9c8b P*8a N*7g 6e7d 8b9a S*8b 9a8b 8a8b S*6e 7d9f 8f5f 9f7h 7g8e 7h6g P*7c 7b8a P*9c 6c6d P*6h 6g8e 9c9b+ 8a9b 7c7b+ 6a7b 6e5d N*4b 5d5c+ P*5d 5c6b 7b6b L*2f R*6i L*2e N*3a 5f4f S*3d 3g3f 6b5c 2i3g 4c4d 4f5f 2c2d 2e2d P*2c 3f3e 3d3e 2d2c+ 3a2c 2f2c+ 3b2c P*3f 3e2d 5f5i 6i6h+ 1g1f L*3d N*2h 4d4e 5i5h 6h7g 2g2f 1c1d 2f2e 2d1c 3g4e 5c4d S*4f P*2f 4e5c+ L*4e 4f5g 8e7d P*6e 7d6e P*5f 5d5e 4h3g 5e5f 5g4h P*4f 3g4f 4e4f"
    },

    active_p(x, y) {
      if (this.current_sp_body) {
        return _.isEqual(this.current_sp_body, {x: x, y: y})
      }
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
      }
    },

    idol_p() {
      return this.mode === 'is_mode_stop' || this.mode === 'is_mode_goal'
    },

    playing_p() {
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
      out += "#詰将棋道場\n"
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

    //////////////////////////////////////////////////////////////////////////////// for ls_support
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
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .TsMasterApp
    .column, .buttons, .CustomShogiPlayerWrap, .time_container, .vector_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.TsMasterApp
  touch-action: manipulation

  +bulma_buttons_button_bottom_marginless

  .MainSection
    +mobile
      padding: $xym_common_gap 0 0

  .DigitBoardTime
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    margin-top: $xym_common_gap

    .vector_container
      margin-bottom: $xym_board_top_bottom_gap
      font-size: 2rem

    .time_container
      line-height: 100%
      margin-top: $xym_board_top_bottom_gap

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
        width: calc(100vmin * 0.50)

    .CustomShogiPlayer
      // --sp_board_padding: 0                  // 盤の隙間なし
      // --sp_board_color: hsla(0, 0%, 0%, 0)   // 盤の色
      // --sp_grid_outer_stroke: 2              // 外枠の太さ
      // --sp_grid_stroke: 1                    // グリッド太さ
      // --sp_grid_outer_color: hsl(0, 0%, 64%) // グリッド外枠色
      // --sp_grid_color:       hsl(0, 0%, 73%) // グリッド色
      // --sp_board_aspect_ratio: 1.0           // 盤を正方形化
      // --sp_grid_star_size: 16%               // 星の大きさ
      // --sp_grid_star_color: hsl(0, 0%, 50%)  // 星の色

  .tweet_box_container
    margin-top: 0.75rem
    white-space: pre-wrap
</style>
