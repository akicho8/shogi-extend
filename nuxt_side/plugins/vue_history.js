// https://jamblog-beryl.vercel.app/history-back/

// オリジナルコード
// // plugins/replaceState.client.js
// export default ({ app }) => {
//   const history = window.history
//   const initState = history.state
//
//   switch (initState && initState.canGoBack) {
//     case null:
//     case undefined:
//       // console.log('初回アクセス')
//       const stateCopy = initState === null ? {} : Object.assign({}, initState)
//       stateCopy.canGoBack = false
//       history.replaceState(stateCopy, '')
//     //   break
//     // default:
//     //   console.log('戻る・進むまたは更新によるアクセス')
//   }
//
//   app.router.afterEach(() => {
//     const state = history.state
//
//     if (state.canGoBack === undefined) {
//       // console.log('<nuxt-link>, $router.push() 等による遷移')
//       const stateCopy = Object.assign({}, state)
//       stateCopy.canGoBack = true
//       history.replaceState(stateCopy, '')
//     }
//     // else {
//     //   console.log('$router.go(), 戻る・進む等による遷移')
//     // }
//   })
// }

// plugins/vue_history.js
export default ({ app }) => {
  if (window.history.state && window.history.state.back_to_ok) {
    // console.log('戻る・進むまたは更新によるアクセス')
  } else {
    // 初回アクセス
    window.history.replaceState({...window.history.state, back_to_ok: false}, "") // 「初回アクセスなので戻れない」とする
  }

  app.router.afterEach(() => {
    const state = window.history.state
    if (state.back_to_ok === undefined) {
      // console.log('<nuxt-link>, $router.push() 等による遷移')
      window.history.replaceState({...state, back_to_ok: true}, "")
    } else {
      // console.log('$router.go(), 戻る・進む等による遷移')
    }
  })
}
