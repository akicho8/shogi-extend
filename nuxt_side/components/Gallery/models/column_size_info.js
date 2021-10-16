import MemoryRecord from 'js-memory-record'

export class ColumnSizeInfo extends MemoryRecord {
  static get define() {
    return [
      // { key: "is_size_xs",  name: "XS",  column_class: ["is-4-tablet",  "is-3-desktop",  "is-2-widescreen", "is-1-fullhd"], },
      { key: "is_size_s",   name: "S",   column_class: ["is-6-tablet",  "is-4-desktop",  "is-3-widescreen", "is-2-fullhd"], },
      { key: "is_size_m",   name: "M",   column_class: ["is-12-tablet", "is-6-desktop",  "is-4-widescreen", "is-3-fullhd"], },
      { key: "is_size_l",   name: "L",   column_class: ["is-12-tablet", "is-12-desktop", "is-6-widescreen", "is-4-fullhd"], },
      // { key: "is_size_xl",  name: "XL",  column_class: ["is-12-tablet", "is-12-desktop", "is-12-widescreen", "is-6-fullhd"], },
      // { key: "is_size_xxl", name: "XXL", column_class: ["is-12-tablet", "is-12-desktop", "is-12-widescreen", "is-12-fullhd"], },
    ]
  }
}
