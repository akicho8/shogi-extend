import html2canvas from "html2canvas"

window.FreeBattleEditOgp = Vue.extend({
  data() {
    return {
      tweet_origin_image_path: this.$options.tweet_origin_image_path,
      start_turn: this.$options.og_turn,
      slider_show: false,
    }
  },

  mounted() {
    if (this.auto_write_p) {
      this.capture_dom_save()
    } else {
      this.slider_show = true // スライダーはマウントしてから有効にすること
      this.$nextTick(() => this.$refs.ogp_turn_slider.focus())
    }
  },

  methods: {
    capture_dom_save() {
      const html2canvas_options = {
        // scale: 2,
        // dpi: 144,
      }
      const dom = document.querySelector("#capture_main")
      if (!dom) {
        alert("キャプチャ対象が見つかりません")
        return
      }
      html2canvas(dom, html2canvas_options).then(canvas => {
        const loading_instance = this.$buefy.loading.open()
        const params = new URLSearchParams()
        params.set("canvas_image_base64_data_url", canvas.toDataURL("image/png"))
        params.set("image_turn", this.start_turn)
        this.$http.put(this.$options.xhr_put_path, params).then(response => {
          loading_instance.close()
          console.log(response.data)
          this.$buefy.toast.open({message: response.data.message})
          this.tweet_origin_image_path = response.data.tweet_origin_image_path
          this.debug_alert(this.tweet_origin_image_path)
          if (this.auto_write_p) {
            location.href = this.$options.show_path
          }
        }).catch(error => {
          loading_instance.close()
          console.table([error.response])
          this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      })
    },

    og_image_create_by_html2canvas() {
      this.debug_alert("og_image_create_by_html2canvas")
      this.capture_dom_save()
    },

    og_image_destroy() {
      this.debug_alert("og_image_destroy")

      const params = new URLSearchParams()
      params.set("og_image_destroy", true)
      this.$http.put(this.$options.xhr_put_path, params).then(response => {
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
      this.$http.put(this.$options.xhr_put_path, params).then(response => {
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
    auto_write_p() {
      return this.$options.auto_write
    },
  },
})
