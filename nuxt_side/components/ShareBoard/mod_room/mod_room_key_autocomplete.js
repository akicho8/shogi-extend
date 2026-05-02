import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_room_key_autocomplete = {
  mounted() {
    if (this.development_p) {
      this.complement_room_keys = ["ドンキーコング","ドンキーコングJR","ポパイ","五目ならべ","麻雀","マリオブラザーズ","ポパイの英語遊び","ベースボール","ドンキーコングJR.の算数遊び","テニス","ピンボール","ワイルドガンマン","ダックハント","ゴルフ","ホーガンズアレイ","ファミリーベーシック","ドンキーコング3","ナッツ＆ミルク","ロードランナー","ギャラクシアン","デビルワールド","F1レース","パックマン","4人打ち麻雀","ゼビウス","アーバンチャンピオン","マッピー","クルクルランド"]
    }
  },

  methods: {
    room_key_autocomplete_select_handle() {
    },

    room_key_autocomplete_enter_handle() {
    },

    // room_key を complement_room_keys (localStorage) に保存する
    room_keys_update_and_save_to_storage() {
      if (GX.present_p(this.room_key)) {
        let av = [this.room_key, ...this.complement_room_keys]
        av = _.uniq(av)
        av = _.take(av, this.room_keys_limit)
        this.complement_room_keys = av
      }
    },
  },
  computed: {
    room_key_autocomplete_use_p() { return true }, // b-autocomplete を使うか？

    // b-autocomplete 用の補完リスト
    room_key_autocomplete_complement_list() {
      if (this.complement_room_keys) {
        return this.complement_room_keys.filter(option => {
          const a = option.toString().toLowerCase()
          const b = (this.new_room_key || "").toLowerCase()
          return a.indexOf(b) >= 0 // 部分一致
        })
      }
    },
  },
}
