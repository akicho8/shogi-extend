<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 不整合
  .modal-card-body
    p {{bs_error.message_prefix}}
    p.is_line_break_on {{bs_error.message}}
    .box.is-shadowless.mb-0.error_message_pre.has-background-white-ter
      | {{bs_error.board}}
  .modal-card-foot.is-justify-content-end
    b-button.close_handle(@click="close_handle" type="is-primary") OK
</template>

<script>
export default {
  name: "BioshogiErrorModal",
  props: {
    bs_error: { type: Object, required: true, },
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.BioshogiErrorModal
  +modal_width(512px)
  .modal-card-body
    display: flex
    flex-direction: column
    gap: 1rem
</style>
