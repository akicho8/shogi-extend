<template lang="pug">
  div
    template(v-if="development")
      .section
        .tabs
          ul
            li(v-for="(item, key) of items" :key="key")
              nuxt-link(:to="item.to" exact-active-class="is-active")
                | {{item.title}}
    .container_body
      nuxt
</template>

<script>
export default {
  data () {
    return {
      development: (process.env.NODE_ENV !== "production"),
      items: [
        { title: "Home", to: { name: "index"   } },
        { title: "404",  to: { name: "page404" } },
        { title: "422",  to: { name: "page422" } },
        { title: "500",  to: { name: "page500" } },
      ]
    }
  }
}
</script>

<style lang="sass">
html
  background-color: hsl(0, 0%, 100%)

  .container_body
    display: flex
    justify-content: center
    align-items: center
    height: 100vh
</style>
