import MemberInfoModal from "./MemberInfoModal.vue"

export const mod_member_info_modal = {
  methods: {
    member_info_modal_open_handle(member_info) {
      this.sfx_click()
      this.modal_card_open({
        component: MemberInfoModal,
        props: {
          member_info: member_info,
        },
      })
    },
  },
}
