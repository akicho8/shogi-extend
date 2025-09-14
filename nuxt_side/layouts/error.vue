<template lang="pug">
// 結局 client-only にしておけば変な切り替わり方をしない
// SSR でこのビューはまったく必要ない
client-only
  .error.has-background-primary
    .px-4.py-4
      .columns.is-mobile.is-marginless.is-multiline.is-gapless
        .column.is-12
          nuxt-link(to="/" @click.native="$sound.play_click()")
            b-icon(icon="chevron-left" size="is-large")
        .column.is-12
          .main_column.is_line_break_on
            .box
              p(v-html="message" v-if="message")
            .charactor(v-if="charactor")
              XemojiWrap.is-unselectable(:str="charactor")
            a(@click="nuxt_login_modal_handle" v-if="!g_current_user && status_code === 403") ログインする
            a(@click="reload_handle" v-if="status_code === 500") ブラウザをリロードする
        .column.is-12
          //- (:open="!!error_for_show")
          details
            summary(@click.naive="error_show_toggle_handle") 詳細
            //- ↓エラーになるかもしれない
            pre {{error_for_show}}
        .column.is-12(v-if="development_p")
          DebugPre
            | g_current_user: {{g_current_user}}
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import { ResponseStatusCodeInfo } from "@/components/models/response_status_code_info.js"

export default {
  name: "error",
  props: {
    // error({foo: 1}) として呼べば error.foo が入っている
    error: { type: Object, required: false, default: null, },
  },

  data() {
    return {
      charactor: null,
      error_for_show: null,
      is_online: true,
    }
  },

  beforeMount() {
    this.charactor = this.charactor_sample() // ここで設定すれば CSR だけで呼ばれるためキャラクタが途中で切り替わらない ← 結局 client-only をつけたので意味がなくなった。
  },

  mounted() {
    // ブラウザで読み込んだ状態でメンテナンス状態になってもクライアント側は通信するまでわからない
    // 何か操作したときにサーバーが503を返す
    // そこでメンテナンス画面に遷移するためトップをリロードする
    if (this.status_code === 503) {
      Gs.delay_block(3, () => { location.href = "/" })
    }

    // 最初から詳細をクリックする
    if (this.development_p && false) {
      this.error_show_toggle_handle(null)
    }

    this.is_online = navigator.onLine // ここで設定すれば絶対に navigator が無いで怒られる心配がない
  },

  methods: {
    charactor_sample() {
      return _.sample([..."🐰🐥🦉🐔🦔🐻🐹🐷🐮🐯🦁🐱🦊🐺🐶🐵🐸🐛🍄"])
    },
    reload_handle() {
      location.reload()
    },
    error_show_toggle_handle(pointer_event) {
      this.error_for_show = this.error // このタイミングで error_for_show を表示しようとして循環エラーになるかもしれない
    },
  },

  computed: {
    status_code() { return this.error?.statusCode },

    ResponseStatusCodeInfo()    { return ResponseStatusCodeInfo                                                                      },
    response_status_code_info() { return this.ResponseStatusCodeInfo.lookup_by_status_code(this.status_code)                         },

    english_message()       { return this.error?.message                                  }, // 英語の文言はわかりにくいので使わない
    primary_error_message() { return this.error?.__RESPONSE_DATA__?.primary_error_message }, // 最優先して表示したい文言
    default_message()       { return this.response_status_code_info?.message              }, // 代替文言

    // オフラインの場合
    offline_message() {
      if (!this.is_online) {
        return "インターネットが切れました" // ← 実際にはオフラインになっても is_online が真にならないため使えない
      }

      if (this.english_message === "Network Error") {
        return "たぶんインターネットに繋っていません"
      }
    },

    // 最終的に表示する文言
    message() {
      let str = null
      str ??= this.primary_error_message
      str ??= this.default_message
      str ??= this.offline_message
      str ??= "ぶっこわれました"
      return str
    },

    meta() {
      return {
        title: this.message,
        page_title_only: true,
      }
    },
  },
}
</script>

<style lang="sass">
.error
  +setvar(balloon-bg-color, white)
  +setvar(balloon-fg-color, transparent)

  min-height: 100vh

  a
    color: $white
    &:hover
      color: $white-ter

  .main_column
    display: flex
    align-items: center
    justify-content: center
    flex-direction: column
    gap: 0.75rem

    padding-top: 3rem
    padding-bottom: 3rem

    .box
      display: flex
      align-items: center
      justify-content: center
      flex-direction: column

      margin: auto
      border-radius: 8px
      background-color: var(--balloon-bg-color)
      border: 1px solid var(--balloon-fg-color)

    .charactor
      .XemojiWrap
        line-height: 1.0
        font-size: 80px

    a
      margin-top: 1.5rem
      font-size: $size-7

  details
    summary
      color: $grey-lighter
    pre
      background-color: $grey-darker
      color: $white-ter
      white-space: pre-wrap
      word-break: break-all

.STAGE-development
  .error
    .icon
      border: 1px dashed change_color($white, $alpha: 0.5)
    .section
      border: 1px dashed change_color($white, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($white, $alpha: 0.5)
    .column
      border: 1px dashed change_color($white, $alpha: 0.5)
</style>
