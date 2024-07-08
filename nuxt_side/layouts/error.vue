<template lang="pug">
// 原因はさっぱりわからんけど client-only をつけないと下のエラーが出る
// [Vue warn]: The client-side rendered virtual DOM tree is not matching server-rendered content. This is likely caused by incorrect HTML markup, for example nesting block-level elements inside <p>, or missing <tbody>. Bailing hydration and performing full client-side render.
client-only
  .error.has-background-primary
    nuxt-link(to="/" @click.native="$sound.play_click()")
      b-icon(icon="chevron-left" size="is-large")

    .section.px-4.py-4
      .container
        .box.has-text-centered
          template(v-if="message")
            p(v-html="message")

          b-button.mt-4(type="is-primary is-outlined" @click="nuxt_login_modal_handle" v-if="!g_current_user && error_status_code === 403")
            | ログイン
          b-button.mt-4(type="is-primary is-outlined" @click="reload_handle" v-if="error_status_code === 500")
            | ブラウザをリロードする
        XemojiWrap.has-text-centered.is-unselectable.is-block(:str="charactor")
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
        title: this.message_default,
        short_title: true,
      }
    },

    error_status_code() {
      return this.error?.statusCode
    },

    message() {
      return this.error?.message || message_default
    },

    message_default() {
      if (this.error) {
        if (this.error.statusCode) {
          if (false) {
          // } else if (this.error.statusCode === 401) {
          //   return `BASIC認証を促されています`
          } else if (this.error.statusCode === 404) {
            return `ページが見つからないか権限がありません`
          } else if (this.error.statusCode === 403) {
            return `権限がありません`
          } else if (this.error.statusCode === 400) {
            return `正しく処理できません`
          } else if (this.error.statusCode === 413) {
            // nginx の client_max_body_size の値が 10m なのに関係している
            return `ファイルサイズが大きすぎます。動画作成の場合は画像やBGMのサイズを合計で10MB以内にしてみてください`
          } else if (this.error.statusCode === 502) {
            return `メモリ不足でサーバーが死にました。10秒ほど待つと復活するかもしれません`
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

  +setvar(balloon-bg-color, white)
  +setvar(balloon-fg-color, transparent)

  display: flex
  flex-direction: column
  flex-wrap: wrap
  justify-content: center
  align-items: center

  .box
    border-radius: 8px
    background-color: var(--balloon-bg-color)
    border: 1px solid var(--balloon-fg-color)

  .XemojiWrap
    font-size: 80px
</style>
