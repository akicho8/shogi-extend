import MemoryRecord from 'js-memory-record'

// https://gka.github.io/chroma.js/#quick-start
import chroma from 'chroma-js'

export default class PaletteBlackWhiteInfo extends MemoryRecord {
  static get define() {
    return [
      // https://bulma.io/documentation/modifiers/color-helpers/
      { key: "black", hsl: [0, 0, 0.2], },
      { key: "white", hsl: [0, 0, 0.9], },
    ]
  }

  // PaletteInfo.fetch(0).base_color.alpha(0.6).css()
  get base_color() {
    return chroma.hsl(...this.hsl)
  }

  // PaletteInfo.fetch(0).alpha(0.6)
  alpha(v) {
    return this.base_color.alpha(v).css()
  }

  // get borderColor() {
  //   return this.base_color.alpha(0.6).css()
  // }
  //
  // get backgroundColor() {
  //   return this.base_color.alpha(0.1).css()
  // }
}
