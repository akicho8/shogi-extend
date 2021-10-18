import { TapDetectInfo } from "./models/tap_detect_info.js"

export const app_tap_detect = {
  data() {
    return {
      tap_detect_key: null,
    }
  },
  computed: {
    TapDetectInfo()  { return TapDetectInfo  },
    tap_detect_info() { return TapDetectInfo.fetch(this.tap_detect_key) },
  },
}
