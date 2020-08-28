// 100vh相当の範囲に実際に見えている範囲(innerHeight)を設定する

import { isMobile } from "./isMobile.js"

export class MobileScreen {
  constructor(params = {}) {
    this.target_class = params.target_class || "screen_container"

    this.enabled = params.enabled
    if (this.enabled == null) {
      this.enabled = isMobile.any()
    }
  }

  event_add() {
    this.handle()
    window.addEventListener("resize", this.handle)
  }

  event_remove() {
    window.removeEventListener("resize", this.handle)
  }

  // private

  handle() {
    const height = window.innerHeight
    if (this.enabled) {
      document.getElementsByClassName(this.target_class)[0].style.height = `${height}px`
    }
  }
}
