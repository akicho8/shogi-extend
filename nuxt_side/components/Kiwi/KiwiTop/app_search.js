import { SearchPresetInfo } from "../models/search_preset_info.js"

export const app_search = {
  data() {
    return {
      search_preset_key: null,
      query:             null,
      tag:               null,
    }
  },
  methods: {
    search_preset_handle(e) {
      this.sound_play_click()
      this.router_push({search_preset_key: e.key, page: null, tag: null})
    },
    tag_click_handle(tag) {
      this.sound_play_click()
      this.talk(tag)
      tag = this.tags_append(this.tag, tag).join(",")
      this.router_push({tag})
    },
    tag_remove_handle(tag) {
      this.sound_play_click()
      tag = this.tags_remove(this.tag, tag).join(",")
      this.router_push({tag})
    },
    search_handle() {
      this.sound_play_click()
      this.router_push({})
    },
  },
  computed: {
    tags() { return this.tags_wrap(this.tag) },
    SearchPresetInfo() { return SearchPresetInfo },
    search_preset_info() { return this.SearchPresetInfo.fetch(this.search_preset_key || this.SearchPresetInfo.values[0].key) },
  },
}
