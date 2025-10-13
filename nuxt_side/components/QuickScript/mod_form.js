import _ from "lodash"
import { GX } from "@/components/models/gs.js"

export const mod_form = {
  methods: {
    form_part_id(form_part) { return `form_part-${form_part.key}`      },

    // input の list と datalist の id に指定する
    form_part_datalist_id(form_part) {
      if (form_part.auto_complete_by === 'html5') {
        return `form_part-list-${form_part.key}`
      }
    },

    form_part_autocomplete_datalist(form_part) {
      // const keys = _.map(form_part.elems, (key, e) => key)
      const keys = _.keys(form_part.elems)
      return _.filter(keys, key => {
        const a = key.toString().toLowerCase()
        const b = (this.attributes[form_part.key] || "").toLowerCase()
        return a.indexOf(b) >= 0
      })
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
      return form_part.help_message
    },

    // // for b-select
    // form_part_elems_to_key_label_array(elems) {
    //   // elems: [1, 2, 3]
    //   if (Array.isArray(elems)) {
    //     return elems.map(e => [e, e])
    //   }
    //
    //   // elems: { "key1" => { el_label: "(label)" } }  // ← この場合 el_message を追加できる
    //   // elems: { "key1" => "(label)"            }
    //   if (_.isPlainObject(elems)) {
    //     return _.map(elems, (attrs, key) => {
    //       let label = null
    //       if (_.isPlainObject(attrs)) {
    //         label = attrs.el_label
    //       } else {
    //         label = attrs
    //       }
    //       GX.assert(label != null, "label != null")
    //       return [key, label]
    //     })
    //   }
    //
    //   // elems: "a"
    //   if (elems) {
    //     return [[elems, elems]]
    //   }
    //
    //   return []
    // },

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
