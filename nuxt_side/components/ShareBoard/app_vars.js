import { CustomVarInfo } from "./models/custom_var_info.js"

export const app_vars = {
  data() {
    return {
      ...CustomVarInfo.values.reduce((a, e) => ({...a, [e.key]: null}), {}),
    }
  },
  methods: {
    vars_setup() {
      CustomVarInfo.values.forEach(e => {
        const default_value = e.default[this.$config.STAGE] ?? e.default["production"]
        this.$set(this.DEFAULT_VARS, e.key, default_value)
        let v = this.$route.query[e.key] ?? this.DEFAULT_VARS[e.key]
        if (e.type === "string") {
        } else if (e.type === "float") {
          v = parseFloat(v)
        } else if (e.type === "integer") {
          v = parseInt(v)
        } else {
          throw new Error(`${e.type}`)
        }
        this.$data[e.key] = v
      })
    },
  },
  computed: {
    CustomVarInfo() { return CustomVarInfo },
    custom_var_all() { return CustomVarInfo.values.reduce((a, e) => ({...a, [e.key]: this.$data[e.key]}), {}) },
  },
}
