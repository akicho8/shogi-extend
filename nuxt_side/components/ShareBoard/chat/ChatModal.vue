<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title.is-flex.is-align-items-center
      template(v-if="SB.message_scope_info.title_emoji")
        XemojiWrap.be_quiet_icon(:str="SB.message_scope_info.title_emoji")
      template(v-else)
        | チャット
      template(v-if="development_p")
        span.mx-1.ml_count {{SB.ml_count}}
        span.mx-1.mh_page_index {{SB.mh_page_index}}
    template(v-if="development_p")
      b-button.mh_reload(       size="is-small" @click="SB.mh_reload"       ) よそ見から復帰
      b-button.mh_reset_all(    size="is-small" @click="SB.mh_reset_all"    ) 初期化
      b-button.mh_read(         size="is-small" @click="SB.mh_read"         ) 読込
      b-button.mh_head_observe( size="is-small" @click="SB.mh_head_observe" ) 監視
      b-button.ml_test(         size="is-small" @click="SB.ml_test"         ) 追加
    b-field(v-if="SB.message_scope_dropdown_show_p")
      b-dropdown(animation="" position="is-bottom-left" v-model="SB.message_scope_key" @active-change="e => e && sfx_click()" @change="change_handle")
        template(#trigger)
          b-button.message_scope_dropdown(icon-right="dots-vertical" size="is-small")
        template(v-for="e in SB.MessageScopeInfo.values")
          b-dropdown-item(:key="e.key" :class="e.key" :value="e.key" v-text="e.name")
  .modal-card-body
    .body_inner
      .SbMessageLogWrapper
        // p mh_flags={{SB.mh_flags}}
        // p mh_scroll_height={{SB.mh_scroll_height}}
        // p mh_seek_pos={{SB.mh_seek_pos}}
        SbMessageBox(ref="SbMessageBox")
      b-field.InputField
        b-input(v-model="SB.message_body" ref="message_input_tag" @keydown.native.enter="enter_handle")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.send_handle(:class="[SB.message_scope_info.class, SB.message_scope_info.key]" :key="SB.message_scope_info.key" @click="send_handle" :icon-left="SB.message_scope_info.icon" :type="SB.message_scope_info.type")
      // {{SB.message_scope_info.label}}
</template>

<script>
import { support_child } from "../support_child.js"
import { GX } from "@/components/models/gx.js"

export default {
  name: "ChatModal",
  mixins: [support_child],
  mounted() {
    // // 発言の最上位(一番古いもの)を監視する
    // this.SB.mh_start()

    this.input_focus()

    // 部屋に入っているなら古いログを取得する
    this.SB.mh_chat_open()

    // 本当は SbMessageBox.vue の mounted で実行したかったが
    // まだコンポーネントが表示されてないので効かなかった
    // おそらく modal が表示されるまでに1フレームぐらいかかってるっぽい
    if (!this.mh_enable) {
      this.$nextTick(() => this.SB.ml_scroll_to_bottom())
    }
  },
  beforeDestroy() {
    this.SB.mh_chat_close()
  },
  methods: {
    close_handle(e) {
      this.SB.chat_modal_close_handle(e)
    },
    change_handle(key) {
      this.sfx_click()
      this.SB.sb_talk(this.SB.MessageScopeInfo.fetch(key).name)
    },
    enter_handle(e) {
      // 空 + Enter で閉じる (ここは送信トリガーの方法とは関係なく Enter 固定とする)
      if (GX.blank_p(this.SB.message_body)) {
        this.SB.chat_modal_close()
        return
      }

      // 設定によって送信キーは変わる
      if (this.SB.send_trigger_p(e)) {
        this.send_handle()
      }
    },
    send_handle() {
      if (GX.blank_p(this.SB.message_body)) {
        if (this.SB.AppConfig.CHAT_BLANK_MESSAGE_POST_THEN_CLOSE) {
          this.SB.chat_modal_close()
          return
        } else {
          this.sfx_play("x")
          this.SB.message_body = ""
          this.input_focus()
          return
        }
      }
      this.sfx_click()
      this.SB.message_share({content: this.SB.message_body})
      this.SB.message_body = ""
      this.input_focus()
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.message_input_tag)
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.ChatModal
  +modal_width(32rem)

  .modal-card
    +mobile
      // height: 29rem
      @supports(height: 100svh)
        height: 75svh
      @supports not(height: 100svh)
        height: 75vh
    +tablet
      height: 30rem
    +desktop
      height: 31rem

    .modal-card-head
      .modal-card-title
        line-height: 1.0
    .modal-card-body
      padding: 1.0rem
      .body_inner
        width: 100%
        height: 100%

        display: flex
        align-items: center
        justify-content: center
        flex-direction: column
        gap: 1rem

        .SbMessageLogWrapper
          flex-grow: 1          // 残りの領域にめいっぱい広げる
          width: 100%
          position: relative
        .InputField
          width: 100%

    .modal-card-foot
      .button
        min-width: 6rem

  .be_quiet_icon
    height: 100%
    .xemoji
      height: 1.6em
      width: unset

// Windows ではデザインが崩れるため開発環境でのみ有効化する
.STAGE-development
  .ChatModal
    .modal-card
      overflow: scroll
      resize: both
</style>
