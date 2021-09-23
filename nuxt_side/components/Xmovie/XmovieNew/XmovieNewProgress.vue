<template lang="pug">
// .XmovieNewProgress.column.is-half
//   b-progress.mb-0(type="is-danger" :value="50" show-value format="percent")
//   .mt-2 変換中
.XmovieNewProgress.column.is-half(v-if="base.progress_info")
  b-progress.mb-0(type="is-danger" :value="base.progress_info.percent" show-value format="percent")
  .mt-2 {{base.progress_info.message}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieNewProgress",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XmovieNewProgress
</style>
