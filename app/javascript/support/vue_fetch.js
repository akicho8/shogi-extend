export default {
  methods: {
    http_command(method, url, data, callback = null) {
      const loading_instance = this.$buefy.loading.open()
      this.$http({method: method, url: url, data: data}).then(response => this.http_command_then_process(response, loading_instance, callback)).catch(error => this.http_command_error_process(error, loading_instance))
    },

    http_get_command(url, params, callback = null) {
      const loading_instance = this.$buefy.loading.open()
      this.$http.get(url, {params: params}).then(response => this.http_command_then_process(response, loading_instance, callback)).catch(error => this.http_command_error_process(error, loading_instance))
    },

    silent_http_get_command(url, params, callback = null) {
      this.$http.get(url, {params: params}).then(response => this.http_command_then_process(response, null, callback)).catch(error => this.http_command_error_process(error, null))
    },

    // private

    http_command_then_process(response, loading_instance, callback) {
      if (loading_instance) {
        loading_instance.close()
      }
      if (response.data.message) {
        this.$buefy.toast.open({message: response.data.message})
      }
      if (callback) {
        callback(response.data)
      }
    },

    http_command_error_process(error, loading_instance) {
      if (loading_instance) {
        loading_instance.close()
      }
      console.table([error.response])
      this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
    },
  },
}
