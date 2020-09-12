<template lang="pug">
.XyMasterApp(:class="[mode, {tap_mode: tap_mode, kb_mode: !tap_mode}]")
  b-navbar(type="is-dark" fixed-bottom v-if="development_p")
    template(slot="start")
      b-navbar-item(@click="reset_all_handle") リセット
      b-navbar-item(@click="goal_handle") ゴール
      b-navbar-item(@click="rebuild_handle") リビルド

  b-navbar(type="is-primary" v-if="mode === 'stop' || mode === 'goal'")
    template(slot="brand")
      b-navbar-item(tag="span")
        b 符号の鬼
    template(slot="end")
      b-navbar-dropdown(hoverable arrowless right label="デバッグ" v-if="development_p")
        b-navbar-item(@click="data_restore_from_hash({})") 変数の初期化
        b-navbar-item(@click="storage_clear") ブラウザに記憶した情報の削除
        b-navbar-item(@click="persistense_variables_init") 保存可能な変数のリセット
        b-navbar-item ランキングタブの各表示ページ:{{current_pages}}

      b-navbar-item(v-if="config.current_user" tag="span")
        .image.avatar_image
          img.is-rounded(:src="config.current_user.avatar_path")
      b-navbar-item(v-if="!config.current_user || development_p" @click="login_handle") ログイン

      b-navbar-item(tag="a" href="/") TOPに戻る

      b-navbar-dropdown(hoverable arrowless right v-if="development_p")
        template(slot="label")
          b-icon(icon="menu")
        b-navbar-item(tag="a" href="/") TOPに戻る

  .section(:class="mode")
    .columns
      .column
        .buttons.is-centered.mb-0
          template(v-if="mode === 'stop' || mode === 'goal'")
            button.button.is-primary(@click="start_handle") START
          template(v-if="mode === 'run' || mode === 'ready'")
            b-button.restart_button(@click="restart_handle" type="" size="" icon-left="restart")
            a.delete.is-large(tag="a" @click="stop_handle")

          template(v-if="mode === 'stop' || mode === 'goal'")
            b-dropdown.is-pulled-left(v-model="xy_rule_key" @input="sound_play('click')" @click.native="sound_play('click')")
              button.button(slot="trigger")
                span {{current_rule.name}}
                b-icon(icon="menu-down")
              template(v-for="e in XyRuleInfo.values")
                b-dropdown-item(:value="e.key") {{e.name}}

            b-button(@click="rule_display" icon-right="help")
        .has-text-centered
          .level_container(v-if="mode === 'goal' && false")
            .level.is-mobile
              .level-item.has-text-centered
                div
                  p.heading
                    b-icon(icon="checkbox-blank-circle-outline" type="is-info" size="is-small")
                  p.title {{o_count}}
              .level-item.has-text-centered
                div
                  p.heading
                    b-icon(icon="close" type="is-danger" size="is-small")
                  p.title {{x_count}}

          .tap_digits_container(v-if="tap_mode")
            .value
              | {{kanji_human}}

          .shogi_player_container
            template(v-if="mode === 'ready'")
              .countdown_wrap
                .countdown
                  | {{countdown}}
            shogi_player(
              ref="main_sp"
              :kifu_body="kifu_body"
              :summary_show="false"
              :hidden_if_piece_stand_blank="true"
              :setting_button_show="false"
              :theme="'simple'"
              :size="sp_size"
              :flip="current_rule.flip"
              :board_piece_back_user_class="board_piece_back_user_class"
              :overlay_navi="false"
              :board_cell_left_click_user_handle="board_cell_left_click_user_handle"
            )

          .time_container
            .fixed_font.is-size-2
              | {{time_format}}

          template(v-if="mode === 'goal'")
            .tweet_box_container
              .box
                .summary
                  | {{summary}}
                .tweet_button_container
                  .buttons.is-centered
                    a.button.is-info.is-rounded(:href="tweet_url")
                      | &nbsp;
                      b-icon(icon="twitter" size="is-small")
                      | &nbsp;
                      | ツイート

      .column.is-4(v-if="(mode === 'stop' || mode === 'goal') && xy_records_hash")
        b-field.xy_scope_info_field
          template(v-for="e in XyScopeInfo.values")
            b-radio-button(v-model="xy_scope_key" :native-value="e.key" @input="sound_play('click')")
              | {{e.name}}

        b-tabs(v-model="current_rule_index" expanded @input="sound_play('click')")
          template(v-for="xy_rule_info in XyRuleInfo.values")
            b-tab-item(:label="xy_rule_info.name" :value="xy_rule_info.key")
              b-table(
                :data="xy_records_hash[xy_rule_info.key]"
                :paginated="true"
                :per-page="config.per_page"
                :current-page.sync="current_pages[current_rule_index]"
                :pagination-simple="false"
                :mobile-cards="false"
                :row-class="(row, index) => row.id === (xy_record && xy_record.id) && 'is-selected'"
                :narrowed="true"
                default-sort-direction="desc"
                )
                b-table-column(v-slot="props" field="rank"       label="順位"   sortable centered :width="1") {{props.row.rank}}
                b-table-column(v-slot="props" field="entry_name" label="名前"   sortable) {{string_truncate(props.row.entry_name || '？？？', {length: 15})}}
                b-table-column(v-slot="props" field="spent_sec"  label="タイム" sortable) {{time_format_from_msec(props.row.spent_sec)}}
                b-table-column(v-slot="props" field="created_at" label="日付"   sortable :visible="curent_scope.date_visible") {{time_default_format(props.row.created_at)}}

        .has-text-centered-mobile
          b-switch(v-model="entry_name_unique") プレイヤー別順位

    .columns.is-centered.chart_box_container(v-show="(mode === 'stop' || mode === 'goal')")
      .column
        .columns
          template(v-if="development_p")
            .column
              .has-text-centered
                b-field.is-inline-flex
                  b-button(@click="chart_show" size="is-small")
                    | 更新
          .column
            .has-text-centered
              b-field.is-inline-flex
                template(v-for="e in XyRuleInfo.values")
                  b-radio-button(v-model="xy_chart_rule_key" :native-value="e.key" size="is-small" @input="sound_play('click')")
                    | {{e.name}}
          .column
            .has-text-centered
              b-field.is-inline-flex
                template(v-for="e in XyChartScopeInfo.values")
                  b-radio-button(v-model="xy_chart_scope_key" :native-value="e.key" size="is-small" @input="sound_play('click')")
                    | {{e.name}}
        .columns.is-centered
          .column.is-half
            canvas#chart_canvas(ref="chart_canvas")
            template(v-if="config.count_all_gteq > 1")
              .has-text-centered
                | {{config.count_all_gteq}}回以上やるとチャートに登場します
</template>

<script>
import _ from "lodash"
import dayjs from "dayjs"

import stopwatch_data_retention from '../Stopwatch/stopwatch_data_retention.js'
import MemoryRecord from 'js-memory-record'

import { isMobile        } from "../../../app/javascript/models/isMobile.js"
import { IntervalCounter } from '@/components/models/IntervalCounter.js'

import { app_chart       } from "./app_chart.js"
import { app_keyboard    } from "./app_keyboard.js"
import { app_debug       } from "./app_debug.js"
import { app_rule_dialog } from "./app_rule_dialog.js"

import shogi_player from "shogi-player/src/components/ShogiPlayer.vue"
import Soldier      from "shogi-player/src/soldier.js"
import Place        from "shogi-player/src/place.js"

class XyRuleInfo extends MemoryRecord {}
class XyScopeInfo extends MemoryRecord {}
class XyChartScopeInfo extends MemoryRecord {}

const COUNTDOWN_INTERVAL = 0.5  // カウントダウンはN秒毎に進む
const COUNTDOWN_MAX      = 3    // カウントダウンはNから開始する
const DIMENSION          = 9    // 盤面の辺サイズ
const CONGRATS_LTEQ      = 10   // N位以内ならおめでとう

export default {
  name: "XyMasterApp",
  mixins: [
    app_keyboard,
    app_debug,
    app_rule_dialog,
    stopwatch_data_retention,
    app_chart,
  ],
  components: {
    shogi_player,
  },
  props: {
    config: { type: Object, required: true },
  },
  data() {
    return {
      // dynamic
      mode: "stop",
      inteval_id: null,
      countdown_counter: null,
      sub_mode: null,
      before_place: null,
      current_place: null,
      o_count: null,               // 正解数
      x_count: null,               // 不正解数
      key_queue: null,
      timer_run: false,
      micro_seconds: null,
      entry_name_unique: false,
      xy_rule_key: null,        // ../../../app/models/xy_rule_info.rb のキー
      xy_scope_key: null,       // ../../../app/models/xy_scope_info.rb のキー
      entry_name: null,         // ランキングでの名前を保持しておく
      current_rule_index: null, // b-tabs 連動用
      xy_records_hash: null,    // 複数のルールでそれぞれにランキング情報も入っている
      xy_record: null,          // ゲームが終わたっときにランクなどが入っている
      current_pages: null,
      latest_rule: null, // 最後に挑戦した最新のルール
      kifu_body: "position sfen 9/9/9/9/9/9/9/9/9 b - 1",
      interval_counter: new IntervalCounter(this.countdown_callback, {interval: COUNTDOWN_INTERVAL}),
    }
  },

  created() {
    XyRuleInfo.memory_record_reset(this.config.xy_rule_info)
    XyScopeInfo.memory_record_reset(this.config.xy_scope_info)
    XyChartScopeInfo.memory_record_reset(this.config.xy_chart_scope_info)

    this.data_restore_from_url_or_storage()

    this.init_other_variables()
    this.timer_setup()
  },

  mounted() {
    this.$refs.main_sp.api_board_clear()
  },

  beforeDestroy() {
    this.interval_counter.stop()
  },

  watch: {
    entry_name() { this.data_save_to_local_storage() },

    current_pages: { handler() { this.data_save_to_local_storage() }, deep: true },

    xy_scope_key() {
      this.xy_records_hash_update()
      this.data_save_to_local_storage()
    },

    entry_name_unique() {
      this.xy_records_hash_update()
    },

    xy_rule_key(v) {
      this.current_rule_index = this.current_rule.code
      this.data_save_to_local_storage()
    },

    current_rule_index(v) {
      // このタブを始めて開いたときランキングの1ページ目に合わせる
      // this.current_pages[v] ||= 1 相当
      if (!this.current_pages[v]) {
        this.$set(this.current_pages, v, 1)
      }

      // タブインデックスからルールのキーを求めてプルダウンの方にも反映する
      this.xy_rule_key = XyRuleInfo.fetch(v).key
    },
  },

  methods: {
    place_talk(place) {
      const x = DIMENSION - place.x
      const y = place.y + 1
      this.talk(`${x} ${y}`, {rate: 2.0})
    },

    board_cell_left_click_user_handle(place, event) {
      if (this.mode === "run") {
        if (this.tap_mode) {
          this.input_valid(place.x, place.y)
        } else {
          this.place_talk(place)
        }
      } else {
        this.place_talk(place)
      }
      return true
    },

    board_piece_back_user_class(place) {
      if (!this.tap_mode) {
        if (this.mode === "run") {
        }
      }
    },

    xy_records_hash_update() {
      const params = {
        xy_records_hash_fetch: true,
        xy_scope_key: this.xy_scope_key,
        entry_name_unique: this.entry_name_unique,
      }
      return this.$axios.get("/api/xy", {params: params}).then(({data}) => this.xy_records_hash = data)
    },

    persistense_variables_init() {
      // this.xy_rule_key      = null
      // this.xy_chart_rule_key     = null
      this.entry_name       = null
      this.current_pages    = null
      this.data_restore_from_hash({})
    },

    data_restore_from_hash(e) {
      this.xy_rule_key = e.xy_rule_key
      if (!XyRuleInfo.lookup(this.xy_rule_key)) {
        this.xy_rule_key = this.default_xy_rule_key
      }

      this.xy_scope_key = e.xy_scope_key
      if (!XyScopeInfo.lookup(this.xy_scope_key)) {
        this.xy_scope_key = "xy_scope_today"
      }

      this.xy_chart_scope_key = e.xy_chart_scope_key
      if (!XyChartScopeInfo.lookup(this.xy_chart_scope_key)) {
        this.xy_chart_scope_key = "chart_scope_recently"
      }

      this.xy_chart_rule_key = e.xy_chart_rule_key
      if (!XyRuleInfo.lookup(this.xy_chart_rule_key)) {
        this.xy_chart_rule_key = this.default_xy_rule_key
      }

      this.entry_name = this.current_user_name || e.entry_name
      this.current_pages = e.current_pages || {}
    },

    timer_setup() {
      let start = window.performance.now()
      const loop = () => {
        const now = window.performance.now()
        if (this.timer_run) {
          this.micro_seconds += now - start
        }
        start = now
        window.requestAnimationFrame(loop)
      }
      loop()
    },

    init_other_variables() {
      this.micro_seconds = 0
      this.before_place = null
      this.current_place = null
      this.o_count = 0
      this.x_count = 0
      this.key_queue = []
      this.xy_record = null
    },

    start_handle() {
      this.sound_play("click")
      this.mode = "ready"
      this.init_other_variables()
      this.latest_rule = this.current_rule
      this.talk_stop()
      this.$refs.main_sp.api_flip_set(this.current_rule.flip)
      this.interval_counter.start()
    },

    countdown_callback(counter) {
      this.countdown_counter = counter
      if (this.countdown === 0) {
        this.interval_counter.stop()
        this.go_handle()
      }
    },

    go_handle() {
      this.mode = "run"
      this.timer_run = true
      this.place_next_set()
      this.sound_play("start")
      this.goal_check()
    },

    stop_handle() {
      this.sound_play("click")
      this.mode = "stop"
      this.timer_stop()
      this.interval_counter.stop()
    },

    restart_handle() {
      this.stop_handle()
      this.start_handle()
    },

    goal_handle() {
      this.mode = "goal"
      this.timer_stop()
      this.talk("おわりました")

      if (this.current_user_name) {
        this.entry_name = this.current_user_name
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
        xy_scope_key: this.xy_scope_key,
        xy_record:    this.post_params,
      }
      const { data } = await this.$axios.post("/api/xy", params)

      this.entry_name_unique = false // 「プレイヤー別順位」の解除
      this.data_update(data)         // ランキングに反映

      // ランク内ならランキングのページをそのページに移動する
      if (this.current_rank <= this.config.rank_max) {
        this.$set(this.current_pages, this.current_rule_index, this.xy_record.rank_info[this.xy_scope_key].page)
      }

      // おめでとう
      this.congrats_talk()

      // チャートの表示状態をゲームのルールに合わせて「最近」にして更新しておく
      this.xy_chart_rule_key = this.xy_rule_key
      this.xy_chart_scope_key = "chart_scope_recently"
      this.chart_show()
    },

    data_update(params) {
      const xy_rule_info = XyRuleInfo.fetch(params.xy_record.xy_rule_key)
      this.$set(this.xy_records_hash, xy_rule_info.key, params.xy_records)
      this.xy_record = params.xy_record
    },

    congrats_talk() {
      let message = ""
      if (this.entry_name) {
        message += `${this.entry_name}さん`
        if (this.xy_record.rank_info.xy_scope_today.rank <= CONGRATS_LTEQ) {
          message += `おめでとうございます。`
        }
        if (this.xy_record.best_update_info) {
          message += `自己ベストを${this.xy_record.best_update_info.updated_spent_sec}秒更新しました。`
        }
        const t_r = this.xy_record.rank_info.xy_scope_today.rank
        const a_r = this.xy_record.rank_info.xy_scope_all.rank
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
        this.talk(message, {rate: 1.2})
      }
    },

    timer_stop() {
      this.timer_run = false
      this.$refs.main_sp.api_board_clear()
    },

    keydown_handle_core(e) {
      if (this.mode != "run") {
        return
      }
      if (this.tap_mode) {
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
          const x = parseInt(this.key_queue.shift())
          const y = parseInt(this.key_queue.shift())
          this.input_valid(DIMENSION - x, y - 1)
        }
        e.preventDefault()
        return
      }
    },

    input_valid(x, y) {
      if (this.active_p(x, y)) {
        this.sound_play("o")
        this.o_count++
        this.goal_check()
        if (this.mode === "run") {
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

      if (!this.tap_mode) {
        const soldier = Soldier.random()
        soldier.place = Place.fetch([p.x, p.y])
        this.$refs.main_sp.api_board_clear()
        this.$refs.main_sp.api_place_on(soldier)
      }

      this.current_place = p
    },

    active_p(x, y) {
      if (this.current_place) {
        return _.isEqual(this.current_place, {x: x, y: y})
      }
    },

    place_random() {
      return _.random(0, DIMENSION - 1)
    },

    time_format_from_msec(v) {
      return dayjs.unix(v).format("mm:ss.SSS")
    },

    time_default_format(v) {
      return dayjs(v).format("YYYY-MM-DD")
    },

    magic_number() {
      return dayjs().format("YYMMDDHHmm")
    },
  },

  computed: {
    sp_size() {
      if (this.mode === "ready" || this.mode === "run") {
        if (!isMobile.any()) {
          return "large"
        }
      }
    },

    countdown() {
      return COUNTDOWN_MAX - this.countdown_counter
    },

    summary() {
      let out = ""
      if (this.latest_rule) {
        out += `ルール: ${this.latest_rule.name}\n`
      }
      if (this.xy_record) {
        out += `本日: ${this.xy_record.rank_info.xy_scope_today.rank}位\n`
        out += `全体: ${this.xy_record.rank_info.xy_scope_all.rank}位\n`
      }
      out += `タイム: ${this.time_format}`
      if (this.xy_record) {
        if (this.xy_record.best_update_info) {
          out += ` (${this.xy_record.best_update_info.updated_spent_sec}秒更新)`
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
        "xy_rule_key",
        "spent_sec",
        "entry_name",
        "x_count",              // なくてもよい
        "summary",              // なくてもよい
      ].reduce((a, e) => ({...a, [e]: this[e]}), {})
    },

    o_count_max() {
      return this.latest_rule.o_count_max
    },

    $_ls_hash() {
      return {
        xy_scope_key:      this.xy_scope_key,
        xy_rule_key:       this.xy_rule_key,
        xy_chart_rule_key: this.xy_chart_rule_key,
        entry_name:        this.entry_name,
        current_pages:     this.current_pages,
      }
    },

    ls_key() {
      return "xy_master"
    },

    tweet_url() {
      return this.tweet_intent_url(this.tweet_body)
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
    current_user_name() {
      if (this.config.current_user) {
        return this.config.current_user.name
      }
    },

    curent_scope() {
      return XyScopeInfo.fetch(this.xy_scope_key)
    },

    current_rule() {
      return XyRuleInfo.fetch(this.xy_rule_key)
    },

    tap_mode() {
      return this.current_rule.tap_mode
    },

    kanji_human() {
      if (this.mode === "run") {
        if (this.current_place) {
          const place = Place.fetch([this.current_place.x, this.current_place.y])
          return place.kanji_human
        }
      }
      return "？？"
    },

    default_xy_rule_key() {
      if (isMobile.any()) {
        return "xy_rule100t"
      } else {
        return "xy_rule100"
      }
    },

    current_rank() {
      return this.xy_record.rank_info[this.xy_scope_key].rank
    },

    XyScopeInfo() { return XyScopeInfo },
    XyChartScopeInfo() { return XyChartScopeInfo },
    XyRuleInfo() { return XyRuleInfo },
  },
}
</script>

<style lang="sass">
$board_color: hsl(0, 0%, 60%)

.XyMasterApp
  .restart_button
    position: fixed
    top: 0.5rem
    right: 0.2rem
  a.delete
    position: fixed
    top: 0.5rem
    left: 0.5rem

  .section
    +mobile
      padding: 2.0rem 0.5rem
      &.run, &.ready
        padding: 1.5rem 0.5rem

  // .level_container
  //   width: 10rem
  //   margin: 0 auto
  //   .title
  //     font-size: $size-7
  //     font-weight: normal
  //     position: relative
  //     top: -0.2rem

  .tap_digits_container
    margin-top: 0.8rem
    .value
      margin: 0 auto
      background-color: hsl(0, 0%, 95%)
      border-radius: 0.5rem
      padding: 0.3rem
      width: 5rem
      font-weight: bold
      font-size: 1.75rem
  .shogi_player_container
    position: relative
    .countdown_wrap
      z-index: 1
      position: absolute
      top: 0%
      bottom: 0%
      left: 0%
      right: 0%
      margin: auto
      // border: 1px dotted blue

      display: flex
      justify-content: center
      align-items: center
      .countdown
        font-size: 24rem
        color: $primary
        -webkit-text-stroke: 1px $white
        text-shadow: change_color($black, $alpha: 0.1) 0px 0px 8px
    .shogi-player
      margin-top: 1.25em
      .font_size_base
        // モバイルのときに画面幅に合わせて盤面を大きくする
        +mobile
          font-size: 6.0vmin        // このサイズでぎりぎり升目が正方形を保ったまま最大幅になる
          // table
          //   width: inherit      // 升目が正方形になるように戻す

      .current_place
        border: 0.1em solid darken($orange, 0)
      .piece_back
        &:hover
          background-color: hsl(0, 0%, 92%)
      .board_inner
        border: 1px solid darken($board_color, 0%)
        background-color: $board_color
        // 星
        tr:nth-child(3n+4)
          td:nth-child(3n+4)
            &:after
              background: darken($board_color, 20%)

  .xy_scope_info_field
    +mobile
      justify-content: center
  .time_container
    margin-top: 0.3rem
  .tweet_box_container
    margin-top: 0.75rem
  .summary
    white-space: pre-wrap
  .tweet_button_container
    margin-top: 0.75rem
  .chart_box_container
    margin-top: 4rem
  #chart_canvas
    margin: 0 auto
  .navbar-item
    .avatar_image
      img
        max-height: none
        width: 32px
        height: 32px

  &.run, &.ready
    &.kb_mode
      .shogi-player
        margin-top: 3rem
</style>
