<template lang="pug">
client-only
  .full_screen_api
    .buttons
      b-button(@click="on_handle") ON
      b-button(@click="off_handle") OFF
      b-button(@click="toggle_handle") トグル
      b-button(@click="check_handle") 状態確認
    pre
      ul
        li 状態:{{current_status}}
        li この機能が使えるか？: {{enable_p()}}
</template>

<script>
export default {
  name: "full_screen_api",
  data() {
    return {
      current_status: null,
    }
  },
  mounted() {
    this.check_handle()
    this.on_handle()            // ユーザーの操作がないと動かない
  },
  methods: {
    // この機能が使えるか？
    enable_p() {
      if (typeof document !== 'undefined') {
        return document.fullscreenEnabled || document.mozFullScreenEnabled || document.documentElement.webkitRequestFullScreen || document.msFullscreenEnabled
      }
    },
    on_handle() {
      document.documentElement.requestFullscreen()
    },
    off_handle() {
      document.exitFullscreen()
    },
    // https://developer.mozilla.org/ja/docs/Web/API/Fullscreen_API
    toggle_handle() {
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen()
      } else {
        if (document.exitFullscreen) {
          document.exitFullscreen()
        }
      }
    },
    check_handle() {
      this.current_status = !!document.fullscreenElement // ON/OFFしてすぐに反映されるわけじゃない
    },
  },
}
</script>

<style lang="sass">
.full_screen_api
  __css_keep__: 0
</style>
