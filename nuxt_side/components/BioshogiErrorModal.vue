<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{bioshogi_error.modal_title}}
  .modal-card-body
    template(v-if="bioshogi_error.message_prefix")
      p {{bioshogi_error.message_prefix}}
    template(v-if="bioshogi_error.message")
      p.is_line_break_on {{bioshogi_error.message}}
    template(v-if="bioshogi_error.board")
      .box.is-shadowless.mb-0.error_message_pre.has-background-white-ter {{bioshogi_error.board}}
  .modal-card-foot.is-justify-content-end
    b-button.close_handle(@click="close_handle" type="is-primary") OK
</template>

<script>
export default {
  name: "BioshogiErrorModal",
  props: {
    bioshogi_error: { type: Object, required: true, },
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
