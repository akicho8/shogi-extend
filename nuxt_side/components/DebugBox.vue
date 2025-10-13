<template lang="pug">
// ここで v-if="development_p" を入れてはいけない
// 入れても slot はこれが呼ばれる前に作られるので意味がない
// 面倒なことに DebugBox を呼び出す側で DebugBox(v-if="development_p") としないといけない
.DebugBox(v-if="show_p" @click="click_handle" :class="position")
  slot
</template>

<script>
export default {
name: "DebugBox",
  props: {
    position: { type: String, required: false, default: "bottom_left", },
  },
  data() {
    return {
      show_p: null,             // ここで computed は参照できない。this.__SYSTEM_TEST_RUNNING__ は undefined になっている。
    }
  },
  created() {
    this.show_p = !this.__SYSTEM_TEST_RUNNING__
  },
  methods: {
    click_handle() {
      this.show_p = !this.show_p
    },
  },
}
</script>

<style lang="sass">
.DebugBox
  color: $white
  position: fixed
  background-color: hsla(0, 0%, 0%, 0.7)
  padding: 1rem
  z-index: 100
  max-width: 25vw
  overflow: auto
  white-space: nowrap
  border-radius: 0.5rem
  &.bottom_left
    bottom: 0.5rem
    left: 0.5rem
  &.bottom_right
    bottom: 0.5rem
    right: 0.5rem
</style>
