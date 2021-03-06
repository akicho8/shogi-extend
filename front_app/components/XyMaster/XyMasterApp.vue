<template lang="pug">
.XyMasterApp(:class="mode" :style="component_style")
  XyMasterSidebar(:base="base")
  XyMasterNavbar(:base="base")
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

            b-button(@click="help_dialog_show" icon-right="help")

          .DigitBoardTime.is-unselectable
            .vector_container.has-text-weight-bold.is-inline-block(v-if="tap_method_p && is_mode_active")
              template(v-if="mode === 'is_mode_ready'")
                | ？？
              template(v-if="mode === 'is_mode_run'")
                | {{kanji_human(current_place)}}
                .next_place(v-if="false")
                  | {{kanji_human(next_place)}}

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

          .box.tweet_box_container.has-text-centered(v-if="mode === 'is_mode_goal'")
            | {{summary}}
            TweetButton.mt-2(:body="tweet_body" @after_click="sound_play('click')")

        XyMasterRanking(:base="base")

      XyMasterChart(:base="base" ref="XyMasterChart")

  .section(v-if="development_p")
    .container.is-fluid
      XyMasterDebugPanels(:base="base")
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

import { app_chart    } from "./app_chart.js"
import { app_debug    } from "./app_debug.js"
import { app_help     } from "./app_help.js"
import { app_keyboard } from "./app_keyboard.js"
import { app_main     } from "./app_main.js"
import { app_ranking  } from "./app_ranking.js"
import { app_sidebar  } from "./app_sidebar.js"
import { app_storage  } from "./app_storage.js"
import { app_style    } from "./app_style.js"
import { app_tweet    } from "./app_tweet.js"
import { app_chore    } from "./app_chore.js"

class RuleInfo extends MemoryRecord {
}

class ScopeInfo extends MemoryRecord {
}

class ChartScopeInfo extends MemoryRecord {
}

const COUNTDOWN_INTERVAL = 0.5     // カウントダウンはN秒毎に進む
const COUNTDOWN_MAX      = 3       // カウントダウンはNから開始する
const NEXT_IF_X          = "false" // 間違えたら次の問題にするか？

export default {
  name: "XyMasterApp",
  mixins: [
    support_parent,
    app_chart,
    app_debug,
    app_help,
    app_keyboard,
    app_main,
    app_ranking,
    app_sidebar,
    app_storage,
    app_style,
    app_tweet,
    app_chore,
  ],
  props: {
    config: { type: Object, required: true },
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
    RuleInfo.memory_record_reset(this.config.rule_info)
    ScopeInfo.memory_record_reset(this.config.scope_info)
    ChartScopeInfo.memory_record_reset(this.config.chart_scope_info)

    this.init_other_variables()
  },

  beforeMount() {
    this.interval_counter = new IntervalCounter(this.countdown_func, {early: true, interval: COUNTDOWN_INTERVAL})
    this.interval_frame   = new IntervalFrame(this.time_add_func, {debug: false})
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

      this.style_reset()
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
      this.sound_stop_all()
      this.sound_play("click")
      this.mode = "is_mode_ready"
      this.init_other_variables()
      this.latest_rule = this.current_rule
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
      this.place_next_next_setup()
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

      this.ranking_goal_process()
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
        this.sound_play("o")
        this.o_count++
        this.goal_check()
        if (this.mode === "is_mode_run") {
          this.place_next_set()
        }
      } else {
        this.x_count++
        this.sound_play("x")
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

      if (!this.tap_method_p) {
        const soldier = Soldier.random()
        soldier.place = Place.fetch([p.x, p.y])
        this.sp_object().api_board_clear()
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
  },

  computed: {
    base()           { return this           },
    ScopeInfo()      { return ScopeInfo      },
    ChartScopeInfo() { return ChartScopeInfo },
    RuleInfo()       { return RuleInfo       },
    DIMENSION()      { return 9              }, // 盤面の辺サイズ

    is_mode_idol()   { return this.mode === 'is_mode_stop' || this.mode === 'is_mode_goal' },
    is_mode_active() { return this.mode === 'is_mode_run' || this.mode === 'is_mode_ready' },
    countdown()      { return COUNTDOWN_MAX - this.countdown_counter },

    NEXT_IF_X()      { return this.$route.query.NEXT_IF_X || NEXT_IF_X },

    curent_scope() {
      return ScopeInfo.fetch(this.scope_key)
    },

    current_rule() {
      return RuleInfo.fetch(this.rule_key)
    },

    tap_method_p()      { return this.current_rule.input_mode === "tap" },
    keyboard_method_p() { return this.current_rule.input_mode === "keyboard" },

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
      --sp_board_padding: 0                                   // 盤の隙間なし
      --sp_board_color: hsla(0, 0%, 0%, 0)                    // 盤の色
      --sp_grid_outer_stroke: calc(var(--xy_grid_stroke) + 1) // 外枠の太さ
      --sp_grid_stroke: var(--xy_grid_stroke)                 // グリッド太さ
      --sp_grid_outer_color: hsl(0, 0%, calc((64.0 - var(--xy_grid_color)) * 1.0%))                  // グリッド外枠色
      --sp_grid_color:       hsl(0, 0%, calc((73.0 - var(--xy_grid_color)) * 1.0%))                  // グリッド色
      --sp_board_aspect_ratio: 1.0                            // 盤を正方形化
      --sp_grid_star_size: calc(var(--xy_grid_star_size) * 1.0%)  // 星の大きさ
      --sp_grid_star_color: hsl(0, 0%, calc((50.0 - var(--xy_grid_color)) * 1.0%))                   // 星の色
      --sp_shadow_offset: 0                                   // 影なし
      --sp_shadow_blur: 0                                     // 影なし

  .tweet_box_container
    margin-top: 0.75rem
    white-space: pre-wrap
</style>
