// 本譜共有機能

import { GX } from "@/components/models/gs.js"

export const mod_honpu_share = {
  methods: {
    honpu_share() {
      this.tl_add("HONPU", "本譜の配布", this.honpu_share_data)
      if (this.honpu_main) {
        this.ac_room_perform("honpu_share", this.honpu_share_data) // --> app/channels/share_board/room_channel.rb
      }
    },
    honpu_share_broadcasted(params) {
      this.tl_add("HONPU", "本譜の受信", params)
      if (this.received_from_self(params)) {
      } else {
        // 相手側で本譜とする
        this.honpu_share_data_receive(params)
      }
    },
    honpu_share_data_receive(params) {
      if (params.honpu_main) {
        this.honpu_main = this.al_create(params.honpu_main)
      } else {
        this.honpu_main = null
      }
      if (params.honpu_branch) {
        this.honpu_branch = this.al_create(params.honpu_branch)
      } else {
        this.honpu_branch = null
      }
    },
  },
  computed: {
    honpu_share_data() {
      return {
        __nil_check_skip_keys__: ["honpu_main", "honpu_branch"],
        honpu_main: this.honpu_main,
        honpu_branch: this.honpu_branch,
      }
    },
  },
}
