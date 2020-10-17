<template lang="pug">
client-only
  .store_test
    b-button.is-block(@click="$store.dispatch('user/auth_user_fetch')")   $store.dispatch("user/auth_user_fetch")
    b-button.is-block(@click="$store.commit('user/current_user_clear')") $store.commit('user/current_user_clear')
    b-button.is-block(@click="auth_user_fetch") auth_user_fetch()
    b-button.is-block(@click="current_user_clear") current_user_clear()
    pre
      | $store.state = {{JSON.stringify($store.state, null, 2)}}
      | g_current_user = {{JSON.stringify(g_current_user, null, 2)}}

    template(v-show="true")
      table(border=1)
        caption
          | props
        tr(v-for="(value, key) in $props")
          th(v-text="key")
          td(style="white-space: pre" v-text="JSON.stringify(value, null, 4)")

      table(border="1")
        caption
          | data
        tr(v-for="(value, key) in $data")
          th(v-text="key")
          td(style="white-space: pre" v-text="JSON.stringify(value, null, 4)")

      table(border="1")
        caption
          | computed
        tr(v-for="(e, key) in _computedWatchers")
          th(v-text="key")
          td(style="white-space: pre" v-text="JSON.stringify(e.value, null, 4)")

      table(border="1")
        caption
          | $store
        tr(v-for="(value, key) in $store.state")
          th(v-text="key")
          td(style="white-space: pre" v-text="JSON.stringify(value, null, 4)")
</template>

<script>
import { mapState, mapMutations, mapActions } from "vuex"

export default {
  name: "store_test",
  data() {
    return {
    }
  },
  // fetch() {
  //   // http://localhost:3000/api/session/auth_user_fetch
  //   // return this.$axios.$get(`/api/sessionscurrent_user.json`).then(e => {
  //   //   this.current_user = e
  //   // })
  // },
  methods: {
    ...mapMutations("user", ["current_user_clear"]),
    ...mapActions('user', ["auth_user_fetch"]),
  },
  computed: {
    // ...mapState(['increment']),
    ...mapState("user", ["g_current_user"]),
    //   'isSignedIn'
    // ])
  },
}
</script>

<style lang="sass">
.store_test
</style>
