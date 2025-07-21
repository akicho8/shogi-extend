<template lang="pug">
.QuickScriptViewBody.columns.is-mobile.is-multiline(v-if="QS.params.body")
  //- .column.is-narrow
  .column.is-12
    QuickScriptViewValue(:value="QS.params.body")
</template>

<script>
export default {
  inject: ["QS"],
}
</script>
