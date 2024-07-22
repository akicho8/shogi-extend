<template lang="pug">
.QuickScriptViewFormButton.columns.is-mobile.is-multiline(v-if="QS.params.form_method")
  .column.is-12
    b-field(v-if="QS.params.form_method === 'get'")
      .control
        form(method="GET" @submit.prevent="QS.get_handle")
          b-button.get_handle(native-type="submit" type="is-primary")
            | {{QS.params.button_label}}
      .control(v-if="false")
        b-button.get_handle(@click="QS.get_handle" type="is-primary")
          | {{QS.params.button_label}}

    b-field(v-if="QS.params.form_method === 'post'")
      .control
        form(method="POST" @submit.prevent="QS.post_handle")
          b-button.post_handle(native-type="submit" type="is-danger")
            | {{QS.params.button_label}}
</template>

<script>
export default {
  name: "QuickScriptViewFormButton",
  inject: ["QS"],
}
</script>

<style lang="sass">
.QuickScriptViewFormButton
  __css_keep__: 0
</style>
