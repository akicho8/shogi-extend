<template lang="pug">
.experiment-users-id
  MainNavbar
    template(slot="brand")
      b-navbar-item(tag="div") users/_id 動作検証
    template(slot="start")
    template(slot="end")
      b-navbar-item(tag="nuxt-link" :to="{name:'index'}" exact-active-class="is-active") TOP

  MainSection
    .block
      nuxt-link.is-block(:to="{name: 'experiment-users-id'                 }") users
      nuxt-link.is-block(:to="{name: 'experiment-users-id', params: {id: 1}}") users/1
      nuxt-link.is-block(:to="{name: 'experiment-users-id', params: {id: 2}}") users/2
      nuxt-link.is-block(:to="{name: 'experiment-users-id', params: {id: 2}, query: {a:1}}") users/2?a=1
      nuxt-link.is-block(:to="{name: 'experiment-users-id', params: {id: 2}, query: {a:2}}") users/2?a=2
    .block
      b $route.query
      pre {{$route.query}}
    .block
      b $route.params
      pre {{$route.params}}
    .block
      b $nuxt.$route.query
      pre {{$nuxt.$route.query}}
    .block
      b $nuxt.$route.params
      pre {{$nuxt.$route.params}}
    .block
      b config
      pre {{config}}
</template>

<script>
export default {
  name: "experiment-users-id",
  watch: {
    "$route.query": function(v) {
      this.$buefy.toast.open({message: `watch query: ${JSON.stringify(v)}`, queue: false})
    },
    "$route.params": function(v) {
      this.$buefy.toast.open({message: `watch params: ${JSON.stringify(v)}`, queue: false})
    },
  },
  created() {
    this.$axios_interceptor = this.$axios.interceptors.response.use(
      response => {
        this.$buefy.toast.open({message: "(axios response)", queue: false})
        return response;
      },
      // error => {
      //   if (error.response.status === 401) {
      //     this.$dialog.alert({
      //       title: 'Please log-in again',
      //       message: 'You were in-active for a longer time. Please log-in again. (This might be really fast, if you are still signed-in in Spotify)',
      //       confirmText: 'OK',
      //       type: 'is-primary',
      //       onConfirm: () => location.reload(true)//this.logOut(),
      //     })
      //   }
      //   return Promise.reject(error);
      // }
    );
  },
  beforeDestroy() {
    if (this.$axios_interceptor) {
      this.$buefy.toast.open({message: "(axios destroy)", queue: false})
      this.$axios.interceptors.response.eject(this.$axios_interceptor)
      this.$axios_interceptor = null
    }
  },
  async asyncData({ $axios, params, query }) {
    const config = await $axios.$post("/api/ping.json", params)
    return { config }
  },
}
</script>

<style lang="sass">
.experiment-users-id
</style>
