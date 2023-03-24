<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title.is-flex.is-align-items-center
      template(v-if="TheSb.message_scope_info.title_emoji")
        XemojiWrap.be_quiet_icon(:str="TheSb.message_scope_info.title_emoji")
      template(v-else)
        | チャット
    b-button.test_button(type="is-small" @click="TheSb.ml_test" v-if="development_p") 追加
    b-field(v-if="TheSb.message_scope_dropdown_show_p")
      b-dropdown(animation="" position="is-bottom-left" v-model="TheSb.message_scope_key" @active-change="e => e && $sound.play_click()" @change="change_handle")
        template(#trigger)
          b-button.message_scope_dropdown(icon-right="dots-vertical" size="is-small")
        template(v-for="e in TheSb.MessageScopeInfo.values")
          b-dropdown-item(:key="e.key" :class="e.key" :value="e.key" v-text="e.name")
  .modal-card-body
    SbMessageLog(ref="SbMessageLog")
    b-field
      b-input(v-model="TheSb.message_body" ref="message_input_tag" @keydown.native.enter="enter_handle")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.send_handle(:class="TheSb.message_scope_info.class" :key="TheSb.message_scope_info.key" @click="send_handle" :icon-left="TheSb.message_scope_info.icon" :type="TheSb.message_scope_info.type") {{TheSb.message_scope_info.label}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "MessageSendModal",
  mixins: [support_child],
  inject: ["TheSb"],
  mounted() {
    this.input_focus()

    // 本当は SbMessageLog.vue の mounted で実行したかったが
    // まだコンポーネントが表示されてないので効かなかった
    // おそらく modal が表示されるまでに1フレームぐらいかかってるっぽい
    this.TheSb.ml_scroll_to_bottom()
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    change_handle(key) {
      this.$sound.play_click()
      this.talk2(this.TheSb.MessageScopeInfo.fetch(key).name)
    },
    enter_handle(e) {
      if (this.keyboard_enter_p(e)) {
        this.send_handle()
      }
    },
    send_handle() {
      if (this.blank_p(this.TheSb.message_body)) {
        if (this.TheSb.AppConfig.CLOSE_IF_BLANK_MESSAGE_POST) {
          this.close_handle()
          return
        } else {
          this.$sound.play("x")
          this.TheSb.message_body = ""
          this.input_focus()
          return
        }
      }
      this.$sound.play_click()
      this.TheSb.message_share({message: this.TheSb.message_body})
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
.MessageSendModal
  +modal_width(32rem)

  .modal-card-body
    padding: 1.0rem
  .modal-card-foot
    .button
      min-width: 6rem
  .modal-card-title
    line-height: 1.0

  .be_quiet_icon
    height: 100%
    .xemoji
      height: 1.6em
      width: unset
</style>
