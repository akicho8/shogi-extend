<template lang="pug">
// 原因はさっぱりわからんけど client-only をつけないと下のエラーが出る
// [Vue warn]: The client-side rendered virtual DOM tree is not matching server-rendered content. This is likely caused by incorrect HTML markup, for example nesting block-level elements inside <p>, or missing <tbody>. Bailing hydration and performing full client-side render.
client-only
  .error.has-background-primary
    nuxt-link(to="/" @click.native="sound_play_click()")
      b-icon(icon="chevron-left" size="is-large")

    .section.px-4.py-4
      .container
        .box.has-text-centered
          p {{status_code_with_message}}
          p.has-text-left(v-if="error.message" v-html="error.message")
          b-button.mt-4(type="is-primary is-outlined" @click="sns_login_modal_handle" v-if="!g_current_user && error_status_code === 403")
            | ログイン
          b-button.mt-4(type="is-primary is-outlined" @click="reload_handle" v-if="error_status_code === 500")
            | ブラウザをリロードする
        .emoji.has-text-centered.is-unselectable(v-xemoji)
          | {{charactor}}
    DebugPre(v-if="development_p")
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
    // ブラウザで読み込んだ状態でメンテナンス状態になってもクライアント側は通信するまでわからない
    // 何か操作したときにサーバーが503を返す
    // そこでメンテナンス画面に遷移するためトップをリロードする
    if (this.error_status_code === 503) {
      location.href = "/"
    }
  },

  methods: {
    charactor_sample() {
      return _.sample([..."🐰🐥🦉🐔🦔🐻🐹🐷🐮🐯🦁🐱🦊🐺🐶🐵🐸🐛🦋🥀🍀☘🍄"])
    },
    reload_handle() {
      location.reload()
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
            return `ページが見つからないか権限がありません`
          } else if (this.error.statusCode === 403) {
            return `権限がありません`
          } else if (this.error.statusCode === 400) {
            return `正しく処理できません`
          } else if (this.error.statusCode === 503) {
            return ""
          } else {
            return `ぶっこわれました`
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
