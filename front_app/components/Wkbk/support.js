import _ from "lodash"

export const support = {
  methods: {
    tags_wrap(str) {
      return _.compact((str ?? "").split(/[,\s]+/))
    },
    tags_append(tags, append_tags) {
      tags = this.tags_wrap(tags)
      append_tags = this.tags_wrap(append_tags)
      return _.uniq([...tags, ...append_tags])
    },
    tags_remove(tags, remove_tags) {
      tags = this.tags_wrap(tags)
      remove_tags = this.tags_wrap(remove_tags)
      return _.reject(tags, e => remove_tags.includes(e))
    },
  },
  computed: {
    s_config() {
      return {
        TRUNCATE_MAX: 20,
      }
    },
  },
}
