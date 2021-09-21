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

      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "BasicModal ComputeFromBpmModal",
        component: ComputeFromBpmModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: ["outside", "escape"],
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },
  },
}
