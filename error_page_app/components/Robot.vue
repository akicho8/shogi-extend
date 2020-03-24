<template lang="pug">
  .robot_container.is-unselectable
    .box.has-text-weight-bold.has-text-centered.is-size-6.has-background-white-bis
      slot
    img(src="~assets/robot2_green.png")
    a.button.is-rounded.has-text-weight-bold.is-info(href="/") TOPページに戻る
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
    padding: 1.5rem
    border-radius: 40px

  img
    width: 20vmin

  a
    margin-top: 4rem
</style>
