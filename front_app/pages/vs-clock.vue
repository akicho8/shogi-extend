<template lang="pug">
.vs-clock
  xclock
</template>

<script>
// import xclock from "~/components/xclock.vue"
import xclock from "~/components/xclock_app/app.vue"

export default {
  name: "xclock_app",
  components: {
    xclock,
  },
  head() {
    return {
      title: "対局時計",
      meta: [
        { hid: "description", name: "description", content: "ネット対局と同じような持ち時間のプリセットが入った対局時計です" }
      ]
    }
  },
  mounted() {
    // const url = "https://qiita.com/api/v2/items"
    // const response = await this.$axios.$get(url)
    // console.log(response)
    // const url = "/api"
    // const response = await this.$axios.$get(url)
    // console.log(response)
    // this.talk("てすと")
  },
}
</script>

<style lang="sass">
</style>
