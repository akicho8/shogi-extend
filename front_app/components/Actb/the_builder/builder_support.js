import { support_child } from "../support_child.js"

export const builder_support = {
  mixins: [support_child],
  props: {
    bapp: {type: Object, required: false},
  },
}
