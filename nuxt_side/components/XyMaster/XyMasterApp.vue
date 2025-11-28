<template lang="pug">
.XyMasterApp(:class="[mode, rule_info.input_mode]" :style="component_css_vars")
  XyMasterSidebar
  XyMasterNavbar
  MainSection
    PageCloseButton(@click="stop_handle" position="is_absolute" v-if="is_mode_active")
    XyMasterRestart(v-if="is_mode_active")
    .container
      .columns
        .column
          .buttons.is-centered.mb-0(v-if="is_mode_idol")
            b-button.has-text-weight-bold(@click="start_handle" type="is-primary") START

            b-dropdown.is-pulled-left(v-model="rule_key" @click.native="sfx_click()")
              button.button(slot="trigger")
                span {{rule_info.name}}
                b-icon(icon="menu-down")
              template(v-for="e in RuleInfo.values")
                b-dropdown-item(:value="e.key") {{e.name}}

            b-button(@click="help_dialog_show" icon-right="help")

          .DigitBoardTime.is-unselectable
            .vector_container.has-text-weight-bold.is-inline-block(v-if="tap_mode_p && is_mode_active")
              template(v-if="mode === 'is_mode_ready'")
                | ？？
              template(v-if="mode === 'is_mode_run'")
                | {{kanji_human(current_place)}}
                .next_place(v-if="false")
                  | {{kanji_human(next_place)}}

            .CustomShogiPlayerWrap
              XyMasterCountdown
              //- 「持ちあげる処理」を無効にするために sp_board_cell_left_click_user_handle で true を返している
              //- sp_mode="play"
              CustomShogiPlayer(
                ref="main_sp"
                sp_mode="play"
                sp_human_side="none"
                sp_body="position sfen 9/9/9/9/9/9/9/9/9 b - 1"
                sp_piece_variant="paper"
                sp_piece_stand_blank_then_hidden
                :sp_viewpoint="rule_info.viewpoint"
                :sp_board_cell_class_fn="sp_board_cell_class_fn"
                @ev_action_board_cell_pointerdown="ev_action_board_cell_pointerdown"
              )
              //- :sp_board_cell_left_click_user_handle="sp_board_cell_left_click_user_handle"

            .time_container.is-family-monospace.is-size-3
              | {{time_format}}

          .tweet_box_container.mt-4(v-if="mode === 'is_mode_goal'")
            .box.mb-0
              | {{summary}}
            TweetButton.mt-3(:body="tweet_body" @after_click="sfx_click()")

        XyMasterRanking

      XyMasterChart(ref="XyMasterChart")

  .section(v-if="development_p")
    .container.is-fluid
      XyMasterDebugPanels
</template>

<script>
import _ from "lodash"
import dayjs from "dayjs"

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Soldier } from "shogi-player/components/models/soldier.js"
import { Place   } from "shogi-player/components/models/place.js"

import { MyMobile } from "@/components/models/my_mobile.js"
import { IntervalCounter } from '@/components/models/interval_counter.js'
import { IntervalFrame   } from '@/components/models/interval_frame.js'

import { support_parent  } from "./support_parent.js"
import { mod_chart       } from "./mod_chart.js"
import { mod_debug       } from "./mod_debug.js"
import { mod_help        } from "./mod_help.js"
import { mod_keyboard    } from "./mod_keyboard.js"
import { mod_play_break        } from "./mod_play_break.js"
import { mod_ranking     } from "./mod_ranking.js"
import { mod_sidebar     } from "./mod_sidebar.js"
import { mod_storage     } from "./mod_storage.js"
import { mod_style       } from "./mod_style.js"
import { mod_tap_detect  } from "./mod_tap_detect.js"
import { mod_tweet       } from "./mod_tweet.js"
import { mod_chore       } from "./mod_chore.js"

import { RuleInfo       } from "./models/rule_info.js"
import { ScopeInfo      } from "./models/scope_info.js"
import { ChartScopeInfo } from "./models/chart_scope_info.js"
import { GhostPresetInfo } from "./models/ghost_preset_info.js"

const COUNTDOWN_INTERVAL = 0.5     // カウントダウンはN秒毎に進む
const COUNTDOWN_MAX      = 3       // カウントダウンはNから開始する
const NEXT_IF_X          = "false" // 間違えたら次の問題にするか？

export default {
  name: "XyMasterApp",
  mixins: [
    support_parent,
    mod_chart,
    mod_debug,
    mod_help,
    mod_keyboard,
    mod_play_break,
    mod_ranking,
    mod_sidebar,
    mod_storage,
    mod_style,
    mod_tap_detect,
    mod_tweet,
    mod_chore,
  ],
  props: {
    config: { type: Object, required: true },
  },
  provide() {
    return {
      TheApp: this,
    }
  },
  data() {
    return {
      mode: "is_mode_stop",
      countdown_counter:  null, // カウントダウン用カウンター
      before_place:       null, // 前のセル
      tapped_place:       null, // タップしたセル
      current_place:      null, // 今のセル
      next_place:         null, // 次のセル
      key_queue:          null, // PCモードでの押したキー
      rule_key:           null, // ../../../app/models/rule_info.rb のキー
      scope_key:          null, // ../../../app/models/scope_info.rb のキー
      current_rule_index: null, // b-tabs 連動用
      time_records_hash:  null, // 複数のルールでそれぞれにランキング情報も入っている
      time_record:        null, // ゲームが終わたっときにランクなどが入っている
      current_pages:      null, // b-table のページ
      interval_counter:   null,
      interval_frame:     null,
    }
  },

  created() {
    this.init_other_variables()
  },

  beforeMount() {
    this.interval_counter = new IntervalCounter(this.countdown_func, {early: true, interval: COUNTDOWN_INTERVAL})
    this.interval_frame   = new IntervalFrame(this.time_add_func, {debug: false})
  },

  mounted() {
    this.app_log("符号の鬼")
    this.sfen_clear_or_set()
  },

  beforeDestroy() {
    this.interval_counter.stop()
    this.interval_frame.stop()
  },

  watch: {
    ghost_preset_key(v) {
      this.sfen_set()
    },

    rule_key(v) {
      this.current_rule_index = this.rule_info.code
      this.sfen_clear_or_set()
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
      this.time_over_check()
    },
  },

  methods: {
    // // こっちは prevent.stop されてないので自分で呼ぶ
    ev_action_board_cell_pointerdown(place, event) {
      if (this.tap_detect_key === "pointerdown") {
        this.cell_tap_handle(place, event)
      }
      return true               // break
    },

    // sp_board_cell_left_click_user_handle(place, event) {
    //   if (this.tap_detect_key === "click") {
    //     this.cell_tap_handle(place, event)
    //   }
    //   return true               // break
    // },

    cell_tap_handle(place, event) {
      if (this.mode === "is_mode_run") {
        if (this.tap_mode_p) {
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

    async time_records_hash_update() {
      if (this.scope_key) {
        const params = {
          time_records_hash_fetch: true,
          scope_key: this.scope_key,
          entry_name_uniq_p: this.entry_name_uniq_p,
        }
        this.time_records_hash = await this.$axios.$get("/api/xy_master/time_records.json", {params: params})
      }
    },

    var_init() {
      this.scope_key      = null
      this.rule_key       = null
      this.chart_rule_key = null
      this.entry_name        = null
      this.current_pages     = null
    },

    init_other_variables() {
      this.countdown_counter = 0
      this.micro_seconds = 0
      this.tapped_place = null
      this.before_place = null
      this.current_place = null
      this.o_count = 0
      this.x_count = 0
      this.key_queue = []
      this.time_record = null
    },

    start_handle() {
      this.sfx_stop_all()
      this.sfx_click()
      this.mode = "is_mode_ready"
      this.init_other_variables()
      this.latest_rule = this.rule_info
      this.sp_object().api_viewpoint_set(this.rule_info.viewpoint)
      this.sfen_clear_or_set()
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
      this.place_next_next_setup()
      this.place_next_set()
      this.sfx_play("start")
      this.goal_check()
    },

    stop_handle() {
      this.sfx_click()
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

      this.ranking_goal_process()
    },

    timer_stop() {
      this.interval_frame.stop()
      this.sfen_clear_or_set()
    },

    keydown_handle_core(e) {
      if (this.mode != "is_mode_run") {
        return
      }
      if (this.tap_mode_p) {
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
          const x = this.DIMENSION - parseInt(this.key_queue.shift())
          const y = parseInt(this.key_queue.shift()) - 1
          this.input_valid({x, y})
        }
        e.preventDefault()
        return
      }
    },

    input_valid(xy) {
      this.tapped_place = xy
      if (this.active_p(xy)) {
        this.sfx_play("o")
        this.o_count++
        this.goal_check()
        if (this.mode === "is_mode_run") {
          this.place_next_set()
        }
      } else {
        this.x_count++
        this.sfx_play("x")
        this.too_many_miss_check()
        if (this.NEXT_IF_X === "true") {
          this.place_next_set()
        }
      }
    },

    goal_check() {
      if (this.count_rest <= 0) {
        this.goal_handle()
        return
      }
    },

    place_next_next_setup() {
      this.next_place = this.generate_next()
    },

    place_next_set() {
      this.before_place = this.current_place

      const p = this.next_place

      if (this.kb_mode_p) {
        const soldier = Soldier.random()
        soldier.place = Place.fetch([p.x, p.y])
        this.sfen_clear()
        this.sp_object().api_place_on(soldier)
      }

      this.current_place = p
      this.next_place = this.generate_next(p)
    },

    generate_next(before = null) {
      let p = null
      while (true) {
        p = this.random_xy()
        // if ((this.o_count === 0 && (this.DIMENSION - 1 - p.x) === p.y)) {
        //   continue
        // }
        if (before) {
          if (_.isEqual(before, p)) {
            continue
          }
        }
        break
      }
      return p
    },

    random_xy() {
      return {
        x: this.place_random(),
        y: this.place_random(),
      }
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
      return _.random(0, this.DIMENSION - 1)
    },

    time_format_from_msec(v) {
      return dayjs.unix(v).format("m:ss.SSS")
    },

    time_default_format(v) {
      return dayjs(v).format("YYYY-MM-DD")
    },

    // computed 側にすると動かなくなるので注意
    sp_object() {
      return this.$refs.main_sp.sp_object()
    },

    kanji_human(xy) {
      const { x, y } = xy
      return Place.fetch([x, y]).kanji_human
    },

    sfen_set() {
      if (this.tap_mode_p) {
        this.sp_object().api_sfen_or_kif_set(this.ghost_preset_info.sfen)
        this.debug_alert("set")
      }
    },

    sfen_clear() {
      if (this.kb_mode_p) {
        this.sp_object().api_board_clear()
        this.debug_alert("clear")
      }
    },

    sfen_clear_or_set() {
      this.$nextTick(() => {
        this.sfen_clear()
        this.sfen_set()
      })
    },

  },

  computed: {
    GhostPresetInfo()   { return GhostPresetInfo                                              },
    ghost_preset_info() { return this.GhostPresetInfo.fetch(this.ghost_preset_key)            },

    ScopeInfo()         { return ScopeInfo                                                    },
    curent_scope()      { return ScopeInfo.fetch(this.scope_key)                              },

    RuleInfo()          { return RuleInfo                                                     },
    rule_info()         { return RuleInfo.fetch(this.rule_key)                                },

    ChartScopeInfo()    { return ChartScopeInfo                                               },
    DIMENSION()         { return 9                                                            }, // 盤面の辺サイズ

    is_mode_idol()      { return this.mode === 'is_mode_stop' || this.mode === 'is_mode_goal' },
    is_mode_active()    { return this.mode === 'is_mode_run' || this.mode === 'is_mode_ready' },
    countdown()         { return COUNTDOWN_MAX - this.countdown_counter                       },

    NEXT_IF_X()         { return this.param_to_s("NEXT_IF_X", NEXT_IF_X)                     },

    tap_mode_p()        { return this.rule_info.input_mode === "is_input_mode_tap"            },
    kb_mode_p()         { return this.rule_info.input_mode === "is_input_mode_kb"             },

    current_rank()      { return this.time_record.rank_info[this.scope_key].rank              },

    ////////////////////////////////////////////////////////////////////////////////

    default_rule_key() {
      if (MyMobile.mobile_p) {
        return "rule100t"
      } else {
        return "rule100"
      }
    },
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
      position: relative
      .next_place
        white-space: nowrap
        position: absolute
        top: 0
        left: 7rem
        color: $grey-light

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
      +setvar(sp_board_padding, 0)                                                               // 盤の隙間なし
      +setvar(sp_board_color, hsla(0, 0%, 0%, 0))                                                // 盤の色
      +setvar(sp_grid_outer_stroke, calc(var(--xy_grid_stroke) + 1))                             // 外枠の太さ
      +setvar(sp_grid_inner_stroke, var(--xy_grid_stroke))                                       // グリッド太さ
      +setvar(sp_grid_outer_color, hsl(0, 0%, calc((64.0 - var(--xy_grid_color)) * 1.0%)))       // グリッド外枠色
      +setvar(sp_grid_inner_color,       hsl(0, 0%, calc((73.0 - var(--xy_grid_color)) * 1.0%))) // グリッド色
      +setvar(sp_board_aspect_ratio, 1.0)                                                        // 盤を正方形化
      +setvar(sp_star_size, calc(var(--xy_grid_star_size) / 100.0))                              // 星の大きさ
      +setvar(sp_star_color, hsl(0, 0%, calc((50.0 - var(--xy_grid_color)) * 1.0%)))             // 星の色
      +setvar(sp_star_z_index, -1)                                                               // 星を盤の裏に表示(重要)

  &.is_input_mode_tap
    +setvar(sp_board_piece_size, 0.766)                                                          // セル内の駒の大きさ
    .CustomShogiPlayer
      .PieceTexture
        opacity: var(--xy_piece_opacity)                                                  // ゴーストの濃さ

    .is_tapped_cell                                                                       // 直前に押されたセル
      background-color: $primary !important                                               // 青くする(詳細度で負けるため!importantが必要)

  .tweet_box_container
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
    white-space: pre-wrap
</style>
