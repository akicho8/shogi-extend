import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"
import dayjs from "dayjs"

export const mod_storage = {
  mixins: [params_controller],
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },
  methods: {
    // localStorage → URL引数 を順に反映したあとで呼ばれるところ
    pc_mounted() {
      this.$debug.trace("mod_storage", "pc_mounted")
      // b-datepicker に渡すデータは Date 型でないとだめなので最後に変換しておく
      this.clog(this.battled_at_range)
      this.battled_at_range = this.battled_at_range.map(e => dayjs(e).toDate())
      this.clog(this.battled_at_range)
    },
  },

  computed: {
    // 「カスタム検索」と「絞り込み」で共通化するため
    // これを取ると個別の値になる
    ls_storage_key() { return "swars_custom_search" },

    ParamInfo() { return ParamInfo },
  },
}
