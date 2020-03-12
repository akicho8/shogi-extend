window.FreeBattleEditOgp = Vue.extend({
  data() {
    return {
      tweet_origin_image_path: this.$options.tweet_origin_image_path,
      start_turn: this.$options.display_turn,
      slider_show: false,
    }
  },

  mounted() {
    this.slider_show = true // スライダーはマウントしてから有効にすること
    this.$nextTick(() => this.$refs.ogp_turn_slider.focus())
  },

  methods: {
    og_image_destroy() {
      this.debug_alert("og_image_destroy")

      const params = new URLSearchParams()
      params.set("og_image_destroy", true)
      this.$http.put(this.$options.record.xhr_put_path, params).then(response => {
        this.$buefy.toast.open({message: response.data.message})
        this.tweet_origin_image_path = null
      }).catch(error => {
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

    og_image_create_by_rmagick() {
      const loading_instance = this.$buefy.loading.open()
      const params = new URLSearchParams()
      params.set("create_by_rmagick", "true")
      params.set("image_turn", this.start_turn)

      this.$http.put(this.$options.record.xhr_put_path, params).then(response => {
        loading_instance.close()
        console.log(response.data)
        this.$buefy.toast.open({message: response.data.message})
        this.tweet_origin_image_path = response.data.tweet_origin_image_path
        this.debug_alert(this.tweet_origin_image_path)
      }).catch(error => {
        loading_instance.close()
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },

  computed: {
  },
})
