<template lang="pug">
.HelpContent
  .content(v-decorate)
    slot
</template>

<script>
export default {
  name: "HelpContent",
  // https://jp.vuejs.org/v2/guide/custom-directive.html
  directives: {
    decorate: {
      inserted(el, binding, vnode) {
        let s = el.innerHTML
        const arrow = "➡"
        s = s.replace(/→/g, `&nbsp;&nbsp;${arrow}&nbsp;&nbsp;`)
        el.innerHTML = s
      },
    },
  },
}
</script>

<style lang="sass">
.HelpContent
  padding: 2rem
  +mobile
    padding: 1rem

  article
    word-break: break-all

    &:not(:first-child)
      margin-top: 2rem
      // +mobile
      //   margin-top: 2rem

    h2
      font-weight: bold
      font-size: $size-5
      +mobile
        font-size: $size-6

      // &::before
      //   content: "🔵 "
    // ul
    //   list-style: none

    th
      white-space: nowrap

    ol, ul
      margin-left: 2em
      +mobile
        margin-left: 1em

    ul, ol, p
      margin-top:    0.5rem ! important
      margin-bottom: 0.5rem ! important

    p
      margin-left: 1em

    +mobile
      .mdi:before
        // font-size: $size-7
</style>
