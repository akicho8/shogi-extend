<template lang="pug">
.QuickScriptViewHeadContent.columns.is-mobile.is-multiline(v-if="QS.params.head_content")
  //- .column.is-narrow
  .column.is-12
    QuickScriptViewValue(:value="QS.params.head_content")
</template>

<script>
export default {
  inject: ["QS"],
}
</script>
