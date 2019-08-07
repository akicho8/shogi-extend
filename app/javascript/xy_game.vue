<template lang="pug">
.xy_game
  .columns
    .column.is-8
      .has-text-centered
        .buttons.is-centered
          template(v-if="mode === 'stop' || mode === 'goal'")
            button.button.is-primary(@click="start_handle") スタート
          template(v-if="mode === 'running'")
            button.button(@click="stop_handle") リタイア

          b-dropdown.is-pulled-left(v-model="xy_rule_key" :disabled="mode === 'running'")
            button.button(slot="trigger")
              span {{current_rule.name}}
              b-icon(icon="menu-down")
            template(v-for="e in rule_list")
              b-dropdown-item(:value="e.key") {{e.name}}

          template(v-if="development_p")
            template(v-if="mode === 'running'")
              button.button(@click="goal_handle") ゴール
            button.button(@click="command_send('ranking_reset', {a: 1})") ランキングリセット

        .level_container
          nav.level.is-mobile
            .level-item.has-text-centered
              div
                p.heading 正解
                p.title {{o_count}}
            .level-item.has-text-centered
              div
                p.heading まちがい
                p.title {{x_count}}

        .field_conainer
          .shogi-player.theme-simple.size-default
            .board_container.font_size_base
              .flippable
                .board_wrap
                  .board_outer
                    table.board_inner
                      tr(v-for="y in board_size")
                        td(v-for="x in board_size")
                          .piece_back
                            .piece_fore(:class="cell_class(x - 1, y - 1)")
                              template(v-if="active_p(x - 1, y - 1)")
                                | {{piece}}
          .input_keys2
            | {{input_keys}}

        .time_container
          .fixed_font.is-size-2
            | {{time_format}}

        template(v-if="mode === 'goal'")
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

        .rule_container
          article.message.is-primary
            .message-header
              p ルール
            .message-body.has-text-left
              ul
                li 駒のある場所の座標をキーボードの数字2桁で入力していきます
                li {{o_count_max}}回正解するまでの時間を競います
    .column
      .box2.is-shadowless
        b-tabs(v-model="rule_selected_index" expanded)
          template(v-for="rule_one in rule_list")
            b-tab-item(:label="rule_one.name" :value="rule_one.key")
              b-table(:data="rule_one.xy_records" :paginated="true" :per-page="25" :pagination-simple="true" :mobile-cards="false" :row-class="(row, index) => row.id === (xy_record && xy_record.id) && 'is-selected'")
                template(slot-scope="props")
                  b-table-column(field="rank" label="順位" sortable centered :width="1")
                    | {{props.row.rank}}
                  b-table-column(field="entry_name" label="名前" sortable)
                    | {{props.row.entry_name || '？'}}
                  b-table-column(field="spent_msec" label="タイム" sortable)
                    | {{time_format_from_msec(props.row.spent_msec)}}
                  b-table-column(field="created_at" label="日時" v-if="false")
                    | {{time_default_format(props.row.created_at)}}

  template(v-show="true")
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

export default {
  name: "xy_game",
  mixins: [
    stopwatch_data_retention,
    sound_cache,
  ],
  data() {
    return {
      board_size: 9,
      mode: "stop",
      current_x: null,
      current_y: null,
      o_count: 0,               // 正解数
      x_count: 0,               // 不正解数
      input_keys: null,
      timer_run: false,
      micro_seconds: null,
      piece: null,
      location: null,
      xy_rule_key: null,
      entry_name: null,                         // ランキングでの名前を保持しておく
      rule_selected_index: null,                // b-tabs 連動用
      rule_list: this.$root.$options.rule_list, // 複数のルールでそれぞれにランキング情報も入っている
      xy_record: null,                          // ゲームが終わたっときにランクなどが入っている
      xhr_put_path: null,
    }
  },

  created() {
    this.timer_setup()
  },

  watch: {
    entry_name() { this.data_save() },

    xy_rule_key(v) {
      this.rule_selected_index = this.current_rule.code
      this.data_save()
    },

    rule_selected_index(v) {
      this.xy_rule_key = this.rule_list[v].key
    },
  },

  methods: {
    data_restore_from_hash(hash) {
      this.xy_rule_key = hash.xy_rule_key
      if (!this.current_rule) {
        this.xy_rule_key = this.rule_list[0].key
      }

      this.entry_name = hash.entry_name
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

    start_handle() {
      this.timer_run = true
      this.micro_seconds = 0
      this.o_count = 0
      this.x_count = 0
      this.input_keys = []
      this.mode = "running"
      this.quest_next()
      this.sound_play("start")

      document.addEventListener("keypress", this.key_handle, false)
    },

    stop_handle() {
      this.mode = "stop"
      this.timer_stop()
    },

    goal_handle() {
      this.mode = "goal"
      this.timer_stop()

      this.http_command("post", this.$root.$options.xhr_post_path, {xy_record: this.post_params}, data => {
        this.rule_list = data.rule_list
        this.xy_record = data.xy_record
        this.xhr_put_path = data.xhr_put_path

        this.$dialog.prompt({
          message: `${this.xy_record.rank}位`,
          confirmText: "保存",
          cancelText: "キャンセル",
          inputAttrs: { type: 'text', value: this.entry_name, placeholder: "名前", },
          onConfirm: value => {
            this.entry_name = value
            this.entry_name_save()
          },
        })
      })
    },

    entry_name_save() {
      this.http_command("put", this.xhr_put_path, {xy_record: { id: this.xy_record.id, entry_name: this.entry_name}}, data => {
        this.rule_list = data.rule_list
        this.xy_record = data.xy_record
      })
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
      this.input_keys.push(e.key)
      if (this.input_keys.length >= 2) {
        const x = parseInt(this.input_keys.shift())
        const y = parseInt(this.input_keys.shift())
        if (this.active_p(this.board_size - x, y - 1)) {
          this.o_count++
          this.sound_play("o")
        } else {
          this.sound_play("x")
          this.x_count++
        }
        this.quest_next()
      }
    },

    quest_next() {
      if (this.count_rest <= 0) {
        this.goal_handle()
        return
      }

      this.current_x = this.place_random()
      this.current_y = this.place_random()
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

    active_p(x, y) {
      return this.current_x === x && this.current_y === y
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
      return dayjs(v).format("YYYY-MM-DD HH:mm")
    },
  },

  computed: {
    post_params() {
      return [
        "xy_rule_key",
        "spent_msec",
        "x_count",              // なくてもよい
        "summary",              // なくてもよい
      ].reduce((a, e) => ({...a, [e]: this[e]}), {})
    },

    o_count_max() {
      return this.current_rule.o_count_max
    },

    current_rule() {
      return this.rule_list_hash[this.xy_rule_key]
    },

    rule_list_hash() {
      return this.rule_list.reduce((a, e, i) => ({...a, [e.key]: {...e}}), {})
    },

    save_hash() {
      return {
        xy_rule_key: this.xy_rule_key,
        entry_name: this.entry_name,
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

    summary() {
      let out = ""
      out += `ルール: ${this.current_rule.name}\n`
      if (this.xy_record) {
        out += `順位: ${this.xy_record.rank}位\n`
      }
      out += `タイム: ${this.time_format}\n`
      out += `まちがえた数: ${this.x_count}\n`
      out += `正解率: ${this.rate_per}%\n`
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
      return this.time_format_from_msec(this.spent_msec)
    },

    spent_msec() {
      return this.micro_seconds / 1000
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
    .input_keys2
      top: 0
      left: 0

  .time_container
    margin-top: 0rem
  .rule_container
    margin-top: 0.5rem
  .summary
    white-space: pre-wrap
  .tweet_button_container
    margin-top: 0.5rem
</style>
