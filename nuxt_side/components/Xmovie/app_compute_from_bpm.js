import ComputeFromBpmModal from "./ComputeFromBpmModal.vue"

export const app_compute_from_bpm = {
  mounted() {
    if (this.development_p && false) {
      this.$nextTick(() => this.compute_from_bpm_modal_handle())
    }
  },
  methods: {
    compute_from_bpm_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.modal_card_open({
        component: ComputeFromBpmModal,
        props: { base: this.base },
      })
    },
  },
}
