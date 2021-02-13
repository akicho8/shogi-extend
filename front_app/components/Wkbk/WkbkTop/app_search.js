export const app_search = {
  data() {
    return {
      query: null,
      tag:   null,
      search_p: !!this.$route.query.query,
    }
  },
  methods: {
    search_field_toggle_handle() {
      this.sound_play("click")
      this.search_p = !this.search_p
    },
    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      this.router_replace({tag})
    },
    search_handle() {
      this.sound_play("click")
      this.router_replace({})
    },
  },
  computed: {
  },
}
