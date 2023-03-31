import _ from "lodash"
import { Xstring } from "./xstring.js"

export const Xtag = {
  tags_add(tags, add_tags) {
    tags = Xstring.str_to_tags(tags)
    add_tags = Xstring.str_to_tags(add_tags)
    return _.uniq([...tags, ...add_tags])
  },

  tags_remove(tags, remove_tags) {
    tags = Xstring.str_to_tags(tags)
    remove_tags = Xstring.str_to_tags(remove_tags)
    return _.reject(tags, e => remove_tags.includes(e))
  },
}
