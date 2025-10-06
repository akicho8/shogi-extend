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

    // async sfen_loader_load() {
    //   this.tl_puts("--> sfen_loader_load")
    //   const params = {
    //     room_key: this.room_key,
    //   }
    //   const e = await this.$axios.$get("/api/share_board/sfen_loader", {params: params, progress: false})
    //   this.tl_alert("sfen_loader_load response", e)
    //   if (e) {
    //     if (this.sfen_loader_p) {
    //       this.current_sfen = e.sfen
    //       this.current_turn = e.turn
    //     }
    //   }
    //   this.tl_puts("<-- sfen_loader_load")
    // },

    // ../../../../app/models/share_board/room.rb: as_json_for_sfen_loader
    sfen_loader_load(next_func = null) {
      // this.tl_puts("--> sfen_loader_load")
      const params = {
        room_key: this.room_key,
      }
      this.$axios.$get("/api/share_board/sfen_loader", {params: params, progress: false}).then(e => {
        this.tl_alert("sfen_loader_load then", e)
        if (e) {
          if (this.sfen_loader_p) {
            this.current_sfen = e.sfen
            this.current_turn = e.turn
          }
        }
        this.tl_alert("sfen_loader_load next_func call", next_func)
        if (next_func) {
          next_func()
        }
      })
      this.tl_puts("<-- sfen_loader_load")
    },
  },
}
