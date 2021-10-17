<template lang="pug">
.GalleryTopPagination.column.is-12
  //- https://buefy.org/documentation/pagination
  b-pagination(
    :total="base.total"
    :per-page="base.per"
    :current.sync="base.page"
    @change="base.page_change_handle"
    order="default"
    :simple="true"
    )
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "GalleryTopPagination",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.GalleryTopPagination
</style>
