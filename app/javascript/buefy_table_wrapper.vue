<template lang="pug">
.buefy_table_wrapper
  b-table(:data="info.rows" :mobile-cards="false" :hoverable="true" :columns="info.columns" narrowed)
</template>

<script>
export default {
  name: "buefy_table_wrapper",

  props: {
    info: { required: true },
  },

  created() {
    console.log(this.info)
  },

  data() {
    return {
    }
  },
}
</script>

<style lang="sass">
@import "./stylesheets/bulma_init.scss"
.buefy_table_wrapper
</style>
