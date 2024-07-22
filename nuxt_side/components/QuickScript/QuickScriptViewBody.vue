<template lang="pug">
.QuickScriptViewFormBody.columns.is-mobile.is-multiline(v-if="QS.params.body")
  .column.is-12
    QuickScriptViewValue(:value="QS.params.body")
</template>

<script>
export default {
  inject: ["QS"],
}
</script>
