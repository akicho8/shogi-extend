<template lang="pug">
.modal-card.TimeLimitModal
  header.modal-card-head
    p.modal-card-title.is-size-6.has-text-weight-bold 時間切れ
  section.modal-card-body
    ul
      template(v-if="clock")
        template(v-if="clock.running_p")
          template(v-if="clock.current.time_recovery_mode_p && false")
            li 時間切れになっても時計は止まっていないので手番の方は(合意の上で)駒を動かして続行できます
          template(v-else)
            li 時間切れになっても手番の方は(合意の上で)駒を動かして続行できます。しかし現在の対局時計の設定では時間が回復しません。続行する場合は対局時計を再スタートさせてください
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
    clock() { return this.base.chess_clock },
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
