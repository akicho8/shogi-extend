export const mod_support = {
  methods: {
    tag_search_handle(tag) {
      this.sfx_click()
      this.talk(tag)
      this.$router.push({name: 'rack-articles', query: {tag: tag}})
    },

    article_edit_handle() {
      this.sfx_click()
      this.$router.push({name: "rack-articles-article_key-edit", params: {article_key: this.article.key}})
    },

    // コピーして新規
    article_new_handle() {
      this.sfx_click()
      this.$router.push({name: "rack-articles-new", query: {source_article_key: this.article.key}})
    },
  },
}
