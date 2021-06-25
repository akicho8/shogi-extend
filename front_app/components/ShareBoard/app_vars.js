import { CustomVarInfo } from "./custom_var_info.js"

export const app_vars = {
  data() {
    return {
      ...CustomVarInfo.values.reduce((a, e) => ({...a, [e.key]: null}), {}),
    }
  },
  methods: {
    vars_setup() {
      CustomVarInfo.values.forEach(e => {
        const default_value = e.default[this.STAGE] ?? e.default["production"]
        this.$set(this.DEFAULT_VARS, e.key, default_value)
        let v = this.$route.query[e.key] ?? this.DEFAULT_VARS[e.key]
        if (e.type === "integer") {
          v = parseInt(v)
        } else if (e.type === "float") {
          v = parseFloat(v)
        }
        this.$data[e.key] = v
        console.log(this.$data[e.key])
      })
    },
  },
  computed: {
    CustomVarInfo() { return CustomVarInfo },
  },
}
