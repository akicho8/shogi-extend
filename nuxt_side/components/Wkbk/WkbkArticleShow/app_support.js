export const app_support = {
  methods: {
    tag_search_handle(tag) {
      this.$sound.play_click()
      this.talk(tag)
      this.$router.push({name: 'rack-articles', query: {tag: tag}})
    },

    article_edit_handle() {
      this.$sound.play_click()
      this.$router.push({name: "rack-articles-article_key-edit", params: {article_key: this.article.key}})
    },

    // コピーして新規
    article_new_handle() {
      this.$sound.play_click()
      this.$router.push({name: "rack-articles-new", query: {source_article_key: this.article.key}})
    },
  },
}
