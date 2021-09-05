// https://developer.mozilla.org/ja/docs/Web/API/Fullscreen_API
//
// この機能が有効か？
//
//  FullScreenController.enable_p()
//
// 全体をフルスクリーン化するには？
//
//   full_screen = new FullScreenController()
//   full_screen.on()
//
// 一部の要素をフルスクリーン化するには？
//
//   full_screen = new FullScreenController(document.querySelector("#foo"))
//   full_screen.on()
//
export class FullScreenController {
  // https://blog.katsubemakito.net/html5/fullscreen
  static enable_p() {
    return false ||
      document.fullscreenEnabled                       ||
      document.mozFullScreenEnabled                    ||
      document.documentElement.webkitRequestFullScreen ||
      document.msFullscreenEnabled                     ||
      false
  }

  constructor(element = document.documentElement) {
    this.element = element

    if (!this.enable_p()) {
      console.log("FullScreen API に対応していない")
    }

    // メソッド統一
    if (true) {
      // https://syncer.jp/Web/API_Interface/Reference/IDL/Element/requestFullscreen/
      element.requestFullscreen = element.requestFullscreen || element.mozRequestFullScreen || element.webkitRequestFullscreen || element.msRequestFullscreen
      document.exitFullscreen   = document.exitFullscreen || document.cancelFullScreen || document.mozCancelFullScreen || document.webkitCancelFullScreen || document.msExitFullscreen
    }
  }

  toggle() {
    if (!this.enable_p()) return

    if (this.inactive_p()) {
      this.on()
    } else {
      this.off()
    }
  }

  on() {
    if (!this.enable_p()) return

    if (this.inactive_p()) {
      this.element.requestFullscreen()
    }
  }

  off() {
    if (!this.enable_p()) return

    if (this.active_p()) {
      if (document.exitFullscreen) {
        document.exitFullscreen()
      }
    }
  }

  // private

  active_p() {
    return !!document.fullscreenElement
  }

  inactive_p() {
    return !this.active_p()
  }

  enable_p() {
    return this.constructor.enable_p()
  }
}
