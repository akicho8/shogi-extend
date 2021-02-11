<template lang="pug">
.WkbkFolder.is-flex.is-align-items-center
  b-icon(:icon="folder.icon" :type="folder.type" :size="size")
  .ml-1 {{folder.name}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "WkbkFolder",
  mixins: [support],
  props: {
    folder_key: { type: String, required: true,                       },
    size:       { type: String, required: false, default: "is-small", },
  },
  computed: {
    folder() { return this.FolderInfo.fetch(this.folder_key) },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.WkbkFolder
</style>
