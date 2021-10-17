// 使い方
//
// data() {
//   return {
//     screen_is_desktop: null,
//   }
// },
// beforeMount() {
//   this.screen_is_desktop = this.screen_match_p("desktop")
// },
export class ScreenSizeDetector {
  // node_modules/bulma/sass/utilities/initial-variables.sass
  // The container horizontal gap, which acts as the offset for breakpoints
  static _gap = 32
  // 960, 1152, and 1344 have been chosen because they are divisible by both 12 and 16
  static _tablet = 769
  // 960px container + 4rem
  static _desktop = 960 + (2 * this._gap)
  // 1152px container + 4rem
  static _widescreen = 1152 + (2 * this._gap)
  // 1344px container + 4rem
  static _fullhd = 1344 + (2 * this._gap)

  // node_modules/bulma/sass/utilities/mixins.sass
  static mobile           = `screen and (max-width: calc(${this._tablet}px - 1px))`
  static tablet           = `screen and (min-width: ${this._tablet}px), print`
  static tablet_only      = `screen and (min-width: ${this._tablet}px) and (max-width: calc(${this._desktop}px - 1px))`
  static touch            = `screen and (max-width: calc(${this._desktop}px - 1px))`
  static desktop          = `screen and (min-width: ${this._desktop}px)`
  static desktop_only     = `screen and (min-width: ${this._desktop}px) and (max-width: calc(${this._widescreen}px - 1px))`
  static until_widescreen = `screen and (max-width: calc(${this._widescreen}px - 1px))`
  static widescreen       = `screen and (min-width: ${this._widescreen}px)`
  static widescreen_only  = `screen and (min-width: ${this._widescreen}px) and (max-width: calc(${this._fullhd}px - 1px))`
  static until_fullhd     = `screen and (max-width: calc(${this._fullhd}px - 1px))`
  static fullhd           = `screen and (min-width: ${this._fullhd}px)`

  static match_p(type) {
    if (typeof window !== 'undefined') {
      const rv = window.matchMedia(this[type]).matches // ここで matchMedia に対して addEventListener すると監視できる
      console.log(`+${type} => ${rv} (${this[type]})`)
      return rv
    }
  }
}
