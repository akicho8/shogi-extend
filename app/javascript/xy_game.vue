<template lang="pug">
.xy_game
  .columns
    .column
      .has-text-centered
        .buttons.is-centered
          template(v-if="mode === 'stop' || mode === 'goal'")
            button.button.is-primary(@click="standby_handle") スタート
          template(v-if="mode === 'running' || mode === 'standby'")
            b-button(@click="retry_handle" type="is-danger") やりなおす
            b-button(@click="stop_handle") やめる

          template(v-if="mode === 'stop' || mode === 'goal'")
            b-dropdown.is-pulled-left(v-model="xy_rule_key")
              button.button(slot="trigger")
                span {{current_rule.name}}
                b-icon(icon="menu-down")
              template(v-for="e in XyRuleInfo.values")
                b-dropdown-item(:value="e.key") {{e.name}}

            b-tooltip(label="盤のカスタマイズ")
              b-button(@click="sp_setting_handle" icon-right="settings")

            b-tooltip(label="使い方")
              b-button(@click="rule_display" icon-right="help")

            b-switch(v-model="bg_mode")
              b-tooltip(label="駒を並べてある状態で行う")
                | 駒配置

          template(v-if="development_p")
            template(v-if="mode === 'running'")
              button.button(@click="goal_handle") ゴール
            button.button(@click="command_send('ranking_rebuild', {a: 1})") ランキングリビルド
            button.button(@click="data_restore_from_hash({})") 初期化
            button.button(@click="storage_clear") storage_clear
            button.button(@click="persistense_variables_init") 保存可能な変数のリセット
            | {{current_pages}}

        .level_container
          nav.level.is-mobile
            .level-item.has-text-centered
              div
                p.heading
                  b-icon(pack="far" icon="circle" type="is-info" size="is-small")
                p.title {{o_count}}
            .level-item.has-text-centered
              div
                p.heading
                  b-icon(pack="fas" icon="times" type="is-danger" size="is-small")
                p.title {{x_count}}

        .field_conainer
          template(v-if="mode === 'standby'")
            .count_down_wrap
              .count_down
                | {{count_down}}

          .kanji_human_container(v-if="tap_mode")
            .human_digits.yumincho
              | {{kanji_human}}

          shogi_player(
            ref="api_sp"
            :kifu_body="kifu_body"
            :summary_show="false"
            :hidden_if_piece_stand_blank="true"
            :setting_button_show="false"
            :theme.sync="sp_theme"
            :bg_variant.sync="sp_bg_variant"
            :size.sync="sp_size"
            :flip="current_rule.flip"
            :piece_variant.sync="sp_piece_variant"
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
                  a.button.is-info.is-rounded(:href="twitter_url" target="_blank")
                    | &nbsp;
                    b-icon(icon="twitter" size="is-small")
                    | &nbsp;
                    | ツイート

    .column.is-4(v-if="(mode === 'stop' || mode === 'goal') && xy_records_hash")
      b-field
        template(v-for="e in XyScopeInfo.values")
          b-radio-button(v-model="xy_scope_key" :native-value="e.key")
            | {{e.name}}

      b-tabs(v-model="current_rule_index" expanded)
        template(v-for="xy_rule_info in XyRuleInfo.values")
          b-tab-item(:label="xy_rule_info.name" :value="xy_rule_info.key")
            b-table(
              :data="xy_records_hash[xy_rule_info.key]"
              :paginated="true"
              :per-page="$root.$options.per_page"
              :current-page.sync="current_pages[current_rule_index]"
              :pagination-simple="false"
              :mobile-cards="false"
              :row-class="(row, index) => row.id === (xy_record && xy_record.id) && 'is-selected'"
              :narrowed="true"
              default-sort-direction="desc"
              )
              template(slot-scope="props")
                b-table-column(field="rank" label="順位" sortable centered :width="1")
                  | {{props.row.rank}}
                b-table-column(field="entry_name" label="名前" sortable)
                  | {{props.row.entry_name || '？？？'}}
                b-table-column(field="spent_sec" label="タイム" sortable)
                  | {{time_format_from_msec(props.row.spent_sec)}}
                template(v-if="curent_scope.date_visible")
                  b-table-column(field="created_at" label="日付" sortable)
                    | {{time_default_format(props.row.created_at)}}

      b-switch(v-model="entry_name_unique")
        b-tooltip(label="名前ごとに絞る")
          | ユニーク

  template(v-if="development_p")
    .columns
      .column
        table(border=1)
          caption
            | props
          tr(v-for="(value, key) in $props")
            th(v-text="key")
            td(v-text="value")

        table(border=1)
          caption
            | data
          tr(v-for="(value, key) in $data")
            th(v-text="key")
            td(v-text="value")

        table(border=1)
          caption
            | computed
          tr(v-for="(e, key) in _computedWatchers")
            th(v-text="key")
            td(v-text="e.value")
</template>

<script>
import dayjs from "dayjs"
import stopwatch_data_retention from './stopwatch_data_retention.js'
import sound_cache from './sound_cache.js'
import MemoryRecord from 'js-memory-record'

import Soldier from "shogi-player/src/soldier.js"
import Place from "shogi-player/src/place.js"

class XyRuleInfo extends MemoryRecord {
}

class XyScopeInfo extends MemoryRecord {
}

export default {
  name: "xy_game",
  mixins: [
    stopwatch_data_retention,
    sound_cache,
  ],
  data() {
    return {
      // const
      board_size: 9,
      count_down_max: 3,
      count_down_speed: 1000 * 0.5,
      congrats_lteq: 10,

      mode: "stop",
      inteval_id: null,
      count_down_counter: null,
      sub_mode: null,
      before_place: null,
      current_place: null,
      o_count: null,               // 正解数
      x_count: null,               // 不正解数
      key_queue: null,
      timer_run: false,
      micro_seconds: null,
      xy_scope_key: null,
      entry_name_unique: false,
      xy_rule_key: null,
      entry_name: null,                                   // ランキングでの名前を保持しておく
      current_rule_index: null,                          // b-tabs 連動用
      xy_records_hash: null, // 複数のルールでそれぞれにランキング情報も入っている
      xy_record: null,                                    // ゲームが終わたっときにランクなどが入っている
      xhr_put_path: null,
      current_pages: null,
      saved_rule: null,

      sp_theme: null,
      sp_bg_variant: null,
      sp_size: null,
      sp_piece_variant: null,

      bg_mode: null,
      kifu_body: null,
    }
  },

  beforeCreate() {
    XyRuleInfo.memory_record_reset(this.$root.$options.xy_rule_info)
    XyScopeInfo.memory_record_reset(this.$root.$options.xy_scope_info)
  },

  created() {
    this.init_other_variables()
    this.timer_setup()
    document.addEventListener("keydown", this.key_handle, false)
  },

  mounted() {
  },

  watch: {
    entry_name()       { this.data_save_to_local_storage() },
    sp_theme()         { this.data_save_to_local_storage() },
    sp_bg_variant()    { this.data_save_to_local_storage() },
    sp_size()          { this.data_save_to_local_storage() },
    sp_piece_variant() { this.data_save_to_local_storage() },

    current_pages: { handler() { this.data_save_to_local_storage() }, deep: true },

    bg_mode(v) {
      if (v) {
        this.$refs.api_sp.mediator_setup(0)
      } else {
        this.$refs.api_sp.api_board_clear()
      }
      this.data_save_to_local_storage()
    },

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
    board_cell_left_click_user_handle(place, event) {
      if (this.tap_mode) {
        this.input_valid(place.x, place.y)
        return true
      }
    },

    board_piece_back_user_class(place) {
      if (!this.tap_mode) {
        if (this.mode === "running") {
          if (this.bg_mode) {
            if (this.current_place) {
              if (place.x === this.current_place.x && place.y === this.current_place.y) {
                return ["current_place"]
              }
            }
          }
        }
      }
    },

    xy_records_hash_update() {
      this.http_get_command(this.$root.$options.xhr_post_path, { xy_scope_key: this.xy_scope_key, entry_name_unique: this.entry_name_unique }, data => {
        this.xy_records_hash = data.xy_records_hash
      })
    },

    sp_setting_handle() {
      this.$refs.api_sp.setting_modal_p = true
    },

    rule_display() {
      this.talk_stop()

      // ${xxx} で埋め込める
      const rule_dialog = this.$buefy.dialog.alert({
        title: "ルール",
        message: `
<div class="content is-size-7">
<ol>
<li>駒の場所をキーボードの数字2桁で入力していきます</li>
<li>選択した数まで正解するまでの時間を競います</li>
<li>最初の数字を間違えたときはESCキーでキャンセルできます</li>
<li>ログインしていると毎回出る名前の入力を省略できます</li>
</ol>
</div>
`,
        confirmText: "わかった",
        canCancel: ["outside", "escape"],
        type: "is-info",
        hasIcon: true,
        onConfirm: () => { this.talk_stop() },
        onCancel:  () => { this.talk_stop() },
      })

      this.talk(`
駒の場所をキーボードの数字2桁で入力していきます。
選択した数まで正解するまでの時間を競います。
最初の数字を間違えたときはエスケープキーでキャンセルできます。
ログインしていると毎回出る名前の入力を省略できます。
`, {rate: 2.0, onend: () => { rule_dialog.close() }})

    },

    persistense_variables_init() {
      this.xy_rule_key      = null
      this.entry_name       = null
      this.current_pages    = null
      this.sp_theme         = null
      this.sp_bg_variant    = null
      this.sp_size          = null
      this.sp_piece_variant = null

      this.data_restore_from_hash({})
    },

    data_restore_from_hash(hash) {
      this.xy_rule_key = hash.xy_rule_key
      if (!XyRuleInfo.lookup(this.xy_rule_key)) {
        this.xy_rule_key = XyRuleInfo.fetch(0).key
      }

      this.xy_scope_key = hash.xy_scope_key
      if (!XyScopeInfo.lookup(this.xy_scope_key)) {
        this.xy_scope_key = XyScopeInfo.fetch(0).key
      }

      this.entry_name = hash.entry_name || this.fixed_handle_name
      this.current_pages = hash.current_pages || {}
      this.bg_mode = hash.bg_mode != null ? hash.bg_mode : false

      this.sp_theme = hash.sp_theme || "simple"
      this.sp_bg_variant = hash.sp_bg_variant || "a"
      this.sp_size = hash.sp_size || "default"
      this.sp_piece_variant = hash.sp_piece_variant || "a"
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

    standby_handle() {
      this.mode = "standby"
      this.count_down_counter = 0
      this.init_other_variables()
      this.saved_rule = this.current_rule
      this.talk_stop()
      this.$refs.api_sp.$store.state.current_flip = this.current_rule.flip // FIXME api化

      this.inteval_id = setInterval(() => {
        this.count_down_counter += 1
        if (this.count_down === 0) {
          this.countdown_interval_stop()
          this.go_handle()
        }
      }, this.count_down_speed)
    },

    countdown_interval_stop() {
      if (this.inteval_id) {
        clearInterval(this.inteval_id)
        this.inteval_id = null
      }
    },

    go_handle() {
      this.mode = "running"
      this.timer_run = true
      this.place_next_set()
      this.sound_play("start")
      this.goal_check()
    },

    stop_handle() {
      this.mode = "stop"
      this.timer_stop()
      this.countdown_interval_stop()
    },

    retry_handle() {
      this.stop_handle()
      this.standby_handle()
    },

    goal_handle() {
      this.mode = "goal"
      this.timer_stop()
      this.talk("おわりました")

      if (this.fixed_handle_name) {
        this.entry_name = this.fixed_handle_name
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

    record_post() {
      this.http_command("post", this.$root.$options.xhr_post_path, {xy_scope_key: this.xy_scope_key, entry_name_unique: this.entry_name_unique, xy_record: this.post_params}, data => {
        this.entry_name_unique = false
        this.data_update(data)
        this.xhr_put_path = data.xhr_put_path

        // ランク内ならランキングのページをそのページに移動する
        if (this.xy_record.rank <= this.$root.$options.rank_max) {
          this.$set(this.current_pages, this.current_rule_index, this.xy_record.ranking_page)
        }

        this.congrats_talk()
      })
    },

    data_update(data) {
      const xy_rule_info = XyRuleInfo.fetch(data.xy_record.xy_rule_key)
      this.$set(this.xy_records_hash, xy_rule_info.key, data.xy_records)
      this.xy_record = data.xy_record
    },

    congrats_talk() {
      let message = ""
      if (this.entry_name) {
        if (this.xy_record.rank <= this.congrats_lteq) {
          message += `おめでとうございます。`
        }
        message += `${this.entry_name}さんは${this.xy_record.rank}位です。`
        if (this.xy_record.rank > this.$root.$options.rank_max) {
          message += `ランキング外です。`
        }
        this.talk(message)
      }
    },

    command_send(command, args = {}) {
      this.http_command("post", this.$root.$options.xhr_post_path, { xy_record: { command: command, ...args } })
    },

    timer_stop() {
      this.timer_run = false
      if (!this.bg_mode) {
        this.$refs.api_sp.api_board_clear()
      }
    },

    key_handle(e) {
      if (this.mode != "running") {
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
          this.input_valid(this.board_size - x, y - 1)
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
        if (this.mode === "running") {
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
          if ((this.o_count === 0 && (this.board_size - 1 - p.x) === p.y)) {
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
        if (!this.bg_mode) {
          this.$refs.api_sp.api_board_clear()
          this.$refs.api_sp.api_place_on(soldier)
        }
      }

      this.current_place = p
    },

    active_p(x, y) {
      console.log(this.current_place)
      console.log(x, y)
      if (this.current_place) {
        return _.isEqual(this.current_place, {x: x, y: y})
      }
    },

    place_random() {
      return _.random(0, this.board_size - 1)
    },

    time_format_from_msec(v) {
      return dayjs.unix(v).format("mm:ss.SSS")
    },

    time_default_format(v) {
      return dayjs(v).format("YYYY-MM-DD")
    },
  },

  computed: {
    count_down() {
      return this.count_down_max - this.count_down_counter
    },

    summary() {
      let out = ""
      out += `ルール: ${this.saved_rule.name}\n`
      if (this.xy_record) {
        out += `順位: ${this.xy_record.rank}位\n`
      }
      out += `タイム: ${this.time_format}\n`
      if (this.time_avg) {
        out += `平均: ${this.time_avg}\n`
      }
      out += `まちがえた数: ${this.x_count}\n`
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
      return this.saved_rule.o_count_max
    },

    save_hash() {
      return {
        xy_scope_key: this.xy_scope_key,
        xy_rule_key: this.xy_rule_key,
        entry_name: this.entry_name,
        current_pages: this.current_pages,
        bg_mode: this.bg_mode,

        sp_theme: this.sp_theme,
        sp_bg_variant: this.sp_bg_variant,
        sp_size: this.sp_size,
        sp_piece_variant: this.sp_piece_variant,
      }
    },

    local_storage_key() {
      return "xy_game"
    },

    twitter_url() {
      return `https://twitter.com/intent/tweet?text=${encodeURIComponent(this.tweet_body)}`
    },

    tweet_body() {
      let out = ""
      out += "▼符号入力ゲームの結果\n"
      out += this.summary
      out += window.location.href.replace(window.location.hash, "")
      return out
    },

    rate_per() {
      return this.float_to_percentage(this.rate)
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

    fixed_handle_name() {
      if (this.global_current_user) {
        return this.global_current_user.name
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
      if (this.mode === "running") {
        if (this.current_place) {
          const place = Place.fetch([this.current_place.x, this.current_place.y])
          return place.kanji_human
        }
      }
      return "？？"
    },

    XyScopeInfo() { return XyScopeInfo },
    XyRuleInfo() { return XyRuleInfo },
  },
}
</script>

<style lang="sass">
@import "./my_custom_buefy.scss"

.xy_game
  .level_container
    width: 10rem
    margin: 0 auto
  .field_conainer
    margin-top: 0.7rem
    position: relative
    .count_down_wrap
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
      .count_down
        font-size: 24rem
        color: $primary
        -webkit-text-stroke: 4px white
    .kanji_human_container
      margin-top: 0rem
      .human_digits
        margin: 0 auto
        background-color: hsl(0, 0%, 95%)
        border-radius: 0.5rem
        padding: 0.2rem
        width: 5rem
        font-weight: bold
        font-size: 1.5rem
    .shogi-player
      margin-top: 1em
      .current_place
        border: 0.1em solid darken($orange, 0)

  .time_container
    margin-top: 0.1rem
  .tweet_box_container
    margin-top: 0.75rem
  .summary
    white-space: pre-wrap
  .tweet_button_container
    margin-top: 0.75rem
</style>
