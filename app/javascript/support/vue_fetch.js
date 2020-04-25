export default {
  methods: {
    // POST の場合 data はHashをそのまま渡せばよい
    http_command(method, url, data, callback = null) {
      const loading = this.$buefy.loading.open()
      this.$http({method: method, url: url, data: data})
        .then(r      => this.http_command_success(r, loading, callback))
        .catch(error => this.http_command_error(error, loading))
    },

    silent_http_command(method, url, data, callback = null) {
      this.$http({method: method, url: url, data: data})
        .then(r      => this.http_command_success(r, null, callback))
        .catch(error => this.http_command_error(error, null))
    },

    http_get_command(url, params, callback = null) {
      const loading = this.$buefy.loading.open()
      this.$http.get(url, {params: params})
        .then(r      => this.http_command_success(r, loading, callback))
        .catch(error => this.http_command_error(error, loading))
    },

    silent_http_get_command(url, params, callback = null) {
      this.$http.get(url, {params: params})
        .then(r      => this.http_command_success(r, null, callback))
        .catch(error => this.http_command_error(error, null))
    },

    // private

    http_command_success(response, loading, callback) {
      if (loading) {
        loading.close()
      }
      if (response.data.message) {
        this.$buefy.toast.open({message: response.data.message})
      }
      if (callback) {
        callback(response.data)
      }
    },

    http_command_error(error, loading) {
      if (loading) {
        loading.close()
      }
      console.table([error.response])
      this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
    },
  },
}
