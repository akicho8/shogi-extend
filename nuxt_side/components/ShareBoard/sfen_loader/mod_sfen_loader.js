import { Gs } from "@/components/models/gs.js"

export const mod_sfen_loader = {
  methods: {
    // sfen_loader_load() {
    //   const params = {
    //     room_key: this.room_key,
    //   }
    //   this.$axios.$get("/api/share_board/sfen_loader", {params: params, progress: false}).then(e => {
    //     if (e) {
    //       if (this.uniq_member_infos.length >= 2) {
    //         // すでに先輩からの情報を受け取っている可能性がある
    //       } else {
    //         // 自分しかいないので更新してよい
    //         this.current_sfen = e.sfen
    //         this.current_turn = e.turn
    //       }
    //     }
    //   })
    // },

    async sfen_loader_load() {
      if (this.sfen_loader_p) {
        const params = {
          room_key: this.room_key,
        }
        const e = await this.$axios.$get("/api/share_board/sfen_loader", {params: params, progress: false})
        if (e) {
          this.current_sfen = e.sfen
          this.current_turn = e.turn
        }
      }
    },
  },
}
