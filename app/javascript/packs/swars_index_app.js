document.addEventListener("DOMContentLoaded", () => {
  window.SwarsIndexApp = Vue.extend({
    data() {
      return {
        submited: false,
      }
    },

    mounted() {
    },

    methods: {
      form_submited(e) {
        Vue.prototype.$dialog.alert({
          title: "処理中",
          message: "しばらくお待ちください",
          type: "is-primary",
          // hasIcon: true,
          // icon: "crown",
          // iconPack: "mdi",
        })

        this.submited = true
      },
    },
  })
})
