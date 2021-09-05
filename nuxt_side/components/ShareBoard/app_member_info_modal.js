import MemberInfoModal from "./MemberInfoModal.vue"

export const app_member_info_modal = {
  methods: {
    member_info_modal_handle(member_info) {
      this.sidebar_p = false
      this.sound_play("click")

      // https://buefy.org/documentation/modal/
      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "MemberInfoModal",
        component: MemberInfoModal,
        parent: this,
        props: { base: this.base, member_info: member_info },
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => this.sound_play("click"),
      })
    },
  },
}
