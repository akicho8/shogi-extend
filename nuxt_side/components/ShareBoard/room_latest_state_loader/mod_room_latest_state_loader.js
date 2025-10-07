import { Gs } from "@/components/models/gs.js"

export const mod_room_latest_state_loader = {
  methods: {
    // room_latest_state_loader_load() {
    //   const params = {
    //     room_key: this.room_key,
    //   }
    //   this.$axios.$get("/api/share_board/room_latest_state_loader", {params: params, progress: false}).then(e => {
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

    // async room_latest_state_loader_load() {
    //   this.tl_puts("--> room_latest_state_loader_load")
    //   const params = {
    //     room_key: this.room_key,
    //   }
    //   const e = await this.$axios.$get("/api/share_board/room_latest_state_loader", {params: params, progress: false})
    //   this.tl_alert("room_latest_state_loader_load response", e)
    //   if (e) {
    //     if (this.room_latest_state_loader_p) {
    //       this.current_sfen = e.sfen
    //       this.current_turn = e.turn
    //     }
    //   }
    //   this.tl_puts("<-- room_latest_state_loader_load")
    // },

    // ../../../../app/models/share_board/room.rb: as_json_for_room_latest_state_loader
    room_latest_state_loader_load(next_func = null) {
      this.tl_alert("--> room_latest_state_loader_load")
      const params = {
        room_key: this.room_key,
      }
      this.$axios.$get("/api/share_board/room_latest_state_loader", {params: params, progress: false}).then(e => {
        this.tl_alert("room_latest_state_loader_load then", e)
        if (e) {
          if (this.room_latest_state_loader_p) {
            if (e.latest_battle) {
              this.current_sfen = e.latest_battle.sfen
              this.current_turn = e.latest_battle.turn
              this.honpu_main_setup()
            }
          }
          this.current_title = e.room_name
          this.tl_puts(`this.current_title = "${e.room_name}"`)
        }
        if (next_func) {
          next_func()
        }
      })
      this.tl_alert("<-- room_latest_state_loader_load")
    },
  },
}
