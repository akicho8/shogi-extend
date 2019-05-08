import html2canvas from "html2canvas"
import axios from "axios"

window.FreeBattleEditOgp = Vue.extend({
  data() {
    return {
      tweet_image_url: this.$options.tweet_image_url,
      turn_min: null,
      turn_max: null,
      real_turn: null,
    }
  },

  mounted() {
    this.turn_min = this.$refs.main_sp.turn_min
    this.turn_max = this.$refs.main_sp.turn_max
    this.real_turn = this.$refs.main_sp.real_turn
    this.$nextTick(() => this.$refs.ogp_turn_slider.focus())
  },

  methods: {
    current_turn_set(v) {
      this.$refs.main_sp.current_turn_set(v)
    },

    capture_dom_save() {

      const options = {
        // scale: 2,
        // dpi: 144,
      }
      const dom = document.querySelector("#capture_container .shogi-player")
      if (!dom) {
        alert("キャプチャ対象が見つかりません")
        return
      }
      html2canvas(dom, options).then(canvas => {
        const loading_instance = this.$loading.open()
        const params = new URLSearchParams()
        params.append("canvas_image_base64_data_url", canvas.toDataURL("image/png"))
        axios({
          method: "put",
          timeout: 1000 * 60 * 10,
          headers: {"X-Requested-With": "XMLHttpRequest"},
          url: this.$options.xhr_put_path,
          data: params,
        }).then((response) => {
          loading_instance.close()
          console.log(response.data)
          this.$toast.open({message: response.data.message})
          this.tweet_image_url = response.data.tweet_image_url
          this.debug_alert(this.tweet_image_url)
        }).catch((error) => {
          loading_instance.close()
          console.table([error.response])
          this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })

        // canvas.toBlob(blob => {
        //   const my_canvas_url = URL.createObjectURL(blob)
        //
        //   const params = new URLSearchParams()
        //   params.append("my_canvas_url", my_canvas_url)
        //
        //   axios({
        //     method: "put",
        //     timeout: 1000 * 60 * 10,
        //     headers: {"X-Requested-With": "XMLHttpRequest"},
        //     url: this.$options.xhr_put_path,
        //     data: params,
        //   }).then((response) => {
        //     console.log(response.data)
        //     this.toast.open("OK")
        //   }).catch((error) => {
        //     console.table([error.response])
        //     Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        //   })
        // })
      })
    },

    og_image_create() {
      this.debug_alert("og_image_create")
      this.capture_dom_save()
    },

    og_image_destroy() {
      this.debug_alert("og_image_destroy")

      const params = new URLSearchParams()
      params.append("og_image_destroy", true)
      axios({
        method: "put",
        timeout: 1000 * 60 * 10,
        headers: {"X-Requested-With": "XMLHttpRequest"},
        url: this.$options.xhr_put_path,
        data: params,
      }).then((response) => {
        this.$toast.open({message: response.data.message})
        this.tweet_image_url = null
      }).catch((error) => {
        console.table([error.response])
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
})
