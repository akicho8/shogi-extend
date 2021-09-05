// HTMLタグを含めて背景を黒または任意の色にする
//
// 使い方
//
//   import { html_background_black_mixin } from "../../components/models/html_background_black_mixin.js"
//
//   export default {
//     mixins: [
//       html_background_black_mixin,
//     ],
//     computed: {
//       html_append_classes() {
//         return [
//           "has-background-primary",
//         ]
//       },
//     },
//   }

export const html_background_black_mixin = {
  mounted() {
    this.html_background_black_mixin_elem().classList.add(...this.html_append_classes)
  },

  beforeDestroy() {
    this.html_background_black_mixin_elem().classList.remove(...this.html_append_classes)
  },

  methods: {
    html_background_black_mixin_elem() {
      return document.querySelector(this.html_background_black_mixin_selector)
    }
  },

  computed: {
    html_background_black_mixin_selector() {
      return "html"
    },

    html_append_classes() {
      return [
        "has-background-black",
      ]
    },
  },
}
