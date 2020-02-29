<template lang="pug">
  .robot_container.is-unselectable
    .box.has-text-weight-bold.has-text-centered.is-size-7
      slot
    img(src="~assets/robot2_green.png")
    a(href="/" class="") TOP
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
    },
    icon: {
      type: String,
    }
  }
}
</script>

<style lang="sass">
.robot_container
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

  a
    margin-top: 2em
</style>
