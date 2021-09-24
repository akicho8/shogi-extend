import { SearchCategoryInfo } from "../models/search_category_info.js"

export const app_search = {
  data() {
    return {
      query: null,
      tag:   null,
      search_p: !!this.$route.query.query,
    }
  },
  methods: {
    search_by_category(e) {
      this.sound_play("click")
      this.router_push({tag: e.tag})
    },

    search_field_toggle_handle() {
      this.sound_play("click")
      this.search_p = !this.search_p
    },
    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      tag = this.tags_append(this.tag, tag).join(",")
      this.router_push({tag})
    },
    tag_remove_handle(tag) {
      this.sound_play("click")
      tag = this.tags_remove(this.tag, tag).join(",")
      this.router_push({tag})
    },
    search_handle() {
      this.sound_play("click")
      this.router_push({})
    },
  },
  computed: {
    tags() {
      return this.tags_wrap(this.tag)
    },
    SearchCategoryInfo() { return SearchCategoryInfo },
  },
}
