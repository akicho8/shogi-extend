export default {
  methods: {
    // POST の場合 data はHashをそのまま渡せばよい
    remote_fetch(method, url, data, callback = null) {
      const loading = this.$buefy.loading.open()
      return this.$http({method: method, url: url, data: data})
        .then(r      => this.remote_fetch_success(r, loading, callback))
        .catch(error => this.remote_fetch_error(error, loading))
    },

    silent_remote_fetch(method, url, data, callback = null) {
      return this.$http({method: method, url: url, data: data})
        .then(r      => this.remote_fetch_success(r, null, callback))
        .catch(error => this.remote_fetch_error(error, null))
    },

    remote_get(url, params, callback = null) {
      const loading = this.$buefy.loading.open()
      return this.$http.get(url, {params: params})
        .then(r      => this.remote_fetch_success(r, loading, callback))
        .catch(error => this.remote_fetch_error(error, loading))
    },

    silent_remote_get(url, params, callback = null) {
      return this.$http.get(url, {params: params})
        .then(r      => this.remote_fetch_success(r, null, callback))
        .catch(error => this.remote_fetch_error(error, null))
    },

    // private

    remote_fetch_success(response, loading, callback) {
      if (loading) {
        loading.close()
      }

      // 本当はここでは呼びたくない
      // Rails側で render json: as_bs_error(error), status: 500 のようにしても
      // json は無視して 500 用のHTMLを error.response.data に格納してしまう
      // なので catch の方では bs_error がとれない
      // だからしかたなくこちらでひっかけている
      // メリットは then の方で bs_error がとれること
      if (response.data.bs_error) {
        this.bs_error_message_dialog(response.data.bs_error)
      }

      if (callback) {
        callback(response.data)
      }

      return Promise.resolve(response.data)
    },

    remote_fetch_error(error, loading) {
      if (loading) {
        loading.close()
      }

      console.log(error)
      console.log(error.response)
      console.log(error.message)

      const r = error.response

      // https://github.com/axios/axios#handling-errors
      if (r) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx
        console.log(r.data)    // {bs_error: ...} ← 自分が設定した render json: {} が入っている
        console.log(r.status)  // 500
        console.log(r.headers) // {access-control-allow-methods: ..., ...}

        const d = r.data
        if (d.bs_error) {       // development 環境だけで入っている
          this.bs_error_message_dialog(d.bs_error)
        } else {
          const lines = _.split(d, "\n")
          const first_line = _.take(lines, 10).join("<br>")
          this.error_message_dialog(`${r.statusText} (${r.status})<br><br>${first_line}`) // "Internal server error (500)"
        }
      } else if (error.request) {
        // The request was made but no response was received
        // `error.request` is an instance of XMLHttpRequest in the browser and an instance of
        // http.ClientRequest in node.js
        this.error_message_dialog(JSON.stringify(error.request))
      } else {
        // Something happened in setting up the request that triggered an Error
        this.error_message_dialog(error.message) // エラーコードしかわからない
      }

      throw new Error('API error.')
    },
  },
}
