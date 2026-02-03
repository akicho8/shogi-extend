// https://github.com/goldfire/howler.js#documentation
// http://localhost:4000/sound-test

import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export class VolumeCop {
  static CONFIG = {
    user_scale_default: 10,
    user_scale_min: 0,
    user_scale_max: 20,

    inside_scale_min: 0,
    inside_scale_max: 2.0,
  }

  static as_float_from_int(value) {
    GX.assert_kind_of_integer(value)
    return GX.map_range(value, ...this.map_range_args)
  }

  static volume_convert(volume, int_scale) {
    if (int_scale == null) {
      return volume
    }
    const float_scale = this.as_float_from_int(int_scale)
    const new_volume = volume * float_scale

    // Howler のマニュアルには音量は 0.0..1.0 とあるが実際にはそれを越えるとさらに増幅される
    // それは Howler はブラウザにそのまま音量をわたしているから
    // しかし増幅するということは音割れにも繋がるためソフト側で制限した方がよい
    // また負の値になるとさらに音が大きくなったりもするため下限でも制限したほうがよい
    const clamped_volume = _.clamp(new_volume, 0.0, 1.0)

    this.log(`スケール変換: [${this.map_range_args}] なので ${int_scale} は ${float_scale} になる`)
    this.log(`新音量: ${volume} * ${float_scale} → ${new_volume}`)
    this.log(`clamp後: ${new_volume} → ${clamped_volume}`)

    return clamped_volume
  }

  // private

  static get map_range_args() {
    return [
      this.CONFIG.user_scale_min,
      this.CONFIG.user_scale_max,
      this.CONFIG.inside_scale_min,
      this.CONFIG.inside_scale_max,
    ]
  }

  static log(...args) {
    if (process.env.NODE_ENV === "development") {
      console.log("[VolumeCop]", ...args)
    }
  }
}
