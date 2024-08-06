import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_form = {
  methods: {
    form_part_id(form_part) {
      return `form_part-${form_part.key}`
    },

    form_part_help_message(form_part) {
      // 1. elems[key].el_message があれば優先的に表示する
      const key = this.attributes[form_part.key]
      if (form_part.elems) {
        const hv = form_part.elems[key]
        if (_.isPlainObject(hv) && hv.el_message) {
          return hv.el_message
        }
      }

      // 2. 初期値
      return form_part.el_message
    },

    // for b-select
    form_part_elems_to_key_label_array(elems) {
      // elems: [1, 2, 3]
      if (Array.isArray(elems)) {
        return elems.map(e => [e, e])
      }

      // elems: { "key1" => { el_label: "(label)" } }  // ← この場合 el_message を追加できる
      // elems: { "key1" => "(label)"            }
      if (_.isPlainObject(elems)) {
        return _.map(elems, (attrs, key) => {
          let label = null
          if (_.isPlainObject(attrs)) {
            label = attrs.el_label
          } else {
            label = attrs
          }
          Gs.assert(label != null, "label != null")
          return [key, label]
        })
      }

      // elems: "a"
      if (elems) {
        return [[elems, elems]]
      }

      return []
    },

    // for b-radio-button, b-checkbox-button
    form_part_type_to_component(type) {
      if (type === "radio_button") {
        return "b-radio-button"
      } else if (type === "checkbox_button") {
        return "b-checkbox-button"
      } else {
        throw new Error("must not happen")
      }
    },
  },
}
