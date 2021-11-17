<template lang="pug">
KiwiLemonNewApp(:xresource="xresource")
</template>

<script>
export default {
  name: "PagesVideoNew",
  async asyncData({ $axios, query, redirect }) {
    return { xresource: await $axios.$get("/api/kiwi/lemons/xresource_fetch.json", {params: query}) }
  },
}
</script>
