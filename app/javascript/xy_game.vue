<template lang="pug">
.xy_game
  .columns
    .column
      .has-text-centered
        .buttons.is-centered
          template(v-if="mode === 'stop' || mode === 'goal'")
            button.button.is-primary(@click="readygo_handle") スタート
          template(v-if="mode === 'running' || mode === 'readygo'")
            b-button(@click="stop_handle" type="is-danger") やめる

          template(v-if="mode === 'stop' || mode === 'goal'")
            b-dropdown.is-pulled-left(v-model="xy_rule_key")
              button.button(slot="trigger")
                span {{selected_rule.name}}
                b-icon(icon="menu-down")
              template(v-for="e in rule_attrs_ary")
                b-dropdown-item(:value="e.key") {{e.name}}

          b-tooltip(label="ルール")
            b-button(@click="rule_display" icon-right="help")

          template(v-if="development_p")
            template(v-if="mode === 'running'")
              button.button(@click="goal_handle") ゴール
            button.button(@click="command_send('ranking_rebuild', {a: 1})") ランキングリビルド
            button.button(@click="data_restore_from_hash({})") 初期化
            button.button(@click="storage_clear") storage_clear
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
          template(v-if="mode === 'readygo'")
            .count_down_wrap
              .count_down
                | {{count_down}}
          .shogi-player.theme-simple.size-default
            .board_container.font_size_base
              .flippable
                .board_wrap
                  .board_outer
                    table.board_inner
                      tr(v-for="y in board_size")
                        td(v-for="x in board_size" :style="td_style(x - 1, y - 1)")
                          .piece_back
                            .piece_fore(:class="cell_class(x - 1, y - 1)")
                              template(v-if="active_p(x - 1, y - 1)")
                                template(v-if="mode === 'running'")
                                  | {{piece}}
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

    .column.is-4(v-if="mode === 'stop' || mode === 'goal'")
      b-tabs(v-model="selected_rule_index" expanded)
        template(v-for="rule_one in rule_attrs_ary")
          b-tab-item(:label="rule_one.name" :value="rule_one.key")
            b-table(
              :data="rule_one.xy_records"
              :paginated="true"
              :per-page="$root.$options.per_page"
              :current-page.sync="current_pages[selected_rule_index]"
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
                b-table-column(field="created_at" label="日付" sortable v-if="true")
                  | {{time_default_format(props.row.created_at)}}

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

class XyRuleInfo extends MemoryRecord {
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
      piece: null,
      location: null,
      xy_rule_key: null,
      entry_name: null,                                   // ランキングでの名前を保持しておく
      selected_rule_index: null,                          // b-tabs 連動用
      rule_attrs_ary: this.$root.$options.rule_attrs_ary, // 複数のルールでそれぞれにランキング情報も入っている
      xy_record: null,                                    // ゲームが終わたっときにランクなどが入っている
      xhr_put_path: null,
      current_pages: null,
      game_rule: null,
      danger_zone: {},
    }
  },

  beforeCreate() {
    XyRuleInfo.memory_record_reset(this.$root.$options.xy_rule_info)
  },

  created() {
    this.init_other_variables()
    this.timer_setup()
    document.addEventListener("keydown", this.key_handle, false)
  },

  watch: {
    entry_name() { this.data_save_to_local_storage() },
    current_pages: { handler() { this.data_save_to_local_storage() }, deep: true },

    xy_rule_key(v) {
      this.selected_rule_index = this.selected_rule.code
      this.data_save_to_local_storage()
    },

    selected_rule_index(v) {
      // このタブを始めて開いたときランキングの1ページ目に合わせる
      // this.current_pages[v] ||= 1 相当
      if (!this.current_pages[v]) {
        this.$set(this.current_pages, v, 1)
      }

      // タブインデックスからルールのキーを求めてプルダウンの方にも反映する
      const e = this.rule_attrs_ary[v]
      if (e) {
        this.xy_rule_key = e.key
      }
    },
  },

  methods: {
    rule_display() {
      this.talk_stop()

      const rule_dialog = this.$buefy.dialog.alert({
        title: "ルール",
        message: `
<div class="content is-size-7">
<ol>
<li>駒の場所をキーボードの数字2桁で入力していきます</li>
<li>${this.selected_rule.o_count_max}問正解するまでの時間を競います</li>
<li>最初の数字を間違えたときはESCキーでキャンセルできます</li>
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
${this.selected_rule.o_count_max}問正解するまでの時間を競います。
最初の数字を間違えたときはエスケープキーでキャンセルできます。
`, {rate: 2.0, onend: () => { rule_dialog.close() }})

    },

    data_restore_from_hash(hash) {
      this.xy_rule_key = hash.xy_rule_key
      if (!this.selected_rule) {
        this.xy_rule_key = this.rule_attrs_ary[0].key
      }

      this.entry_name = hash.entry_name || this.default_name
      this.current_pages = hash.current_pages || {}
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
      this.danger_zone = {}
      this.xy_record = null
    },

    readygo_handle() {
      this.mode = "readygo"
      this.count_down_counter = 0
      this.init_other_variables()
      this.game_rule = this.selected_rule
      this.talk_stop()

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

    goal_handle() {
      this.mode = "goal"
      this.timer_stop()
      this.talk("おわりました")

      this.http_command("post", this.$root.$options.xhr_post_path, {xy_record: this.post_params}, data => {
        this.data_update(data)
        this.xhr_put_path = data.xhr_put_path

        // ランク内ならランキングのページをそのページに移動する
        if (this.xy_record.rank <= this.$root.$options.rank_max) {
          this.$set(this.current_pages, this.selected_rule_index, this.xy_record.ranking_page)
        }

        this.$buefy.dialog.prompt({
          message: `${this.xy_record.rank}位`,
          confirmText: "保存",
          cancelText: "キャンセル",
          inputAttrs: { type: "text", value: this.entry_name, placeholder: "名前", },
          canCancel: false,
          onConfirm: value => {
            value = _.trim(value)
            if (value) {
              if (this.entry_name === value) {
                // 同じなので更新しない
                this.congrats_talk()
              } else {
                // 名前を変更したので更新する
                this.entry_name = value
                this.entry_name_save()
              }
            }
          },
          // onCancel: () => {
          //   if (this.entry_name) {
          //     this.entry_name_save()
          //   }
          // },
        })
      })
    },

    entry_name_save() {
      this.http_command("put", this.xhr_put_path, {xy_record: { id: this.xy_record.id, entry_name: this.entry_name}}, data => {
        this.data_update(data)
        this.congrats_talk()
      })
    },

    data_update(data) {
      const code = XyRuleInfo.fetch(data.xy_record.xy_rule_key).code
      this.$set(this.rule_attrs_ary[code], "xy_records", data.xy_records)
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
    },

    key_handle(e) {
      if (this.mode != "running") {
        return
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
          if (this.active_p(this.board_size - x, y - 1)) {
            this.sound_play("o")
            this.o_count++
            this.goal_check()
            if (this.mode === "running") {
              this.place_next_set()
            }
          } else {
            this.x_count++
            this.sound_play("x")
            this.danger_zone_plus()
          }
        }
        e.preventDefault()
        return
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

      if (true) {
        while (true) {
          this.current_place = {x: this.place_random(), y: this.place_random()}
          if ((this.o_count === 0 && (this.board_size - 1 - this.current_place.x) === this.current_place.y)) {
            continue
          }
          if (this.before_place) {
            if (_.isEqual(this.before_place, this.current_place)) {
              continue
            }
          }
          break
        }
      }

      if (false) {
        this.current_place = {x: this.place_random(), y: _.sample([5,6])}
      }

      this.piece = this.piece_sample()
      if (this.rand(2) === 0) {
        this.location = "black"
      } else {
        this.location = "white"
      }
    },

    cell_class(x, y) {
      let str = null
      if (this.active_p(x, y)) {
        str = ["current", `location_${this.location}`]
      }
      return str
    },

    td_style(x, y) {
      if (this.mode === 'goal') {
        const l_min = 50
        const key = this.xy_key(x, y)
        let count = this.danger_zone[key] || 0
        let v = 100 - (count * 3.0)
        if (v < l_min) {
          v = l_min
        }
        return { "background-color": `hsl(0, 100%, ${v}%)` }
      }
    },

    danger_zone_plus() {
      const key = this.xy_key(this.current_place.x, this.current_place.y)
      const count = this.danger_zone[key] || 0
      this.$set(this.danger_zone, key, count + 1)
    },

    xy_key(x, y) {
      return [x, y].join(",")
    },

    active_p(x, y) {
      if (this.current_place) {
        return _.isEqual(this.current_place, {x: x, y: y})
      }
    },

    place_random() {
      return this.rand(this.board_size)
    },

    piece_sample() {
      const chars = "玉飛龍角馬金銀全桂圭香杏歩と".split("")
      return chars[this.rand(chars.length)]
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
      out += `ルール: ${this.game_rule.name}\n`
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
      return this.game_rule.o_count_max
    },

    selected_rule() {
      return this.rule_attrs_ary[XyRuleInfo.fetch(this.xy_rule_key).code]
    },

    save_hash() {
      return {
        xy_rule_key: this.xy_rule_key,
        entry_name: this.entry_name,
        current_pages: this.current_pages,
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

    default_name() {
      if (js_global.current_user) {
        return js_global.current_user.name
      }
    },
  },
}
</script>

<style lang="sass">
.xy_game
  .level_container
    width: 10rem
    margin: 0 auto
  .field_conainer
    margin-top: 1rem
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

  .time_container
    margin-top: 0.1rem
  .tweet_box_container
    margin-top: 0.75rem
  .summary
    white-space: pre-wrap
  .tweet_button_container
    margin-top: 0.75rem
</style>
