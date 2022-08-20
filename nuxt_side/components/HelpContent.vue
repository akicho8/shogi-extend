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
  padding: 2em
  +mobile
    font-size: $size-7

  article
    word-break: break-all
    &:not(:first-child)
      margin-top: 2em
    h2
      font-weight: bold
      font-size: $size-6
    th
      white-space: nowrap
    ol, ul, p
      margin-top:    0.5em ! important
      margin-bottom: 0.5em ! important
    ol, ul
      margin-left: 2em
    p
      margin-left: 1em
</style>
