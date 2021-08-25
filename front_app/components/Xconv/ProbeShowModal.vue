<template lang="pug">
//- (style="width:auto")
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | ファイル情報

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    //- b-tabs(expanded type="is-boxed" v-model="list_tab_index" @input="sound_play('click')")
    //-   b-tab-item(label="a")
    //-     template(v-if="record.ffprobe_info")
    //-       | {{pretty_inspect(record.ffprobe_info.pretty_format.streams[0])}}
    //-     template(v-else)
    //-       | ?
    //-   b-tab-item(label="b")
    //-     | あああああああああああああああああああああああ
    template(v-if="record.ffprobe_info")
      | {{pretty_inspect(record.ffprobe_info.pretty_format.streams[0])}}
    template(v-else)
      | ?

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    //- b-button.test_button(@click="test_handle" v-if="development_p") 追加
    //- b-button.send_button(@click="send_handle" type="is-primary") 送信
</template>

<script>
import { support_child   } from "./support_child.js"

export default {
  name: "ProbeShowModal",
  mixins: [
    support_child,
  ],
  props: {
    record: { type: Object, required: true },
  },
  data() {
    return {
      //- list_tab_index: 0,
    }
  },

  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    // test_handle() {
    //   this.sound_play("click")
    //   this.base.ml_add_test()
    // },
    // send_handle() {
    //   if (this.present_p(this.base.message_body2)) {
    //     this.sound_play("click")
    //     this.base.message_share({message: this.base.message_body2})
    //     this.base.message_body2 = ""
    //     this.input_focus()
    //   }
    // },
    // input_focus() {
    //   this.desktop_focus_to(this.$refs.message_input_tag)
    // },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ProbeShowModal
  // スマホで閉じるボタンが押せない対策
  +mobile
    .animation-content
      max-width: 90vw
      .modal-card
        max-height: 70vh
        .modal-card-body
          font-size: $size-7

  // +tablet
  //   width: 100%
  .modal-card-body
    padding: 1.0rem 1.5rem
    // .field:not(:first-child)
    //   margin-top: 1.25rem
    white-space: pre-wrap
    word-break: break-all

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
