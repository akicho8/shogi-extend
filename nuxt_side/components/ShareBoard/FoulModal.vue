<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{reason}}で{{TheSb.current_location.name}}の勝ち！
  .modal-card-body
    p 「1手戻す」で指し直せます
    p(v-if="TheSb.give_up_button_show_p") 反則を受け入れる場合は投了しよう
  .modal-card-foot
    b-button(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
export default {
  name: "FoulModal",
  props: {
    foul_names: { type: Array,  required: true, },
  },
  inject: ["TheSb"],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.TheSb.foul_modal_close()
      this.$emit("close")
    },
  },
  computed: {
    reason() {
      return this.foul_names.join("と")
    },
  },
}
</script>

<style lang="sass">
.FoulModal
  +modal_max_width(25rem)
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
</style>
