<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{base.book.title}}
    .modal-card-title
      | {{base.book.user.name}}
  .modal-card-body
    .content
      p(v-html="$gs.simple_format($gs.auto_link(base.book.description))")
  .modal-card-foot
    b-button(type="is-primary" @click="submit_handle") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowDesc",
  mixins: [support_child],
  methods: {
    submit_handle() {
      this.sfx_stop_all()
      this.sfx_play_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.WkbkBookShowDesc
  .modal-card-foot
    justify-content: flex-end

.STAGE-development
  .WkbkBookShowDesc
    .content
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
