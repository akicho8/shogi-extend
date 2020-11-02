<template lang="pug">
client-only
  .error.has-background-primary
    nuxt-link(to="/" @click.native="sound_play('click')")
      b-icon(icon="chevron-left" size="is-large")

    .section.px-4.py-4
      .container
        .box.has-text-weight-bold.has-text-centered
          p {{default_message}}
          p(v-if="error.message")
            | {{error.message}}
        .emoji.has-text-centered.is-unselectable.is-clickable(@click="charactor_click")
          | {{charactor}}
    DebugPre
      | {{error}}
</template>

<script>
import _ from "lodash"

export default {
  name: "error",
  props: ["error"], // BUG: this.$nuxt.error({statusCode: 404, message: ""}) とすると引数がメッセージが含まれるようになる

  data() {
    return {
      charactor: this.charactor_sample(),
    }
  },

    meta() {
    return {
      title: this.charactor,
      short_title: true,
    }
  },

  methods: {
    charactor_click() {
      this.sound_play('click')
      this.talk(this.default_message)
    },
    charactor_sample() {
      return _.sample([..."🐰🐥🦉🐔🦔🐻🐹🐷🐮🐯🦁🐱🦊🐺🐶🐵🐸🐛🦋🥀🍀☘🍄"])
    },
  },

  computed: {
    default_message() {
      if (this.error.statusCode === 404) {
        return "ページが見つかりません"
      } else {
        return "ぶっこわれました"
      }
    },
  },
}
</script>

<style lang="sass">
.error
  a
    position: fixed
    top: 8px
    left: 8px
    color: $white

  min-height: 100vh

  --balloon-bg-color: white
  --balloon-fg-color: transparent

  display: flex
  flex-direction: column
  flex-wrap: wrap
  justify-content: center
  align-items: center

  .box
    border-radius: 25px
    background-color: var(--balloon-bg-color)
    border: 1px solid var(--balloon-fg-color)

  .emoji
    font-size: 80px
</style>
