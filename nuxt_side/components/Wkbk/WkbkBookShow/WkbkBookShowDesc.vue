<template lang="pug">
.modal-card.WkbkBookShowDesc
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.is-flex-grow-0
      | {{base.book.title}}
    p.modal-card-title.is-size-6.is-flex-grow-0
      | {{base.book.user.name}}
  section.modal-card-body
    .content
      p(v-html="simple_format(auto_link(base.book.description))")
  footer.modal-card-foot
    b-button(type="is-primary" @click="submit_handle") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowDesc",
  mixins: [support_child],
  methods: {
    submit_handle() {
      this.sound_stop_all()
      this.sound_play("click")
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.STAGE-development
  .WkbkBookShowDesc
    .content
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookShowDesc
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
      min-width: 4rem
</style>
