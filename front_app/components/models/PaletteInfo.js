import MemoryRecord from 'js-memory-record/src/memory_record.js'

// https://gka.github.io/chroma.js/#quick-start
import chroma from 'chroma-js'

export default class PaletteInfo extends MemoryRecord {
  static get define() {
    return [
      // https://bulma.io/documentation/modifiers/color-helpers/
      { key: "info",    hsl: [204, 0.86, 0.53], },
      { key: "danger",  hsl: [348, 1.00, 0.61], },
      { key: "primary", hsl: [171, 1.00, 0.41], },
      { key: "warning", hsl: [ 48, 1.00, 0.67], },
      { key: "success", hsl: [141, 0.71, 0.48], },
      { key: "link",    hsl: [217, 0.71, 0.53], },
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
