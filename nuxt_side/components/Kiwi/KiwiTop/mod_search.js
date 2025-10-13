import { SearchPresetInfo } from "../models/search_preset_info.js"

export const mod_search = {
  data() {
    return {
      search_preset_key: null,
      query:             null,
      tag:               null,
    }
  },
  methods: {
    search_preset_handle(e) {
      this.sfx_click()
      this.router_push({search_preset_key: e.key, page: null, tag: null})
    },
    tag_click_handle(tag) {
      this.sfx_click()
      this.talk(tag)
      tag = this.$GX.tags_add(this.tag, tag).join(",")
      this.router_push({tag})
    },
    tag_remove_handle(tag) {
      this.sfx_click()
      tag = this.$GX.tags_remove(this.tag, tag).join(",")
      this.router_push({tag})
    },
    search_handle() {
      this.sfx_click()
      this.router_push({})
    },
  },
  computed: {
    tags() { return this.$GX.str_to_tags(this.tag) },
    SearchPresetInfo() { return SearchPresetInfo },
    search_preset_info() { return this.SearchPresetInfo.fetch(this.search_preset_key || this.SearchPresetInfo.values[0].key) },
  },
}
