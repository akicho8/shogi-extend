import { MyLocalStorage } from "@/components/models/my_local_storage.js"
import { PiyoShogiTypeInfo } from "@/components/models/piyo_shogi_type_info.js"

export const PiyoShogiTypeCurrent = {
  reset() {
    this._info = null
  },

  reload() {
    this.reset()
    return this.info
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
    if (process.env.NODE_ENV === "development") {
      console.log(`[PiyoShogiTypeCurrent] localStorage 参照 → ${key}`)
    }
    return PiyoShogiTypeInfo.fetch(key)
  }
}
