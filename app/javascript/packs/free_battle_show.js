import html2canvas from "html2canvas"
import axios from "axios"

window.FreeBattleShow = Vue.extend({
  data() {
    return {
      kifu_type_tab_index: 0,
    }
  },

  mounted() {
    if (!this.$options.kifu_canvas_image_attached) {
      const options = {
        // scale: 2,
        // dpi: 144,
      }
      html2canvas(document.querySelector("#capture_dom"), options).then(canvas => {
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
          this.$toast.open(response.data)
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
    }
  },
})
