// 100dvh相当の範囲に実際に見えている範囲(innerHeight)を設定する

import { MyMobile } from "./my_mobile.js"

export class MobileScreen {
  constructor(params = {}) {
    this.target_class = params.target_class || "screen_container"

    this.enabled = params.enabled
    if (this.enabled == null) {
      this.enabled = MyMobile.mobile_p
    }
  }

  event_add() {
    this.handle()
    window.addEventListener("resize", () => this.handle())
  }

  event_remove() {
    window.removeEventListener("resize", () => this.handle())
  }

  // private

  handle() {
    const height = window.innerHeight
    if (this.enabled) {
      document.getElementsByClassName(this.target_class)[0].style.height = `${height}px`
    }
  }
}
