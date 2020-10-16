<template lang="pug">
.error.has-background-dark
  .section.px-4.py-4
    .container
      .box.has-text-weight-bold.has-text-centered
        | {{message_body}}
      .has-text-centered.is-unselectable
        img(src="~/assets/robot2_green.png")
      .buttons.is-centered.mt-6
        b-button(tag="nuxt-link" to="/" icon-left="home" rounded)
</template>

<script>
export default {
  name: "error",
  props: ["error"],
  head() {
    return {
      title: `${this.error.statusCode} ERROR`,
    }
  },
  computed: {
    message_body() {
      return this.error.message || this.default_message
    },
    default_message() {
      if (this.error.statusCode === 404) {
        return "ファイルが見つかりません"
      } else {
        return "ぶっこわれました"
      }
    },
  },
}
</script>

<style lang="sass">
.error
  min-height: 100vh

  --balloon-bg-color: white
  --balloon-fg-color: transparent

  display: flex
  flex-direction: column
  flex-wrap: wrap
  justify-content: center
  align-items: center

  .box
    border-radius: 25px
    background-color: var(--balloon-bg-color)
    border: 1px solid var(--balloon-fg-color)

  img
    width: 20vmin
</style>
