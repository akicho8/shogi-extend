<template lang="pug">
.modal-card.TimeLimitModal(v-if="clock_running_p")
  header.modal-card-head
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 時間切れで{{clock.current.location.flip.name}}の勝ち！
  section.modal-card-body
    template(v-if="clock.current.time_recovery_mode_p")
      p 時間切れになっても時計は止まってないので合意の上で続行できます
    template(v-else)
      p 時間切れになっても合意の上で続行できますが、<b>秒読み</b>や<b>1手毎加算</b>の値がもともと0のため時間が回復しません
      p もし続行する場合は時計を再設定してください
  footer.modal-card-foot
    b-button(@click="close_handle" type="is-primary") 閉じる
</template>

<script>
export default {
  name: "TimeLimitModal",
  props: {
    base:  { type: Object, required: true, },
  },
  data() {
    return {
    }
  },
  mounted() {
    if (!this.clock_running_p) {
      this.debug_alert("対局時計は設定されていません")
    }
  },
  watch: {
    // 共有によって時計を止められたり消されたりしたら自動的に閉じる
    clock_running_p(v) {
      if (!v) {
        this.close_handle()
      }
    },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.base.time_limit_modal_close()
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
    },
  },
  computed: {
    clock()           { return this.base.clock_box              },
    clock_running_p() { return this.clock && this.clock.running_p },
  },
}
</script>

<style lang="sass">
.TimeLimitModal
  +tablet
    max-width: 25rem
  .modal-card-body
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
