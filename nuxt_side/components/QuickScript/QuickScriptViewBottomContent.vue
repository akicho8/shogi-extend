<template lang="pug">
.QuickScriptViewBottomContent.columns.is-mobile.is-multiline(v-if="QS.params.bottom_content")
  //- .column.is-narrow
  .column.is-12
    QuickScriptViewValue(:value="QS.params.bottom_content")
</template>

<script>
export default {
  inject: ["QS"],
}
</script>
