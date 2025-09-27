<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 使い方
    b-tooltip(position="is-left" label="パーマリンク")
      a.permalink(href="/video/new/help" target="_blank")
        b-icon(icon="link")
  .modal-card-body
    QuickScriptView(qs_group_key="chore" qs_page_key="documentation" :qs_override_params="{md_key: 'video_new', page_layout: 'pl_content_with_padding'}")
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewHelpModal",
  mixins: [
    support_child,
  ],
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "all_support.sass"
.KiwiLemonNewHelpModal
  +modal_max_width(800px)
  .modal-card-body
    padding: 0
</style>
