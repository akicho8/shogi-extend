<template lang="pug">
.QuickScriptViewDebug.columns.is-mobile.is-multiline
  .column.is-12
    pre.is_line_break_on
      | {{QS.attributes}}
  .column.is-12
    pre.is_line_break_on
      | {{QS.current_api_url_internal}}
</template>

<script>
export default {
  name: "QuickScriptViewDebug",
  inject: ["QS"],
}
</script>

<style lang="sass">
.QuickScriptViewDebug
  __css_keep__: 0
</style>
