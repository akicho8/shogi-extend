import { GX } from "@/components/models/gx.js"

export const mod_form = {
  data() {
    return {
    }
  },
  methods: {
  },
  computed: {
    input_element_size() { return "" },

    grade_diff_message() {
      let v = this.grade_diff
      let x = Math.abs(v)
      if (x === 1) {
        x = "やや"
      }
      let s = ""
      if (v > 0) {
        s = `相手は自分より${x}強い`
      } else if (v < 0) {
        s = `相手は自分より${x}弱い`
      } else {
        s = "相手は好敵手"
      }
      return s
    },

    swars_id_required_message() {
      if (GX.blank_p(this.user_key)) {
        return "1つだけ入力してください"
      }
    },
  },
}
