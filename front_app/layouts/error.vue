<template lang="pug">
// 原因はさっぱりわからんけど client-only をつけないと下のエラーが出る
// [Vue warn]: The client-side rendered virtual DOM tree is not matching server-rendered content. This is likely caused by incorrect HTML markup, for example nesting block-level elements inside <p>, or missing <tbody>. Bailing hydration and performing full client-side render.
client-only
  .error.has-background-primary
    nuxt-link(to="/" @click.native="sound_play('click')")
      b-icon(icon="chevron-left" size="is-large")

    .section.px-4.py-4
      .container
        .box.has-text-centered
          p {{status_code_with_message}}
          p(v-if="error.message" v-html="error.message")
          b-button.mt-4(@click="login_handle" v-if="!g_current_user && error_status_code === 403") ログイン
        .emoji.has-text-centered.is-unselectable.is-clickable(@click="charactor_click")
          | {{charactor}}

    DebugPre
      | {{error}}
</template>

<script>
import _ from "lodash"

export default {
  name: "error",
  props: {
    error: { type: Object, required: false, default: {}, },
  },

  data() {
    return {
      charactor: this.charactor_sample(),
    }
  },

  mounted() {
    // this.sns_login_modal_handle()
  },

  methods: {
    login_handle() {
      this.sound_play("click")
      this.sns_login_modal_handle()
    },
    charactor_click() {
      if (process.client) {
        this.sound_play('click')
        this.talk(this.status_code_with_message)
      }
    },
    charactor_sample() {
      return _.sample([..."🐰🐥🦉🐔🦔🐻🐹🐷🐮🐯🦁🐱🦊🐺🐶🐵🐸🐛🦋🥀🍀☘🍄"])
    },
  },

  computed: {
    meta() {
      return {
        title: this.status_code_with_message,
        short_title: true,
      }
    },

    error_status_code() {
      return this.error?.statusCode
    },

    status_code_with_message() {
      if (this.error) {
        if (this.error.statusCode) {
          if (this.error.statusCode === 404) {
            return `${this.error.statusCode} Not Found`
          } else if (this.error.statusCode === 403) {
            return `${this.error.statusCode} Forbidden`
          } else {
            return `ぶっこわれました(${this.error.statusCode})`
          }
        } else {
          return "??? ステイタスコード不明"
        }
      } else {
        return "エラー情報不明"
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
    border-radius: 8px
    background-color: var(--balloon-bg-color)
    border: 1px solid var(--balloon-fg-color)

  .emoji
    font-size: 80px
</style>
