<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title.is-flex.is-align-items-center
      template(v-if="base.message_scope_info.title_icon")
        .be_quiet_icon(v-xemoji) {{base.message_scope_info.title_icon}}
      template(v-else)
        | チャット
    b-button.test_button(type="is-small" @click="test_handle" v-if="development_p") 追加

    //- b-button.ms_audience_toggle_button.xemoji_in_b_button(v-if="base.ms_audience_toggle_button_show_p" @click="send_handle({message_scope_key: 'is_ms_out'})" v-xemoji) 🤫

    b-field(v-if="base.order_func_p")
      //- p.control
      //-   b-button.send_handle(@click="send_handle" :icon-left="base.message_scope_info.icon" :type="base.message_scope_info.type" v-xemoji) {{base.message_scope_info.label}}
      b-dropdown(animation="" position="is-bottom-left" v-model="base.message_scope_key" @active-change="e => e && sound_play_click()" @change="change_handle")
        template(#trigger)
          b-button.message_scope_dropdown(icon-right="dots-vertical" size="is-small")
        template(v-for="e in base.MessageScopeInfo.values")
          b-dropdown-item(:key="e.key" :class="e.key" :value="e.key" v-text="e.name")

  .modal-card-body
    ShareBoardMessageLog(:base="base" ref="ShareBoardMessageLog")
    b-field
      b-input(v-model="base.message_body" ref="message_input_tag" @keydown.native.enter="enter_handle")
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left")

    //- b-tooltip(label="観戦者だけに送信" v-if="base.ms_out_send_handle_show_p")
    //-   b-button.ms_out_send_handle.xemoji_in_b_button(@click="send_handle({message_scope_key: 'is_ms_out'})" v-xemoji) 🤫
    //- b-button.send_handle(@click="send_handle()" type="is-primary") 送信

    //- b-field.dropdown_field
    //- p.control
    b-button.send_handle(:class="base.message_scope_info.class" :key="base.message_scope_info.key" @click="send_handle" :icon-left="base.message_scope_info.icon" :type="base.message_scope_info.type") {{base.message_scope_info.label}}
    //- p.control
    //-   b-dropdown(position="is-top-left" v-model="base.message_scope_key" @active-change="e => e && sound_play_click()" @change="change_handle")
    //-     template(#trigger)
    //-       b-button(:type="base.message_scope_info.type" icon-right="menu-up")
    //-     template(v-for="e in base.MessageScopeInfo.values")
    //-       b-dropdown-item(:value="e.key") {{e.name}}
</template>

<script>
import { support_child } from "./support_child.js"

const CLOSE_IF_BLANK_MESSAGE_POST = false // 空送信で閉じる

export default {
  name: "MessageSendModal",
  mixins: [support_child],
  mounted() {
    this.input_focus()

    // 本当は ShareBoardMessageLog.vue の mounted で実行したかったが
    // まだコンポーネントが表示されてないので効かなかった
    // おそらく modal が表示されるまでに1フレームぐらいかかってるっぽい
    this.base.ml_scroll_to_bottom()
  },
  methods: {
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
    test_handle() {
      this.sound_play_click()
      this.base.ml_add_test()
    },
    change_handle(key) {
      this.sound_play_click()
      this.talk(this.base.MessageScopeInfo.fetch(key).name)
    },
    enter_handle(e) {
      if (this.keyboard_enter_p(e)) {
        this.send_handle()
      }
    },
    send_handle() {
      if (this.blank_p(this.base.message_body)) {
        if (CLOSE_IF_BLANK_MESSAGE_POST) {
          this.close_handle()
          return
        } else {
          this.sound_play("x")
          this.base.message_body = ""
          this.input_focus()
          return
        }
      }
      this.sound_play_click()
      this.base.message_share({message: this.base.message_body, message_scope_key: this.base.message_scope_info.key})
      this.base.message_body = ""
      this.input_focus()
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.message_input_tag)
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.MessageSendModal
  +modal_width(24rem)
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
