import { MyMobile } from "@/components/models/my_mobile.js"

export const vue_my_mobile = {
  // created() {
  //   console.log(this.my_mobile_p)
  // },
  // methods: {
  // },
  computed: {
    my_mobile_p()  {
      // console.log(`[${process.client ? 'CSR' : 'SSR'}][load] mobile_p: ${MyMobile.mobile_p}`)
      return MyMobile.mobile_p
    },
    my_desktop_p() { return MyMobile.desktop_p },
  },
}
