<template lang="pug">
.XyMasterLiteApp(:class="[mode, 'is_input_mode_tap']" :style="component_css_vars")
  MainSection
    .container
      .columns
        .column
          .DigitBoardTime.is-unselectable
            .vector_container.has-text-weight-bold.is-inline-block
              template(v-if="current_place")
                | {{kanji_human(current_place)}}

            .CustomShogiPlayerWrap
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

  // .section(v-if="development_p")
  //   .container.is-fluid
  //     XyMasterLiteDebugPanels
</template>

<script>
import _ from "lodash"
import dayjs from "dayjs"

import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { Soldier } from "shogi-player/components/models/soldier.js"
import { Place   } from "shogi-player/components/models/place.js"

import { MyMobile } from "@/components/models/my_mobile.js"

import { support_parent  } from "./support_parent.js"
import { mod_debug       } from "./mod_debug.js"
import { mod_storage     } from "./mod_storage.js"
import { mod_style       } from "./mod_style.js"
import { mod_tweet       } from "./mod_tweet.js"
import { mod_chore       } from "./mod_chore.js"

import { RuleInfo       } from "./models/rule_info.js"
import { GhostPresetInfo } from "./models/ghost_preset_info.js"

export default {
  name: "XyMasterLiteApp",
  mixins: [
    support_parent,
    mod_debug,
    mod_storage,
    mod_style,
    mod_tweet,
    mod_chore,
  ],
  provide() {
    return {
      TheApp: this,
    }
  },
  data() {
    return {
      mode: "is_mode_stop",
      config: {}, // カウントダウン用カウンター
      before_place:       null, // 前のセル
      tapped_place:       null, // タップしたセル
      current_place:      null, // 今のセル
      next_place:         null, // 次のセル
      rule_key:           null, // ../../../app/models/rule_info.rb のキー
      current_rule_index: null, // b-tabs 連動用
    }
  },

  created() {
    this.rule_key = "rule100t"
    this.init_other_variables()
  },

  beforeMount() {
  },

  mounted() {
    this.sfen_clear_or_set()
    this.start_handle()
  },

  beforeDestroy() {
    // this.scroll_set(true)
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
      this.rule_key = RuleInfo.fetch(v).key
    },
  },

  methods: {
    // // こっちは prevent.stop されてないので自分で呼ぶ
    ev_action_board_cell_pointerdown(place, event) {
      this.cell_tap_handle(place, event)
      return true
    },

    cell_tap_handle(place, event) {
      this.input_valid(place)
      // ダブルタップによる拡大禁止の意味でこれを入れたが効果はなかったけど一応そのまま入れとこう
      event.preventDefault()
      event.stopPropagation()
      return true
    },

    var_init() {
      this.rule_key       = null
    },

    init_other_variables() {
      this.micro_seconds = 0
      this.tapped_place = null
      this.before_place = null
      this.current_place = null
    },

    start_handle() {
      this.sfx_stop_all()
      this.sfx_click()
      this.init_other_variables()
      this.sp_object().api_viewpoint_set(this.rule_info.viewpoint)
      this.sfen_clear_or_set()
      // this.scroll_set(false)

      this.go_handle()
    },

    time_add_func(v) {
      this.micro_seconds += v
    },

    go_handle() {
      this.mode = "is_mode_run"
      this.place_next_next_setup()
      this.place_next_set()
      this.sfx_play("start")
    },

    stop_handle() {
      this.sfx_click()
      this.mode = "is_mode_stop"
      this.timer_stop()
      // this.scroll_set(true)
    },

    timer_stop() {
      this.sfen_clear_or_set()
    },

    input_valid(xy) {
      this.tapped_place = xy
      if (this.active_p(xy)) {
        this.sfx_play("o")
        this.place_next_set()
      } else {
        this.sfx_play("x")
      }
    },

    place_next_next_setup() {
      this.next_place = this.generate_next()
    },

    place_next_set() {
      this.before_place = this.current_place

      const p = this.next_place

      this.current_place = p
      this.next_place = this.generate_next(p)
    },

    generate_next(before = null) {
      let p = null
      while (true) {
        p = this.random_xy()
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

    // computed 側にすると動かなくなるので注意
    sp_object() {
      return this.$refs.main_sp.sp_object()
    },

    kanji_human(xy) {
      const { x, y } = xy
      return Place.fetch([x, y]).kanji_human
    },

    sfen_set() {
      this.sp_object().api_sfen_or_kif_set(this.ghost_preset_info.sfen)
      this.debug_alert("set")
    },

    sfen_clear() {
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

    RuleInfo()          { return RuleInfo                                                     },
    rule_info()         { return RuleInfo.fetch(this.rule_key)                                },

    DIMENSION()         { return 9                                                            }, // 盤面の辺サイズ
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.STAGE-development
  .XyMasterLiteApp
    .column, .buttons, .CustomShogiPlayerWrap, .vector_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.XyMasterLiteApp
  touch-action: manipulation

  +bulma_buttons_button_bottom_marginless

  .MainSection.section
    +mobile
      padding: $xy_master_lite_common_gap 0 0

  .DigitBoardTime
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column
    margin-top: $xy_master_lite_common_gap

    .vector_container
      margin-bottom: $xy_master_lite_board_top_bottom_gap
      font-size: 2rem
      position: relative
      .next_place
        white-space: nowrap
        position: absolute
        top: 0
        left: 7rem
        color: $grey-light

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
        width: calc(100dvmin * 0.50)

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

  &.is_input_mode_tap
    +setvar(sp_board_piece_size, 0.766)                                                          // セル内の駒の大きさ
    .CustomShogiPlayer
      .PieceTexture
        opacity: var(--xy_piece_opacity)                                                  // ゴーストの濃さ

    .is_tapped_cell                                                                       // 直前に押されたセル
      background-color: $primary !important                                               // 青くする(詳細度で負けるため!importantが必要)
</style>
