import _ from "lodash"

export const mod_form = {
  methods: {
    form_part_id(form_part) {
      return `form_part-${form_part.key}`
    },

    // for b-select
    form_part_elems_to_select_options(elems) {
      if (Array.isArray(elems)) {
        return elems.map(e => [e, e])
      } else if (_.isPlainObject(elems)) {
        return Object.entries(elems)
      } else {
        return [[elems, elems]]
      }
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
