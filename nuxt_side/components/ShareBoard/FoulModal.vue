<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | {{reason}}で{{current_location.name}}の勝ち！
  .modal-card-body
    p ルールを守りましょう
    p 対戦相手が許可してくれた場合は「1手戻す」で指し直してエキシビジョンとしての対局を続行できます
    p 反則を受け入れる場合は投了しましょう
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
  data() {
    return {
      current_location: null, // モーダル発動時の先後
    }
  },
  created() {
    this.current_location = this.TheSb.current_location
  },
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
