export default {
  methods: {
    login_handle() {
      // location.href = this.$config.MY_SITE_URL + "/xusers/sign_in"
      const params = new URLSearchParams()
      params.set("return_to", location.href)
      location.href = this.$config.MY_SITE_URL + `/login?${params}`
    },

    jump_to_user(key, options = {}) {
      this.$router.push({name: "swars-users-key", params: {key: key}, query: options})
    },

    jump_to_battle(key, options = {}) {
      this.$router.push({name: "swars-battles-key", params: {key: key}, query: options})
    },
  },
}
