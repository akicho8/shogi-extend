import MemberInfoModal from "./MemberInfoModal.vue"

export const app_member_info_modal = {
  methods: {
    member_info_modal_handle(member_info) {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: MemberInfoModal,
        props: {
          member_info: member_info,
        },
      })
    },
  },
}
