import { MobileScreen } from "@/components/models/mobile_screen.js"

export const mobile_screen_adjust_mixin = {
  data() {
    return {
      mobile_screen: new MobileScreen(),
    }
  },

  mounted() {
    this.mobile_screen.event_add()
  },

  beforeDestroy() {
    this.mobile_screen.event_remove()
  },
}
