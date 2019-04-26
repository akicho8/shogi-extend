import battle_index_mod from "./battle_index_mod.js"

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"
import dayjs from "dayjs"

window.FreeBattleIndex = Vue.extend({
  mixins: [battle_index_mod],

  data() {
    return {
    }
  },
})
