import Vue from "vue"
import App from "./App.vue"
import router from "./router"

// Buefy
import Buefy from "buefy"
import "./assets/scss/app.scss"
Vue.use(Buefy)

// Lodash
import _ from "lodash"
window.lodash = _
window._ = _
Object.defineProperty(Vue.prototype, "_", {value: _})
Object.defineProperty(Vue.prototype, "lodash", {value: _})

// window
Object.defineProperty(Vue.prototype, "window", {value: window})

// NODE_ENV
Object.defineProperty(Vue.prototype, "NODE_ENV", {value: process.env.NODE_ENV})

Vue.config.productionTip = false

import "./assets/scss/app.scss"

new Vue({
  router,
  render: h => h(App)
}).$mount("#app")
