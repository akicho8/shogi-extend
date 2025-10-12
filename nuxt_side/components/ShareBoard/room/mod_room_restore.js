import { Gs } from "@/components/models/gs.js"

export const mod_room_restore = {
  methods: {
    // ../../../../app/models/share_board/room.rb: as_json_for_room_restore
    async room_restore_call() {
      this.tl_puts("--> room_restore_call")
      if (this.room_restore_feature_p) {
        const params = {
          room_key: this.room_key,
        }
        this.tl_puts("room_restore_call: 1")
        const e = await this.$axios.$get("/api/share_board/room_restore", {params: params, progress: true})
        this.tl_puts("room_restore_call: 2")
        this.tl_puts("room_restore_call then", e)
        await this.sleep(this.room_restore_sleep)
        this.tl_puts("room_restore_call: 3")
        if (e) {
          if (this.room_restore_update_p) {
            this.tl_puts("room_restore_call: run")
            if (e.latest_battle) {
              this.tl_puts("room_restore_call: sfen set")
              this.current_sfen = e.latest_battle.sfen
              this.current_turn = e.latest_battle.turn
              this.honpu_main_setup()
            }
            this.tl_puts("room_restore_call: title set")
            this.current_title = e.room_name
            this.tl_puts(`this.current_title = "${e.room_name}"`)
          }
        }
        this.tl_puts("room_restore_call: 4")
      }
      this.tl_puts("<-- room_restore_call")
    },
  },
}
