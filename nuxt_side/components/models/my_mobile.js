import isMobile from "ismobilejs"

export const MyMobile = {
  get mobile_p() {
    if (typeof window !== "undefined") {
      return isMobile(navigator).any
    }
  },
  get desktop_p() {
    if (typeof window !== "undefined") {
      return !isMobile(navigator).any
    }
  },
  get type() {
    if (this.mobile_p) {
      return "mobile"
    }
    if (this.desktop_p) {
      return "desktop"
    }
  },
}
