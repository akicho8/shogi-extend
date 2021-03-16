<template lang="pug">
.modal-card.TimeLimitModal(v-if="clock_running_p")
  header.modal-card-head
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 時間切れで{{clock.current.location.flip.name}}の勝ち
  section.modal-card-body
    template(v-if="clock.current.time_recovery_mode_p")
      | 時間切れになっても時計は止まっていないので合意の上で続行できます
    template(v-else)
      | 時間切れになっても合意の上で続行できます。
      | しかし今の設定は持ち時間しかないので時間が回復しません。
      | 続行する場合は時計を再設定するとよいでしょう
  footer.modal-card-foot
    b-button(@click="close_handle" type="is-primary") わかった
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
      this.$emit("close")
    },
    submit_handle() {
      this.close_handle()
    },
  },
  computed: {
    clock()           { return this.base.chess_clock              },
    clock_running_p() { return this.clock && this.clock.running_p },
  },
}
</script>

<style lang="sass">
.TimeLimitModal
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
