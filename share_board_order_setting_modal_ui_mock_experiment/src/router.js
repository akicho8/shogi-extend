import Vue from "vue"
import Router from "vue-router"

Vue.use(Router)

export default new Router({
  mode: "history",
  base: process.env.BASE_URL,
  routes: [
    { path: "/",        name: "/",       component: () => import(/* webpackChunkName: "MainApp" */ "./components/MainApp.vue") },
    { path: "/MainApp", name: "MainApp", component: () => import(/* webpackChunkName: "MainApp" */ "./components/MainApp.vue"), },
  ],
})
