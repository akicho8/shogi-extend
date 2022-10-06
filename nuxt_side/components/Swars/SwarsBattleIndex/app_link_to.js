import _ from "lodash"
import dayjs from "dayjs"
import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export const app_link_to = {
  methods: {
    show_handle(row) {
      this.$sound.play_click()
      const params = {}
      params.viewpoint = row.memberships[0].location_key
      if (this.layout_info.key === "is_layout_board") {
        params.scene_key = this.scene_info.key
      }
      this.$router.push({name: "swars-battles-key", params: { key: row.key }, query: params})
    },

    piyo_shogi_app_with_params_url(record) {
      return this.piyo_shogi_auto_url({
        path: record.show_path,
        sfen: record.sfen_body,
        turn: this.scene_info.sp_turn_of(record),
        viewpoint: record.viewpoint,
        ...record.piyo_shogi_base_params,
      })
    },

    kento_app_with_params_url(record) {
      return this.$KifuVo.create({
        sfen: record.sfen_body,
        turn: this.scene_info.sp_turn_of(record),
        viewpoint: record.viewpoint,
      }).kento_full_url
    },
  },
}
