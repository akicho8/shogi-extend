import WkbkBookShowDesc from "./WkbkBookShowDesc.vue"

export const app_support = {
  methods: {
    description_handle() {
      this.sound_play("click")
      this.talk(this.book.description)
      this.$buefy.modal.open({
        component: WkbkBookShowDesc,
        parent: this,
        props: { base: this.base },
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel:  () => {
          this.talk_stop()
          this.sound_play("click")
        },
      })
    },
  },
}
