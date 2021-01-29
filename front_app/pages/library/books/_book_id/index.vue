<template lang="pug">
client-only
  WkbkBookShowApp
</template>

<script>
export default {
  name: "wkbk-books-_book_id-index",
  async asyncData({ $axios, params }) {
    if (process.server) {
      const e = await $axios.$get("/api/wkbk/books/show", {params})
      return { book: e.book }
    } else {
      return { book: null }
    }
  },
  computed: {
    meta() {
      // やっぱりデータを渡すようにするべき？
      if (this.book) {
        return {
          title: this.book.title,
          description: this.book.description ?? "",
          og_image: this.book.og_image_path ?? "library-books",
        }
      } else {
        return {
          title: "非公開",
          description: "",
          og_image_key: "library-books",
          twitter_card_is_small: true,
        }
      }
    },
  },
}
</script>

<style lang="sass">
</style>
