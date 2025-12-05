import { GX } from "@/components/models/gx.js"
import _ from "lodash"

const SELF_VS_SELF_THEN_SKIP             = false // 自分vs自分のときは保存しない？
const SELF_VS_SELF_THEN_MEMBER_ZERO_SAVE = true  // 自分vs自分のときは対局者なしで保存する？
const SELF_VS_SELF_THEN_FORCE_LOSE       = true  // 自分vs自分のときは必ず自分は負けとして保存する？

export const mod_battle_archive = {
  methods: {
    // 棋譜保存。投了時に呼ぶ。
    battle_save_run() {
      this.battle_save_by_win_location(this.resign_win_location_key)
    },

    // 棋譜保存。win_location_key 側を勝ちとする
    async battle_save_by_win_location(win_location_key) {
      GX.assert(win_location_key)
      if (SELF_VS_SELF_THEN_SKIP) {
        if (this.self_vs_self_p) {
          this.debug_alert("自分vs自分のため棋譜保存しない")
          return
        }
      }
      const params = {
        room_key:         this.room_key,
        title:            this.current_title,
        sfen:             this.current_sfen,
        turn:             this.current_turn,
        memberships:      this.__battle_memberships(win_location_key),
        win_location_key: win_location_key,
      }
      // app/models/share_board/battle_create.rb
      const e = await this.$axios.$post("/api/share_board/battle_create.json", params, {progress: false})
      if (e.error) {
        this.toast_danger(e.error.message, {talk: false})
      }
    },

    __battle_memberships(win_location_key) {
      if (!this.order_enable_p) {
        return []
      }
      if (SELF_VS_SELF_THEN_FORCE_LOSE) {
        if (this.self_vs_self_p) {
          return []
        }
      }
      return this.vs_member_names_uniq_and_ordered.map(name => {
        const location = this.user_name_to_initial_location(name)
        return {
          user_name: name,
          location_key: location.key,
          judge_key: this.__battle_memberships_judge_key(location, win_location_key), // FIXME: ここってサーバー側でやればよくね？
        }
      })
    },

    // location 側の勝ち負けを返す
    // 自分vs自分の場合は必ず負けとする
    __battle_memberships_judge_key(location, win_location_key) {
      if (SELF_VS_SELF_THEN_FORCE_LOSE) {
        if (this.self_vs_self_p) {
          return "lose"
        }
      }
      return location.key === win_location_key ? "win" : "lose"
    }
  },
}
