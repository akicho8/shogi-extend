import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { PiyoShogiTypeInfo } from "@/components/models/piyo_shogi_type_info.js"

export const PiyoShogiTypeCurrent = {
  reset() {
    this._info = null
  },

  get info() {
    return this._info ??= this.piyo_shogi_type_info
  },

  // private

  get piyo_shogi_type_info() {
    const v = MyLocalStorage.get("user_settings")
    let key = "auto"
    if (v) {
      key = v.piyo_shogi_type_key
    }
    return PiyoShogiTypeInfo.fetch(key)
  }
}
