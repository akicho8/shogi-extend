<template lang="pug">
.xy_game
  .columns
    .column
      .xy_game.has-text-centered
        template(v-if="mode === 'stop' || mode === 'goal'")
          .buttons.is-centered
            button.button.is-primary(@click="start_handle") スタート

            b-dropdown(v-model="rule_key").is-pulled-left
              button.button(slot="trigger")
                span {{current_rule.name}}
                b-icon(icon="menu-down")
              template(v-for="e in rule_list")
                b-dropdown-item(:value="e.key") {{e.name}}

        template(v-if="mode === 'running'")
          .buttons.is-centered
            div
              | {{current_rule.name}}
            button.button(@click="stop_handle") やめる
            button.button(@click="goal_handle") ゴール

        .level_wrap
          nav.level.is-mobile
            .level-item.has-text-centered
              div
                p.heading 正解
                p.title {{o_count}}
            .level-item.has-text-centered
              div
                p.heading まちがい
                p.title {{x_count}}

        .shogi-player.theme-simple.size-default
          .board_container.font_size_base
            .flippable
              .board_wrap
                .board_outer
                  table.board_inner
                    tr(v-for="y in board_size")
                      td(v-for="x in board_size")
                        .piece_back(:class="cell_class(x - 1, y - 1)")
                          .piece_fore
                            template(v-if="active_p(x - 1, y - 1)")
                              | {{piece}}

        .time.fixed_font.is-size-3
          | {{time_format}}

        template(v-if="mode === 'goal'")
          .box
            .summary
              | {{summary}}
            .buttons.is-centered
              a.button.is-info.is-rounded(:href="twitter_url" target="_blank")
                | &nbsp;
                b-icon(icon="twitter" size="is-small")
                | &nbsp;
                | ツイート

        article.message.is-primary
          .message-header
            p ルール
          .message-body.has-text-left
            ul
              li 駒のある場所の座標を数字2桁で入力していきます
              li {{o_count_max}}回正解するまでの時間を競います
    .column
      .box.is-shadowless
        b-tabs(v-model="rule_selected_index")
          template(v-for="rule_list1 in rule_list")
            b-tab-item(:label="rule_list1.name" :value="rule_list1.key")
              b-table(:data="rule_list1.xy_game_records" :paginated="true" :per-page="25" :row-class="(row, index) => row.id === (xy_game_record && xy_game_record.id) && 'is-selected'")
                template(slot-scope="props")
                  b-table-column(field="computed_rank" label="ランク" sortable)
                    | {{props.row.computed_rank}}
                  b-table-column(field="name" label="名前")
                    | {{props.row.name || '？'}}
                  b-table-column(field="spent_msec" label="タイム")
                    | {{time_format_from_msec(props.row.spent_msec)}}
                  b-table-column(field="created_at" label="日時")
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
      o_count: 0,
      x_count: 0,
      input_keys: null,
      timer_run: false,
      micro_seconds: null,
      piece: null,
      location: null,
      rule_key: null,
      handle_name: null,
      rule_selected_index: null,
      rule_list: this.$root.$options.rule_list,
      xy_game_record: null,
    }
  },

  created() {
    this.timer_setup()
  },

  watch: {
    handle_name() { this.data_save() },
    rule_key(v) {
      this.rule_selected_index = this.current_rule.code
      this.data_save()
    },
    rule_selected_index(v) {
      this.rule_key = this.rule_list[v].key
    },
  },

  methods: {
    data_restore_from_hash(hash) {
      this.rule_key = hash.rule_key || "xy_rule_1c"
      this.handle_name = hash.handle_name
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

      document.addEventListener("keypress", this.key_handle, false)
    },

    stop_handle() {
      this.mode = "stop"
      this.timer_stop()
    },

    goal_handle() {
      this.mode = "goal"
      this.timer_stop()

      const loading_instance = this.$loading.open()

      // const params = new URLSearchParams()
      // _.each([
      //   "summary",
      //   "rule_key",
      //   "o_count",
      //   "x_count",
      //   "micro_seconds",
      // ], e => {
      //   params.append(`xy_game_record[${e}]`, this.$data[e])
      //   // params.append(`xy_game_record[${e}]`, "a\nb")
      // })

      const params = ["summary", "rule_key", "o_count", "x_count", "spent_msec"].reduce((a, e) => ({...a, [e]: this[e]}), {})

      // _.each([
      //   "summary",
      //   "rule_key",
      //   "o_count",
      //   "x_count",
      //   "spent_msec",
      // ], e => {
      //   params[e] = this[e]
      // })

      // console.log(params)

      this.$http({
        method: "post",
        url: this.$root.$options.xhr_post_path,
        data: {xy_game_record: params},
      }).then((response) => {
        loading_instance.close()
        console.log(response.data)
        this.$toast.open({message: response.data.message})
        // this.tweet_image_url = response.data.tweet_image_url
        // this.debug_alert(this.tweet_image_url)

        this.rule_list = response.data.rule_list
        this.xy_game_record = response.data.xy_game_record

        this.$dialog.prompt({
          message: `${this.xy_game_record.computed_rank}位`,
          confirmText: "保存",
          cancelText: "キャンセル",
          inputAttrs: { type: 'text', value: this.handle_name, placeholder: "名前", },
          onConfirm: (value) => {
            this.handle_name = value
            const loading_instance = this.$loading.open()

            this.$http({
              method: "post",
              url: this.$root.$options.xhr_post_path,
              data: { xy_game_record: { id: this.xy_game_record.id, name: value, } },
            }).then((response) => {
              loading_instance.close()
              // console.log(response.data)
              // this.$toast.open({message: response.data.message})
              // this.tweet_image_url = response.data.tweet_image_url
              // this.debug_alert(this.tweet_image_url)

              this.rule_list = response.data.rule_list
              this.xy_game_record = response.data.xy_game_record

            }).catch((error) => {
              loading_instance.close()
              console.table([error.response])
              this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
            })

          },
        })

      }).catch((error) => {
        loading_instance.close()
        console.table([error.response])
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })

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

    rand(n) {
      return Math.floor(Math.random() * n)
    },

    time_format_from_msec(v) {
      return dayjs.unix(v).format("mm:ss.SSS")
    },

    time_default_format(v) {
      return dayjs(v).format("YYYY-MM-DD HH:mm")
    },
  },

  computed: {
    o_count_max() {
      return this.current_rule.o_count_max
    },

    current_rule() {
      return this.rule_list_hash[this.rule_key]
    },

    rule_list_hash() {
      return this.rule_list.reduce((a, e, i) => ({...a, [e.key]: {...e}}), {})
    },

    save_hash() {
      return {
        rule_key: this.rule_key,
        handle_name: this.handle_name,
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
      out += this.summary + "\n"
      out += window.location.href
      return out
    },

    summary() {
      let out = ""
      out += `ルール:${this.current_rule.name}\n`
      if (this.xy_game_record) {
        out += `ランク:${this.xy_game_record.computed_rank}位\n`
      }
      out += `タイム:${this.time_format}\n`
      out += `まちがい:${this.x_count}\n`
      out += `正解率:${this.rate_per}%\n`
      return out
    },

    rate_per() {
      return Math.floor(this.rate * 100.0)
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
  .level_wrap
    width: 320px
    margin: 0 auto
  .summary
    white-space: pre-wrap
</style>
