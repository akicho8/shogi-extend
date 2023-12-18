<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title.is-flex.is-align-items-center
      template(v-if="TheSb.message_scope_info.title_emoji")
        XemojiWrap.be_quiet_icon(:str="TheSb.message_scope_info.title_emoji")
      template(v-else)
        | チャット
      template(v-if="development_p")
        span.mx-1.ml_count {{TheSb.ml_count}}
        span.mx-1.mh_page_index {{TheSb.mh_page_index}}
    b-button.mh_reload(type="is-small" @click="TheSb.mh_reload" v-if="development_p") よそ見から復帰
    b-button.mh_reset_all(type="is-small" @click="TheSb.mh_reset_all" v-if="development_p") 初期化
    b-button.mh_read(type="is-small" @click="TheSb.mh_read" v-if="development_p") 読込{{TheSb.mh_seek_pos}}
    b-button.mh_head_observe(type="is-small" @click="TheSb.mh_head_observe" v-if="development_p") 監視
    b-button.test_button(type="is-small" @click="TheSb.ml_test" v-if="development_p") 追加
    b-field(v-if="TheSb.message_scope_dropdown_show_p")
      b-dropdown(animation="" position="is-bottom-left" v-model="TheSb.message_scope_key" @active-change="e => e && $sound.play_click()" @change="change_handle")
        template(#trigger)
          b-button.message_scope_dropdown(icon-right="dots-vertical" size="is-small")
        template(v-for="e in TheSb.MessageScopeInfo.values")
          b-dropdown-item(:key="e.key" :class="e.key" :value="e.key" v-text="e.name")
  .modal-card-body
    .body_inner
      .SbMessageLogWrapper
        // p mh_flags={{TheSb.mh_flags}}
        // p mh_scroll_height={{TheSb.mh_scroll_height}}
        // p mh_seek_pos={{TheSb.mh_seek_pos}}
        SbMessageList(ref="SbMessageList")
      b-field.InputField
        b-input(v-model="TheSb.message_body" ref="message_input_tag" @keydown.native.enter="enter_handle")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.send_handle(:class="TheSb.message_scope_info.class" :key="TheSb.message_scope_info.key" @click="send_handle" :icon-left="TheSb.message_scope_info.icon" :type="TheSb.message_scope_info.type") {{TheSb.message_scope_info.label}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "ChatModal",
  mixins: [support_child],
  inject: ["TheSb"],
  mounted() {
    // // 発言の最上位(一番古いもの)を監視する
    // this.TheSb.mh_start()

    this.input_focus()

    // 部屋に入っているなら古いログを取得する
    this.TheSb.mh_chat_open()

    // 本当は SbMessageList.vue の mounted で実行したかったが
    // まだコンポーネントが表示されてないので効かなかった
    // おそらく modal が表示されるまでに1フレームぐらいかかってるっぽい
    if (!this.mh_enable) {
      this.$nextTick(() => this.TheSb.ml_scroll_to_bottom())
    }
  },
  beforeDestroy() {
    this.TheSb.mh_chat_close()
  },
  methods: {
    close_handle() {
      this.TheSb.chat_modal_close_handle()
    },
    change_handle(key) {
      this.$sound.play_click()
      this.TheSb.talk2(this.TheSb.MessageScopeInfo.fetch(key).name)
    },
    enter_handle(e) {
      if (this.TheSb.send_trigger_p(e)) {
        this.send_handle()
      }
    },
    send_handle() {
      if (this.$gs.blank_p(this.TheSb.message_body)) {
        if (this.TheSb.AppConfig.CLOSE_IF_BLANK_MESSAGE_POST) {
          this.chat_modal_close()
          return
        } else {
          this.$sound.play("x")
          this.TheSb.message_body = ""
          this.input_focus()
          return
        }
      }
      this.$sound.play_click()
      this.TheSb.message_share({content: this.TheSb.message_body})
      this.TheSb.message_body = ""
      this.input_focus()
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.message_input_tag)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

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
