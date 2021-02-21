export const app_support = {
  methods: {
    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      this.$router.push({name: 'rack-articles', query: {tag: tag}})
    },

    article_edit_handle() {
      this.sound_play("click")
      this.$router.push({name: "rack-articles-article_key-edit", params: {article_key: this.article.key}})
    },
  },
}
