import { GX } from "@/components/models/gx.js"
import { OriginMarkBehaviorInfo } from "./origin_mark_behavior_info.js"

export const mod_origin_mark_support = {
  methods: {
    // 自分は受信できる？
    i_can_origin_mark_receive_p(params) {
      return this.origin_mark_behavior_info._if(this, params)
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 全部消す
    // ・単にローカルで全体を消すだけ
    origin_mark_clear_all() {
      this.sp_call(e => e.mut_origin_mark_list.clear$())
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    OriginMarkBehaviorInfo()   { return OriginMarkBehaviorInfo                                    },
    origin_mark_behavior_info() { return this.OriginMarkBehaviorInfo.fetch(this.origin_mark_behavior_key) },
  },
}
