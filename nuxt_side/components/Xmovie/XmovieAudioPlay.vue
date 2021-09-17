<template lang="pug">
b-button(
  :icon-left="current_icon"
  :type="current_type"
  @click.prevent.stop="click_handle"
  v-bind="$attrs"
  v-on="$listeners"
  )
</template>

<script>
import { support_child } from "./support_child.js"
import { Howl, Howler } from 'howler'

export default {
  name: "XmovieAudioPlay",
  mixins: [support_child],
  props: {
    src:              { type: String,  required: false, default: null, },
    play_duration:    { type: Number,  required: false, default: 17.5, },
    fadeout_duration: { type: Number,  required: false, default:  2.5, },
    volume:           { type: Number,  required: false, default:  0.4, },
  },
  data() {
    return {
      instance: null,
      state: "stop",
      fadeout_id: null,
      current_id: null,
    }
  },
  beforeDestroy() {
    this.delay_stop(this.fadeout_id)
    if (this.instance) {
      this.instance.unload()
    }
  },
  methods: {
    click_handle() {
      if (!this.src) {
        return
      }
      if (this.state === "stop") {
        if (this.instance === null) {
          // https://github.com/goldfire/howler.js#documentation
          this.instance = new Howl({
            src: this.src,
            volume: this.volume,
            html5: true, // 【超重要】これを入れないと failed 連発になる。入れると Content-Range の分割レスポンス対応になる(のを自分で確認しただけでドキュメントにそのような記載はない)
            // loop: true, // ループにすると stop フェイドアウトが効かなくなる
            onplay: () => {
              this.state = "play"
              this.__assert__(this.fadeout_id == null, "this.fadeout_id == null")
              this.fadeout_id = this.delay_block(this.play_duration, () => {
                // 面倒なことに現状のボリュームからではなく開始時のボリュームを指定しないといけない
                // なので 1.0 ではなく this.volume を指定する
                this.instance.fade(this.volume, 0, 1000 * this.fadeout_duration, this.current_id)
              })
            },
            onstop: () => this.auto_stop("stop"),
            onend:  () => this.auto_stop("end"),
            onfade: () => this.auto_stop("fade"),
          })
        }
        Howler.stop()
        this.current_id = this.instance.play()
        if (true) {
          // ここでフェイドアウト登録を行なってはいけない
          // ここで行うと、そのあとで Howler.stop() による onstop が呼ばれて
          // そこから fadeout_clear が実行されてフェイドアウトが解除されてしまう
          // ここで行うなら stop() は実行してはいけない
          // ただ他のところからも停止させられるので結局フェイドアウト登録は onplay で行うのがよさそう
        }
        this.$emit("play", this.instance)
      } else {
        this.instance.stop()
        this.state = "stop"
        this.fadeout_clear()
      }
    },
    auto_stop(event_name) {
      this.debug_alert(`auto_stop('${event_name}')`)
      this.state = "stop"
      this.fadeout_clear()
    },
    fadeout_clear() {
      if (this.fadeout_id) {
        this.delay_stop(this.fadeout_id)
        this.fadeout_id = null
      }
    },
  },
  computed: {
    current_icon() {
      if (!this.src) {
        return "blank"
      } else if (this.state === "play") {
        return "stop"
      } else {
        return "play"
      }
    },
    current_type() {
      if (!this.src) {
        return "is-ghost"
      }
    },
  },
}
</script>

<style lang="sass">
.XmovieAudioPlay
</style>
