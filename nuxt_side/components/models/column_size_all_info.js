import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class ColumnSizeAllInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_size_1",  name: "XS",  column_class: ["is-4-tablet",  "is-3-desktop",  "is-2-widescreen", "is-1-fullhd"],   },
      { key: "is_size_2",  name: "S",   column_class: ["is-6-tablet",  "is-4-desktop",  "is-3-widescreen", "is-2-fullhd"],   },
      { key: "is_size_3",  name: "M",   column_class: ["is-12-tablet", "is-6-desktop",  "is-4-widescreen", "is-3-fullhd"],   },
      { key: "is_size_4",  name: "L",   column_class: ["is-12-tablet", "is-12-desktop", "is-6-widescreen", "is-4-fullhd"],   },
      { key: "is_size_6",  name: "XL",  column_class: ["is-12-tablet", "is-12-desktop", "is-12-widescreen", "is-6-fullhd"],  },
      { key: "is_size_12", name: "XXL", column_class: ["is-12-tablet", "is-12-desktop", "is-12-widescreen", "is-12-fullhd"], },
    ]
  }
}
