import { MobileScreen } from "../../../app/javascript/models/MobileScreen.js"

export const app_resize = {
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
