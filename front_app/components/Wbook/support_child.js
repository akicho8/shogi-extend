import { support } from "./support.js"

export const support_child = {
  mixins: [support],
  props: {
    base: {type: Object, required: false},
  },
}
