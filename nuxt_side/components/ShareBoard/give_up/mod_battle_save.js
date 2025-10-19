import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export const mod_battle_save = {
  methods: {
    // 棋譜保存。投了時に呼ばれる。
    battle_save_run() {
      this.battle_save_by_win_location(this.give_up_win_location_key)
    },

    battle_save_by_win_location(win_location_key) {
      GX.assert(win_location_key)
      const params = {
        room_key:         this.room_key,
        title:            this.current_title,
        sfen:             this.current_sfen,
        turn:             this.current_turn,
        memberships:      this.battle_memberships(win_location_key),
        win_location_key: win_location_key,
      }
      this.$axios.$post("/api/share_board/battle_create.json", params, {progress: false}).then(e => {
        if (e.error) {
          this.toast_ng(e.error.message, {talk: false})
        }
      })
    },

    // 出入りが激しいと名前が重複している状態があるためユニークにした this.room_user_names を使うこと
    battle_memberships(win_location_key) {
      // this.order_lookup_from_name
      // ↓ ここは flat_uniq_users でいい
      const filtered_names = this.room_user_names.filter(e => this.user_name_to_initial_turn(e) != null) // ← リファクタリングする
      const sorted_names = _.sortBy(filtered_names, e => this.user_name_to_initial_turn(e))
      return sorted_names.map(name => {
        const location = this.user_name_to_initial_location(name)
        return {
          user_name: name,
          location_key: location.key,
          judge_key: location.key === win_location_key ? "win" : "lose",
        }
      })
    },
  },
}
