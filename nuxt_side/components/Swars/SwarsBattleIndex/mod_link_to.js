import _ from "lodash"
import dayjs from "dayjs"
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export const mod_link_to = {
  methods: {
    // 未使用
    show_handle(row) {
      this.sfx_play_click()
      this.$router.push(this.show_route_params(row))
    },

    // nuxt-link(:to="APP.show_route_params(row)" @click.native="sfx_play_click()") \#{{row.id}}
    // として使う用だが、Vue や Nuxt を新しくした結果 @click.native が反応しなくなってしまった
    show_route_params(row) {
      const params = {}
      params.viewpoint = row.memberships[0].location_key
      if (this.layout_info.key === "is_layout_board") {
        params.scene_key = this.scene_info.key
      }
      return {name: "swars-battles-key", params: { key: row.key }, query: params}
    },

    kifu_vo(record) {
      return this.$KifuVo.create({
        kif_url: `${this.$config.MY_SITE_URL}${record.show_path}.kif`,
        sfen: record.sfen_body,
        turn: this.scene_info.sp_turn_of(record),
        viewpoint: record.viewpoint,
      })
    },
  },
}
