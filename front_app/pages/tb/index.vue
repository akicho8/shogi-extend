<template lang="pug">
div
  | infor={{info}}
</template>

<script>
// import actb_app from "~/components/actb_app/application.vue"

export default {
  name: 'index',
  // components: {
  //   actb_app,
  // },
  data() {
    return {
      info: null,
    }
  },
  created() {
    // this.remote_get("/script/actb-app", { remote_action: "info_fetch" }, e => {
    //   console.log(e)
    //   this.info = e
    // })
    // this.remote_get(process.env.BASE_URL + "/script/actb-app", { remote_action: "info_fetch" }, e => {
    //   this.info = e
    // })
  },
  // async asyncData ({params}) {
  //   this.remote_get("/script/actb-app", { remote_action: "info_fetch" }, e => {
  //     debugger
  //   })
  //
  //   // http://localhost:3000/script/actb-app
  //   // const { data: user } = await axios.get(`https://api.github.com/users/${params.id}`)
  //   // return {
  //   //   user
  //   // }
  // },
}
</script>
