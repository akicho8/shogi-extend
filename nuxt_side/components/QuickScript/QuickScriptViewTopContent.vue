<template lang="pug">
.QuickScriptViewTopContent.columns.is-mobile.is-multiline(v-if="QS.params.top_content")
  //- .column.is-narrow
  .column.is-12
    QuickScriptViewValue(:value="QS.params.top_content")
</template>

<script>
export default {
  inject: ["QS"],
}
</script>
