<template lang="pug">
.QuickScriptViewDefault(v-if="QS.params")
  template(v-if="QS.params.__delegate_mode__")
    QuickScriptViewValue(:value="QS.params.body")
  template(v-else)
    QuickScriptViewSidebar
    QuickScriptViewNavbar
    MainSection
      .container(:class="QS.container_class")
        QuickScriptViewTopContent
        QuickScriptViewBody(v-if="QS.params.body_position === 'above'")
        QuickScriptViewFormParts
        QuickScriptViewFormButton
        QuickScriptViewBody(v-if="QS.params.body_position === 'below'")
        QuickScriptViewBottomContent
        QuickScriptViewDebug(v-if="development_p")
</template>

<script>
export default {
  name: "QuickScriptViewDefault",
  inject: ["QS"],
}
</script>

<style lang="sass">
.QuickScriptViewDefault
  .MainSection.section
    +mobile
      padding: 1.5rem 0.75rem
    +tablet
      padding: 1.75rem 0rem

  .container
    +mobile
      padding: 0

.STAGE-development
  .QuickScriptViewDefault
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
