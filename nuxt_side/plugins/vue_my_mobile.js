import { MyMobile } from "@/components/models/my_mobile.js"

export const vue_my_mobile = {
  computed: {
    mobile_p()  { return MyMobile.mobile_p },
    desktop_p() { return MyMobile.desktop_p },
  },
}
