<template lang="pug">
client-only
  .full_screen(v-if="object")
    .buttons
      b-button(@click="object.on()") ON
      b-button(@click="object.off()") OFF
      b-button(@click="object.toggle()") トグル
      b-button(@click="$forceUpdate()") 状態確認
    pre
      ul
        li 機能: {{object.constructor.enable_p()}}
        li 状態: {{object.active_p()}}
</template>

<script>
import { FullScreen } from "@/components/models/FullScreen.js"

export default {
  name: "full_screen",
  data() {
    return {
      object: null,
    }
  },
  mounted() {
    this.object = new FullScreen()
    this.object.on()
  },
}
</script>

<style lang="sass">
.full_screen
</style>
