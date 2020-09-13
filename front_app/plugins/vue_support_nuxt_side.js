export default {
  methods: {
    login_handle() {
      // location.href = this.$config.BASE_URL + "/xusers/sign_in"
      const params = new URLSearchParams()
      params.set("return_to", location.href)
      location.href = this.$config.BASE_URL + `/login?${params}`
    },
  },
}
