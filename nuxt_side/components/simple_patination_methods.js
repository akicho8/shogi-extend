export const simple_patination_methods = {
  data () {
    return {
      total: null,
      per: null,
      page: null,
    }
  },
  created() {
    this.page = parseInt(this.$route.query.page || 1)
    this.per = parseInt(this.$route.query.per || this.default_per)
  },
  methods: {
    page_change_handle(page) {
      this.sound_play("click")
    },
  },
  computed: {
    default_per() { return 100                                                   },
    total_pages() { return Math.ceil(this.total / this.per)                      },
    offset()      { return this.per * (this.page - 1)                            },
    last_page_p() { return this.page >= this.total_pages                         },
    // default_per() { return 100                                                   },
    page_items()  { return this.last_page_p ? (this.total - this.offset) : this.per },
  },
}
