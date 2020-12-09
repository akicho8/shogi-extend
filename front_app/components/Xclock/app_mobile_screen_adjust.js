import { MobileScreen } from "@/components/models/MobileScreen.js"

export const app_mobile_screen_adjust = {
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
