// import Vue from 'vue'
// import VueTippy, { TippyComponent } from 'vue-tippy'
// import 'tippy.js/dist/tippy.css' // Tippy のスタイル
// 
// Vue.use(VueTippy, {
//   directive: 'tippy', // v-tippy ディレクティブ名（省略可能）
//   flipDuration: 0,    // 表示方向の切り替え速度（任意）
//   popperOptions: {
//     modifiers: [
//       {
//         name: 'preventOverflow',
//         options: {
//           boundary: 'viewport',
//         },
//       },
//     ],
//   },
// })
// 
// Vue.component('tippy', TippyComponent) // <tippy> コンポーネントを登録

import Vue from 'vue'
import VueTippy, { TippyComponent } from 'vue-tippy'
import 'tippy.js/dist/tippy.css' // 必須：ツールチップのスタイル

Vue.use(VueTippy, {
  directive: 'tippy', // v-tippy として使えるようにする
  defaultProps: {
    placement: 'top',
    animation: 'fade',
    arrow: true,
    delay: [50, 0],
    theme: 'light',
  },
})

Vue.component('tippy', TippyComponent) // <tippy> コンポーネントも使用可能に
