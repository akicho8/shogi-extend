<template lang="pug">
.modal-card.ActbAnySourceReadModal
  header.modal-card-head
    p.modal-card-title.is-size-6 棋譜の読み込み
  section.modal-card-body
    b-input(type="textarea" v-model="any_source" ref="any_source")
  footer.modal-card-foot
    b-button(@click="submit_handle" type="is-primary") 読み込む
</template>

<script>
export default {
  name: "ActbAnySourceReadModal",
  data() {
    return {
      any_source: "",
    }
  },
  mounted() {
    this.desktop_focus_to(this.$refs.any_source.$refs.textarea)
  },
  methods: {
    submit_handle() {
      this.$emit("update:any_source", this.any_source)
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.ActbAnySourceReadModal
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
