import ProbeShowModal from "./ProbeShowModal.vue"

export const app_probe_show = {
  methods: {
    media_info_show_handle(record) {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: ProbeShowModal,
        props: {
          base: this.base,
          record: record,
        },
      })
    },
  },
}
