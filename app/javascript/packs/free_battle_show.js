import html2canvas from "html2canvas"
import axios from "axios"

window.FreeBattleShow = Vue.extend({
  data() {
    return {
      kifu_type_tab_index: 0,
      tweet_image_url: this.$options.tweet_image_url,
    }
  },

  mounted() {
    // if (!this.$options.kifu_canvas_image_attached) {
    //   this.capture_dom_save()
    // }
  },

  methods: {
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
        const params = new URLSearchParams()
        params.append("canvas_image_base64_data_url", canvas.toDataURL("image/png"))
        axios({
          method: "put",
          timeout: 1000 * 60 * 10,
          headers: {"X-Requested-With": "XMLHttpRequest"},
          url: this.$options.xhr_put_path,
          data: params,
        }).then((response) => {
          console.log(response.data)
          this.$toast.open({message: response.data.message})
          this.tweet_image_url = response.data.tweet_image_url
          this.debug_alert(this.tweet_image_url)
        }).catch((error) => {
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
        console.log(response.data)
        this.$toast.open({message: response.data.message})
        this.tweet_image_url = null
      }).catch((error) => {
        console.table([error.response])
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
})
