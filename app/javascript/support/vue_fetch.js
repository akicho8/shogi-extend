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

      // TODO: これは不要かもしれない。どこからも使ってなかったら消すこと
      if (response.data.message) {
        this.$buefy.toast.open({message: response.data.message})
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
    },

    http_command_error(error, loading) {
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
          this.error_message_dialog(`${r.statusText} (${r.status})`) // "Internal server error (500)"
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
    },
  },
}
