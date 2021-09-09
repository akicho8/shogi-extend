import ProbeShowModal from "./ProbeShowModal.vue"

export const app_probe_show = {
  methods: {
    __probe_show_modal_handle(record) {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        width: "",  // width ではなく max-width に設定される
        customClass: "ProbeShowModal",
        component: ProbeShowModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
          record: record,
        },
      })
    },
  },
}
