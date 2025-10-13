<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | ファイル情報
    .delete(@click="close_handle")
  .modal-card-body
    //- b-tabs(expanded type="is-boxed" v-model="list_tab_index" @input="sfx_click()")
    //-   b-tab-item(label="a")
    //-     template(v-if="record.ffprobe_info")
    //-       | {{$GX.pretty_inspect(record.ffprobe_info.pretty_format.streams[0])}}
    //-     template(v-else)
    //-       | ?
    //-   b-tab-item(label="b")
    //-     | あああああああああああああああああああああああ
    template(v-if="record.ffprobe_info")
      | {{$GX.pretty_inspect(record.ffprobe_info.pretty_format.streams[0])}}
    template(v-else)
      | ?

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    //- b-button.test_button(@click="test_handle" v-if="development_p") 追加
    //- b-button.submit_handle(@click="submit_handle" type="is-primary") 送信
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
      this.sfx_click()
      this.$emit("close")
    },
    // test_handle() {
    //   this.sfx_click()
    //   this.base.ml_add_test()
    // },
    // submit_handle() {
    //   if (this.$GX.present_p(this.base.message_body2)) {
    //     this.sfx_click()
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
@import "all_support.sass"
.ProbeShowModal
  .modal-card-body
    padding: 1.0rem 1.5rem
    white-space: pre-wrap
    word-break: break-all
</style>
