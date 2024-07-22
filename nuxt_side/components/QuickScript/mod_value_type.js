export const mod_value_type = {
  methods: {
    // API側で判定した方がいい？ → テーブル内のTDなど最適に判定する → ビューで判定であっている
    value_type_guess(value) {
      if (Array.isArray(value)) {
        if (_.isPlainObject(value[0])) {
          return "value_type_is_hash_array"
        }
        return "value_type_is_text_array"
      }
      if (typeof(value) === "string") {
        if (value.startsWith("<")) {
          return "value_type_is_html"
        }
        return "value_type_is_text"
      }
      if (_.isPlainObject(value)) {
        if ("_component" in value) {
          return "value_type_is_component"
        }
        if ("_nuxt_link" in value) {
          return "value_type_is_nuxt_link"
        }
        if ("_link_to" in value) {
          return "value_type_is_link_to"
        }
        if ("_v_text" in value) {
          return "value_type_is_v_text"
        }
        if ("_v_html" in value) {
          return "value_type_is_v_html"
        }
        if ("_pre" in value) {
          return "value_type_is_pre"
        }
        if ("_autolink" in value) {
          return "value_type_is_autolink"
        }
        return "value_type_is_any_hash"
      }
      return "value_type_is_unknown"
    },

    label_value_array(value) {
      if (Array.isArray(value)) {
        return value.map(e => [e, e])
      } else if (_.isPlainObject(value)) {
        return Object.entries(value)
      } else {
        return [[value, value]]
      }
    },

    type_to_component(form_part) {
      if (form_part.type === "radio_button") {
        return "b-radio-button"
      } else if (form_part.type === "checkbox_button") {
        return "b-checkbox-button"
      } else {
        throw new Error("must not happen")
      }
    },
  },
}
