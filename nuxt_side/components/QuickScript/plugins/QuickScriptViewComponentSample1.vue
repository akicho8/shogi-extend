<template lang="pug">
Terms
//- ShareBoard2
</template>

<script>
import _ from "lodash"
import { GX } from "@/components/models/gs.js"
import Terms from "@/pages/about/terms.vue"
import ShareBoard2 from "@/pages/share-board/index.vue"

export default {
  inject: ["QS"],
  components: {
    Terms,
    ShareBoard2,
  },
}
</script>
